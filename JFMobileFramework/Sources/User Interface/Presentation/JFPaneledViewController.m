//
//  JFPaneledViewController.m
//  Copyright (C) 2014  Jacopo Filié
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//



#import "JFPaneledViewController.h"



// Custom types
typedef NS_ENUM(UInt8, JFPaneledViewControllerSlideTransition)
{
	JFPaneledViewControllerSlideTransitionNone,
	JFPaneledViewControllerSlideTransitionLeftToRoot,
	JFPaneledViewControllerSlideTransitionRightToRoot,
	JFPaneledViewControllerSlideTransitionRootToLeft,
	JFPaneledViewControllerSlideTransitionRootToRight,
};



@interface JFPaneledViewController () <UIGestureRecognizerDelegate>

// Attributes
@property (assign, nonatomic)	CGFloat			currentSlideDestination;
@property (assign, nonatomic)	NSTimeInterval	currentSlideDuration;
@property (assign, nonatomic)	CGFloat			currentSlideLength;	// The sign reveals the sliding direction ('-' => left; '+' => right).
@property (assign, nonatomic)	CGFloat			currentSlideOrigin;

// Flags
@property (assign, nonatomic)				BOOL									animating;
@property (assign, nonatomic)				BOOL									shouldCancelCurrentSlideTransition;
@property (assign, nonatomic)				JFPaneledViewControllerSlideTransition	slideTransition;
@property (assign, nonatomic, readwrite)	JFPaneledViewControllerState			state;

// Gesture recognizers
@property (strong, nonatomic, readonly)	UIPanGestureRecognizer*	panGestureRecognizer;

// User interface
@property (strong, nonatomic, readonly)	UIView*		leftPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rightPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rootPanelContainer;
@property (strong, nonatomic, readonly)	UIButton*	showRootPanelButton;

// Gesture recognizers management (Actions)
- (void)	panGestureRecognized:(UIPanGestureRecognizer*)recognizer;

// User interface management
- (void)	installShowRootPanelButton;
- (void)	uninstallShowRootPanelButton;
- (void)	updatePanelContainersFrames;

// User interface management (Actions)
- (void)	showRootPanelButtonTapped:(UIButton*)sender;

// User interface management (Sliding)
- (void)	cleanUp:(BOOL)finished animated:(BOOL)animated;
- (void)	completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity;
- (BOOL)	prepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition animated:(BOOL)animated;
- (BOOL)	prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated;
- (BOOL)	shouldPrepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition;
- (void)	slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(BlockWithBool)completion;
- (void)	updateCurrentSlideDistancesForTransition:(JFPaneledViewControllerSlideTransition)transition;

// Utilities
- (NSString*)	convertSlideTransitionToString:(JFPaneledViewControllerSlideTransition)slideTransition;
- (NSString*)	convertStateToString:(JFPaneledViewControllerState)state;

@end



@implementation JFPaneledViewController

#pragma mark - Properties

// Attributes
@synthesize currentSlideDestination	= _currentSlideDestination;
@synthesize currentSlideDuration	= _currentSlideDuration;
@synthesize currentSlideLength		= _currentSlideLength;
@synthesize currentSlideOrigin		= _currentSlideOrigin;
@synthesize	slideInDuration			= _slideInDuration;
@synthesize	slideOffset				= _slideOffset;
@synthesize	slideOutDuration		= _slideOutDuration;

// Flags
@synthesize animating							= _animating;
@synthesize shouldCancelCurrentSlideTransition	= _shouldCancelCurrentSlideTransition;
@synthesize slideTransition						= _slideTransition;
@synthesize	state								= _state;

// Gesture recognizers
@synthesize panGestureRecognizer	= _panGestureRecognizer;

// User interface
@synthesize	leftPanel			= _leftPanel;
@synthesize	leftPanelContainer	= _leftPanelContainer;
@synthesize	rightPanel			= _rightPanel;
@synthesize	rightPanelContainer	= _rightPanelContainer;
@synthesize	rootPanel			= _rootPanel;
@synthesize	rootPanelContainer	= _rootPanelContainer;
@synthesize showRootPanelButton	= _showRootPanelButton;

// Relationships
@synthesize	delegate	= _delegate;


#pragma mark - Properties accessors (Attributes)

- (void)setSlideOffset:(CGFloat)slideOffset
{
	if(_slideOffset == slideOffset)
		return;
	
	_slideOffset = slideOffset;
	
	if([self isViewLoaded])
		[self updatePanelContainersFrames];
}


#pragma mark - Properties accessors (Flags)

- (void)setSlideTransition:(JFPaneledViewControllerSlideTransition)slideTransition
{
	if(_slideTransition == slideTransition)
		return;
	
	NSString* oldSlideTransitionString = [self convertSlideTransitionToString:_slideTransition];
	NSString* newSlideTransitionString = [self convertSlideTransitionToString:slideTransition];
	NSLog(@"Slide transition changed from '%@' to '%@'.", oldSlideTransitionString, newSlideTransitionString);
	
	_slideTransition = slideTransition;
	
	if([self isViewLoaded])
		[self updateCurrentSlideDistancesForTransition:_slideTransition];
}

- (void)setState:(JFPaneledViewControllerState)state
{
	if(_state == state)
		return;
	
	NSString* oldStateString = [self convertStateToString:_state];
	NSString* newStateString = [self convertStateToString:state];
	NSLog(@"Panels state changed from '%@' to '%@'.", oldStateString, newStateString);
	
	_state = state;
}


#pragma mark - Properties accessors (User interface)

- (void)setLeftPanel:(UIViewController*)leftPanel
{
	if(_leftPanel == leftPanel)
		return;
	
	LogMethod;
	
	if(_leftPanel && [self isViewLoaded])
		[_leftPanel.view removeFromSuperview];
	
	_leftPanel = leftPanel;
	
	if(_leftPanel && [self isViewLoaded])
	{
		_leftPanel.view.frame = self.leftPanelContainer.bounds;
		[self.leftPanelContainer addSubview:leftPanel.view];
	}
}

- (void)setRightPanel:(UIViewController*)rightPanel
{
	if(_rightPanel == rightPanel)
		return;
	
	LogMethod;
	
	if(_rightPanel && [self isViewLoaded])
		[_rightPanel.view removeFromSuperview];
	
	_rightPanel = rightPanel;
	
	if(_rightPanel && [self isViewLoaded])
	{
		_rightPanel.view.frame = self.rightPanelContainer.bounds;
		[self.rightPanelContainer addSubview:_rightPanel.view];
	}
}

- (void)setRootPanel:(UIViewController*)rootPanel
{
	if(_rootPanel == rootPanel)
		return;
	
	LogMethod;
	
	if(_rootPanel && [self isViewLoaded])
		[_rootPanel.view removeFromSuperview];
	
	_rootPanel = rootPanel;
	
	if(_rootPanel && [self isViewLoaded])
	{
		_rootPanel.view.frame = self.rootPanelContainer.bounds;
		[self.rootPanelContainer addSubview:_rootPanel.view];
	}
}


#pragma mark - Memory management

- (id)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_currentSlideDestination = 0.0f;
		_currentSlideDuration = 0.0f;
		_currentSlideLength = 0.0f;
		_currentSlideOrigin = 0.0f;
		_slideInDuration = 0.25;
		_slideOffset = 40.0f;
		_slideOutDuration = 0.25;
		
		// Flags
		_animating = NO;
		_shouldCancelCurrentSlideTransition = NO;
		_slideTransition = JFPaneledViewControllerSlideTransitionNone;
		_state = JFPaneledViewControllerStateIsShowingRootPanel;
	}
	return self;
}



#pragma mark - User interface management

- (void)installShowRootPanelButton
{
	UIButton* button = self.showRootPanelButton;
	button.frame = self.rootPanelContainer.bounds;
	[self.rootPanelContainer addSubview:button];
}

- (BOOL)showLeftPanel
{
	return [self showLeftPanel:YES completion:nil];
}

- (BOOL)showLeftPanel:(BOOL)animated completion:(BlockWithBool)completion
{
	if(self.animating)
		return NO;
	
	if(self.state != JFPaneledViewControllerStateIsShowingRootPanel)
		return NO;
	
	if(![self prepareSlideWithTransition:JFPaneledViewControllerSlideTransitionRootToLeft animated:animated])
		return NO;
	
	BlockWithBool internalCompletion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:animated];
		if(completion)
			completion(finished);
	};
	
	[self slideWithTranslation:self.currentSlideLength animated:animated completion:internalCompletion];
	
	return YES;
}

- (BOOL)showRightPanel
{
	return [self showRightPanel:YES completion:nil];
}

- (BOOL)showRightPanel:(BOOL)animated completion:(BlockWithBool)completion
{
	if(self.animating)
		return NO;
	
	if(self.state != JFPaneledViewControllerStateIsShowingRootPanel)
		return NO;
	
	if(![self prepareSlideWithTransition:JFPaneledViewControllerSlideTransitionRootToRight animated:animated])
		return NO;
	
	BlockWithBool internalCompletion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:animated];
		if(completion)
			completion(finished);
	};
	
	[self slideWithTranslation:self.currentSlideLength animated:animated completion:internalCompletion];
	
	return YES;
}

- (BOOL)showRootPanel
{
	return [self showRootPanel:YES completion:nil];
}

- (BOOL)showRootPanel:(BOOL)animated completion:(BlockWithBool)completion
{
	if(self.animating)
		return NO;
	
	JFPaneledViewControllerSlideTransition transition;
	switch(self.state)
	{
		case JFPaneledViewControllerStateIsShowingLeftPanel:	transition = JFPaneledViewControllerSlideTransitionLeftToRoot;	break;
		case JFPaneledViewControllerStateIsShowingRightPanel:	transition = JFPaneledViewControllerSlideTransitionRightToRoot;	break;
			
		default:
			return NO;
	}
	
	if(![self prepareSlideWithTransition:transition animated:animated])
		return NO;
	
	BlockWithBool internalCompletion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:animated];
		if(completion)
			completion(finished);
	};
	
	[self slideWithTranslation:self.currentSlideLength animated:animated completion:internalCompletion];
	
	return YES;
}

- (void)uninstallShowRootPanelButton
{
	[self.showRootPanelButton removeFromSuperview];
}

- (void)updatePanelContainersFrames
{
	CGRect bounds = self.view.bounds;
	
	// Updates the left panel container frame.
	CGRect frame = bounds;
	frame.size.width = bounds.size.width - self.slideOffset;
	self.leftPanelContainer.frame = frame;
	
	// Updates the right panel container frame.
	frame = bounds;
	frame.origin.x = self.slideOffset;
	frame.size.width = bounds.size.width - self.slideOffset;
	self.rightPanelContainer.frame = frame;
	
	// Updates the root panel container frame.
	frame = bounds;
	switch(self.state)
	{
		case JFPaneledViewControllerStateIsShowingLeftPanel:
		{
			frame.origin.x = CGRectGetMaxX(self.leftPanelContainer.frame);
			break;
		}
		case JFPaneledViewControllerStateIsShowingRightPanel:
		{
			frame.origin.x = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(frame);
			break;
		}
		default:
			break;
	}
	self.rootPanelContainer.frame = frame;
	
	[self updateCurrentSlideDistancesForTransition:self.slideTransition];
}


#pragma mark - User interface management (Actions)

- (void)showRootPanelButtonTapped:(UIButton*)sender
{
	[self showRootPanel];
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// User interface.
	_leftPanelContainer = [[UIView alloc] init];
	_rightPanelContainer = [[UIView alloc] init];
	_rootPanelContainer = [[UIView alloc] init];
	_showRootPanelButton = [[UIButton alloc] init];
	
	// Gesture recognizers
	_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
	
	self.rootPanelContainer.clipsToBounds = YES;
	
	self.leftPanelContainer.backgroundColor = [UIColor lightGrayColor];
	self.rightPanelContainer.backgroundColor = [UIColor darkGrayColor];
	self.rootPanelContainer.backgroundColor = [UIColor blackColor];
	
	self.leftPanelContainer.hidden = YES;
	self.rightPanelContainer.hidden = YES;
	
	if(self.rootPanel)
	{
		self.rootPanel.view.frame = self.rootPanelContainer.bounds;
		[self.rootPanelContainer addSubview:self.rootPanel.view];
	}
	
	[self.view addSubview:self.leftPanelContainer];
	[self.view addSubview:self.rightPanelContainer];
	[self.view addSubview:self.rootPanelContainer];
	
	UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	self.leftPanelContainer.autoresizingMask = autoresizingMask;
	self.rightPanelContainer.autoresizingMask = autoresizingMask;
	self.rootPanelContainer.autoresizingMask = autoresizingMask;
	
	UIButton* button = self.showRootPanelButton;
	button.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[button addTarget:self action:@selector(showRootPanelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[self updatePanelContainersFrames];
	
	self.panGestureRecognizer.delegate = self;
	
	[self.rootPanelContainer addGestureRecognizer:self.panGestureRecognizer];
}


#pragma mark - User interface management (Sliding)

- (void)cleanUp:(BOOL)finished animated:(BOOL)animated
{
	BOOL shouldCancel = self.shouldCancelCurrentSlideTransition;
	
	BOOL didHidePanel = NO;
	BOOL didShowPanel = NO;
	BOOL shouldUninstallShowRootPanelButton = NO;
	UIViewController* panel = nil;
	UIView* panelContainer = nil;
	JFPaneledViewControllerState state = self.state;
	
	switch(self.slideTransition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		{
			didHidePanel = YES;
			
			if(self.slideTransition == JFPaneledViewControllerSlideTransitionLeftToRoot)
			{
				panel = self.leftPanel;
				panelContainer = self.leftPanelContainer;
			}
			else
			{
				panel = self.rightPanel;
				panelContainer = self.rightPanelContainer;
			}
			
			if(shouldCancel)
				break;
			
			shouldUninstallShowRootPanelButton = YES;
			state = JFPaneledViewControllerStateIsShowingRootPanel;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			didShowPanel = YES;
			panel = self.leftPanel;
			panelContainer = self.leftPanelContainer;
			
			if(shouldCancel)
			{
				shouldUninstallShowRootPanelButton = YES;
				break;
			}
			
			state = JFPaneledViewControllerStateIsShowingLeftPanel;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			didShowPanel = YES;
			panel = self.rightPanel;
			panelContainer = self.rightPanelContainer;
			
			if(shouldCancel)
			{
				shouldUninstallShowRootPanelButton = YES;
				break;
			}
			
			state = JFPaneledViewControllerStateIsShowingRightPanel;
			break;
		}
		default:
			break;
	}
	
	if(shouldUninstallShowRootPanelButton)
		[self uninstallShowRootPanelButton];
	
	self.animating = NO;
	self.shouldCancelCurrentSlideTransition = NO;
	self.slideTransition = JFPaneledViewControllerSlideTransitionNone;
	
	if(shouldCancel)
	{
		if(didHidePanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didCancelHidePanel:)])
				[self.delegate paneledViewController:self didCancelHidePanel:panel];
		}
		
		if(didShowPanel)
		{
			panelContainer.hidden = YES;
			
			[panel viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didCancelShowPanel:)])
				[self.delegate paneledViewController:self didCancelShowPanel:panel];
		}
	}
	else
	{
		self.state = state;
		
		panelContainer.userInteractionEnabled = YES;
		
		if(didHidePanel)
		{
			panelContainer.hidden = YES;
			
			[panel viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didHidePanel:)])
				[self.delegate paneledViewController:self didHidePanel:panel];
		}
		
		if(didShowPanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didShowPanel:)])
				[self.delegate paneledViewController:self didShowPanel:panel];
		}
	}
}

- (void)completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity
{
	if(velocity != 0.0f)
	{
		switch(self.slideTransition)
		{
			case JFPaneledViewControllerSlideTransitionLeftToRoot:
			case JFPaneledViewControllerSlideTransitionRootToRight:
			{
				translation = ((velocity > 0.0f) ? 0.0f : self.currentSlideLength);
				break;
			}
			case JFPaneledViewControllerSlideTransitionRightToRoot:
			case JFPaneledViewControllerSlideTransitionRootToLeft:
			{
				translation = ((velocity < 0.0f) ? 0.0f : self.currentSlideLength);
				break;
			}
			default:
				break;
		}
	}
	else
		translation = ((fabsf(translation) >= fabsf(self.currentSlideLength / 2.0f)) ? self.currentSlideLength : 0.0f);
	
	self.shouldCancelCurrentSlideTransition = (translation == 0.0f);
	
	BlockWithBool completion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:YES];
	};
	
	[self slideWithTranslation:translation animated:YES completion:completion];
}

- (BOOL)prepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition animated:(BOOL)animated
{
	if(self.animating)
		return NO;
	
	if(![self shouldPrepareSlideWithTransition:transition])
		return NO;
	
	[self updateCurrentSlideDistancesForTransition:transition];
	
	BOOL shouldInstallShowRootPanelButton = NO;
	BOOL willHidePanel = NO;
	BOOL willShowPanel = NO;
	UIViewController* panel = nil;
	UIView* panelContainer = nil;
	
	switch(transition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		{
			panel = self.leftPanel;
			panelContainer = self.leftPanelContainer;
			willHidePanel = YES;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		{
			panel = self.rightPanel;
			panelContainer = self.rightPanelContainer;
			willHidePanel = YES;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			panel = self.leftPanel;
			panelContainer = self.leftPanelContainer;
			shouldInstallShowRootPanelButton = YES;
			willShowPanel = YES;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			panel = self.rightPanel;
			panelContainer = self.rightPanelContainer;
			shouldInstallShowRootPanelButton = YES;
			willShowPanel = YES;
			break;
		}
		default:
			return NO;
	}
	
	panelContainer.userInteractionEnabled = NO;
	
	if(willHidePanel)
	{
		[panel viewWillDisappear:animated];
		if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:willHidePanel:)])
			[self.delegate paneledViewController:self willHidePanel:panel];
	}
	
	if(willShowPanel)
	{
		[panel viewWillAppear:animated];
		if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:willShowPanel:)])
			[self.delegate paneledViewController:self willShowPanel:panel];
		
		panelContainer.hidden = NO;
		
		[panel viewDidAppear:animated];
	}
	
	if(shouldInstallShowRootPanelButton)
		[self installShowRootPanelButton];
	
	self.animating = YES;
	self.slideTransition = transition;
	
	return YES;
}

- (BOOL)prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated
{
	JFPaneledViewControllerSlideTransition transition = JFPaneledViewControllerSlideTransitionNone;
	JFPaneledViewControllerState state = self.state;
	
	if(translation > 0.0f)
	{
		if(state == JFPaneledViewControllerStateIsShowingRootPanel)
			transition = JFPaneledViewControllerSlideTransitionRootToLeft;
		else if(state == JFPaneledViewControllerStateIsShowingRightPanel)
			transition = JFPaneledViewControllerSlideTransitionRightToRoot;
	}
	else if(translation < 0.0f)
	{
		if(state == JFPaneledViewControllerStateIsShowingRootPanel)
			transition = JFPaneledViewControllerSlideTransitionRootToRight;
		else if(state == JFPaneledViewControllerStateIsShowingLeftPanel)
			transition = JFPaneledViewControllerSlideTransitionLeftToRoot;
	}
	
	return [self prepareSlideWithTransition:transition animated:animated];
}

- (BOOL)shouldPrepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition
{
	if(!self.delegate)
		return YES;
	
	BOOL retVal = YES;
	switch(transition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		{
			if([self.delegate respondsToSelector:@selector(paneledViewController:shouldShowRootPanel:)])
				retVal = [self.delegate paneledViewController:self shouldShowRootPanel:self.rootPanel];
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			if([self.delegate respondsToSelector:@selector(paneledViewController:shouldShowLeftPanel:)])
				retVal = [self.delegate paneledViewController:self shouldShowLeftPanel:self.leftPanel];
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			if([self.delegate respondsToSelector:@selector(paneledViewController:shouldShowRightPanel:)])
				retVal = [self.delegate paneledViewController:self shouldShowRightPanel:self.rightPanel];
			break;
		}
		default:
		{
			retVal = NO;
			break;
		}
	}
	return retVal;
}

- (void)slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(BlockWithBool)completion
{
	if(!self.animating)
		return;
	
	CGFloat destination = self.currentSlideOrigin + translation;
	
	switch(self.slideTransition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			destination = MIN(destination, self.currentSlideOrigin);
			destination = MAX(destination, self.currentSlideDestination);
			break;
		}
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			destination = MIN(destination, self.currentSlideDestination);
			destination = MAX(destination, self.currentSlideOrigin);
			break;
		}
		default:
			break;
	}
	
	NSTimeInterval duration = (animated ? self.currentSlideDuration : 0.0f);
	
	CGRect frame = self.rootPanelContainer.frame;
	frame.origin.x = destination;
	
	Block animations = ^(void)
	{
		self.rootPanelContainer.frame = frame;
	};
	
	[UIView animateWithDuration:duration animations:animations completion:completion];
}

- (void)updateCurrentSlideDistancesForTransition:(JFPaneledViewControllerSlideTransition)transition
{
	switch(transition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		{
			self.currentSlideOrigin = CGRectGetMaxX(self.leftPanelContainer.frame);
			self.currentSlideDestination = 0.0f;
			self.currentSlideDuration = self.slideOutDuration;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		{
			self.currentSlideOrigin = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(self.rootPanelContainer.frame);
			self.currentSlideDestination = 0.0f;
			self.currentSlideDuration = self.slideOutDuration;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			self.currentSlideOrigin = 0.0f;
			self.currentSlideDestination = CGRectGetMaxX(self.leftPanelContainer.frame);
			self.currentSlideDuration = self.slideInDuration;
			break;
		}
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			self.currentSlideOrigin = 0.0f;
			self.currentSlideDestination = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(self.rootPanelContainer.frame);
			self.currentSlideDuration = self.slideInDuration;
			break;
		}
		case JFPaneledViewControllerSlideTransitionNone:
		{
			self.currentSlideOrigin = 0.0f;
			self.currentSlideDestination = 0.0f;
			self.currentSlideDuration = 0.0f;
			break;
		}
		default:
			return;
	}
	
	self.currentSlideLength = self.currentSlideDestination - self.currentSlideOrigin;
}


#pragma mark - Gesture recognizers actions

- (void)panGestureRecognized:(UIPanGestureRecognizer*)recognizer
{
	CGPoint translation = [recognizer translationInView:self.view];
	switch(recognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			NSLog(@"UIGestureRecognizerStateBegan");
			[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			NSLog(@"UIGestureRecognizerStateChanged");
			if(self.animating)
				[self slideWithTranslation:translation.x animated:NO completion:nil];
			else
				[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			NSLog(@"UIGestureRecognizerStateEnded");
			CGPoint velocity = [recognizer velocityInView:self.view];
			[self completeSlideWithTranslation:translation.x velocity:velocity.x];
			break;
		}
		case UIGestureRecognizerStateCancelled:
		{
			NSLog(@"UIGestureRecognizerStateCancelled");
			[self completeSlideWithTranslation:0.0f velocity:0.0f];
			break;
		}
		case UIGestureRecognizerStateFailed:
		{
			NSLog(@"UIGestureRecognizerStateFailed");
			[self completeSlideWithTranslation:0.0f velocity:0.0f];
			break;
		}
		default:
			break;
	}
}


#pragma mark - Protocol implementation (UIGestureRecognizerDelegate)

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
	if(gestureRecognizer == self.panGestureRecognizer)
	{
		CGPoint translation = [self.panGestureRecognizer translationInView:self.view];
		if(fabsf(translation.y) > fabsf(translation.x))
			return NO;
	}
	
	return YES;
}


#pragma mark - Utilities

- (NSString*)convertSlideTransitionToString:(JFPaneledViewControllerSlideTransition)slideTransition
{
	NSString* retVal;
	switch(slideTransition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:	retVal = @"Left => Root";	break;
		case JFPaneledViewControllerSlideTransitionRightToRoot:	retVal = @"Right => Root";	break;
		case JFPaneledViewControllerSlideTransitionRootToLeft:	retVal = @"Root => Left";	break;
		case JFPaneledViewControllerSlideTransitionRootToRight:	retVal = @"Root => Right";	break;
		case JFPaneledViewControllerSlideTransitionNone:		retVal = @"None";			break;
		default:												retVal = @"Unknown";		break;
	}
	return retVal;
}

- (NSString*)convertStateToString:(JFPaneledViewControllerState)state
{
	NSString* retVal;
	switch(state)
	{
		case JFPaneledViewControllerStateIsShowingLeftPanel:	retVal = @"Showing Left Panel";		break;
		case JFPaneledViewControllerStateIsShowingRightPanel:	retVal = @"Showing Right Panel";	break;
		case JFPaneledViewControllerStateIsShowingRootPanel:	retVal = @"Showing Root Panel";		break;
		default:												retVal = @"Unknown";				break;
	}
	return retVal;
}

@end

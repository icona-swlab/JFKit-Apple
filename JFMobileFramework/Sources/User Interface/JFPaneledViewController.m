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

// Gesture recognizers actions
- (void)	panGestureRecognized:(UIPanGestureRecognizer*)recognizer;

// User interface actions
- (void)	showRootPanelButtonTapped:(UIButton*)sender;

// User interface management
- (void)	installShowRootPanelButton;
- (void)	uninstallShowRootPanelButton;
- (void)	updatePanelContainersFrames;

// User interface management (Sliding)
- (void)	cleanUp:(BOOL)finished animated:(BOOL)animated;
- (void)	completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity;
- (void)	prepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition animated:(BOOL)animated;
- (void)	prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated;
- (void)	slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(BlockWithBool)completion;
- (void)	updateCurrentSlideDistancesForTransition:(JFPaneledViewControllerSlideTransition)transition;

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


#pragma mark - Properties accessors (User interface)

- (void)setLeftPanel:(UIViewController*)leftPanel
{
	if(_leftPanel == leftPanel)
		return;
	
	if(_leftPanel && [self isViewLoaded])
		[_leftPanel.view removeFromSuperview];
	
	_leftPanel = leftPanel;
	
	if([self isViewLoaded])
	{
		_leftPanel.view.frame = self.leftPanelContainer.bounds;
		[self.leftPanelContainer addSubview:leftPanel.view];
	}
}

- (void)setRightPanel:(UIViewController*)rightPanel
{
	if(_rightPanel == rightPanel)
		return;
	
	if(_rightPanel && [self isViewLoaded])
		[_rightPanel.view removeFromSuperview];
	
	_rightPanel = rightPanel;
	
	if([self isViewLoaded])
	{
		_rightPanel.view.frame = self.rightPanelContainer.bounds;
		[self.rightPanelContainer addSubview:_rightPanel.view];
	}
}

- (void)setRootPanel:(UIViewController*)rootPanel
{
	if(_rootPanel == rootPanel)
		return;
	
	if(_rootPanel && [self isViewLoaded])
		[_rootPanel.view removeFromSuperview];
	
	_rootPanel = rootPanel;
	
	if([self isViewLoaded])
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
		
		// Gesture recognizers
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
		
		// Layout
		_leftPanelContainer = [[UIView alloc] init];
		_rightPanelContainer = [[UIView alloc] init];
		_rootPanelContainer = [[UIView alloc] init];
		_showRootPanelButton = [[UIButton alloc] init];
	}
	return self;
}



#pragma mark - User interface actions

- (void)showRootPanelButtonTapped:(UIButton*)sender
{
	[self showRootPanel];
}


#pragma mark - User interface management

- (void)installShowRootPanelButton
{
	UIButton* button = self.showRootPanelButton;
	button.frame = self.rootPanelContainer.bounds;
	[self.rootPanelContainer addSubview:button];
	
	[self.rootPanelContainer removeGestureRecognizer:self.panGestureRecognizer];
	[button addGestureRecognizer:self.panGestureRecognizer];
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
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:shouldShowLeftPanel:)])
		if(![self.delegate paneledViewController:self shouldShowLeftPanel:self.leftPanel])
			return NO;
	
	[self prepareSlideWithTransition:JFPaneledViewControllerSlideTransitionRootToLeft animated:animated];
	
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
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:shouldShowRightPanel:)])
		if(![self.delegate paneledViewController:self shouldShowRightPanel:self.rightPanel])
			return NO;
	
	[self prepareSlideWithTransition:JFPaneledViewControllerSlideTransitionRootToRight animated:animated];
	
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
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:shouldShowRootPanel:)])
		if(![self.delegate paneledViewController:self shouldShowRootPanel:self.rootPanel])
			return NO;
	
	[self prepareSlideWithTransition:transition animated:animated];
	
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
	
	[self.showRootPanelButton removeGestureRecognizer:self.panGestureRecognizer];
	[self.rootPanelContainer addGestureRecognizer:self.panGestureRecognizer];
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


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
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
	
	self.panGestureRecognizer.delegate = self;
	
	[self.rootPanelContainer addGestureRecognizer:self.panGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self updatePanelContainersFrames];
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
	
	if(shouldCancel)
	{
		if(didHidePanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didCancelHidePanel:)])
				[self.delegate paneledViewController:self didCancelHidePanel:panel];
		}
		
		if(didShowPanel)
		{
			[panel viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didCancelShowPanel:)])
				[self.delegate paneledViewController:self didCancelShowPanel:panel];
			
			panelContainer.hidden = YES;
		}
	}
	else
	{
		self.state = state;
		
		panelContainer.userInteractionEnabled = YES;
		
		if(didHidePanel)
		{
			[panel viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didHidePanel:)])
				[self.delegate paneledViewController:self didHidePanel:panel];
			
			panelContainer.hidden = YES;
		}
		
		if(didShowPanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(paneledViewController:didShowPanel:)])
				[self.delegate paneledViewController:self didShowPanel:panel];
		}
	}
	
	self.animating = NO;
	self.shouldCancelCurrentSlideTransition = NO;
	self.slideTransition = JFPaneledViewControllerSlideTransitionNone;
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
		translation = ((ABS(translation) >= ABS(self.currentSlideLength / 2.0f)) ? self.currentSlideLength : 0.0f);
	
	self.shouldCancelCurrentSlideTransition = (translation == 0.0f);
	
	BlockWithBool completion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:YES];
	};
	
	[self slideWithTranslation:translation animated:YES completion:completion];
}

- (void)prepareSlideWithTransition:(JFPaneledViewControllerSlideTransition)transition animated:(BOOL)animated
{
	if(transition == JFPaneledViewControllerSlideTransitionNone)
		return;
	
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
			return;
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
}

- (void)prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated
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
	
	[self prepareSlideWithTransition:transition animated:animated];
}

- (void)slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(BlockWithBool)completion
{
	if(!self.animating)
		return;
	
	CGFloat position = self.currentSlideOrigin + translation;
	
	switch(self.slideTransition)
	{
		case JFPaneledViewControllerSlideTransitionLeftToRoot:
		case JFPaneledViewControllerSlideTransitionRootToRight:
		{
			position = MIN(position, self.currentSlideOrigin);
			position = MAX(position, self.currentSlideDestination);
			break;
		}
		case JFPaneledViewControllerSlideTransitionRightToRoot:
		case JFPaneledViewControllerSlideTransitionRootToLeft:
		{
			position = MIN(position, self.currentSlideDestination);
			position = MAX(position, self.currentSlideOrigin);
			break;
		}
		default:
			break;
	}
	
	NSTimeInterval duration = (animated ? self.currentSlideDuration : 0.0f);
	
	CGRect frame = self.rootPanelContainer.frame;
	frame.origin.x = position;
	
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
			//NSLog(@"UIGestureRecognizerStateBegan");
			[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			//NSLog(@"UIGestureRecognizerStateChanged");
			if(self.animating)
				[self slideWithTranslation:translation.x animated:NO completion:nil];
			else
				[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			//NSLog(@"UIGestureRecognizerStateEnded");
			CGPoint velocity = [recognizer velocityInView:self.view];
			[self completeSlideWithTranslation:translation.x velocity:velocity.x];
			break;
		}
		case UIGestureRecognizerStateCancelled:
		{
			//NSLog(@"UIGestureRecognizerStateCancelled");
			[self completeSlideWithTranslation:0.0f velocity:0.0f];
			break;
		}
		case UIGestureRecognizerStateFailed:
		{
			//NSLog(@"UIGestureRecognizerStateFailed");
			[self completeSlideWithTranslation:0.0f velocity:0.0f];
			break;
		}
		default:
			break;
	}
}


#pragma mark - Delegation management (UIGestureRecognizerDelegate)

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
	if(gestureRecognizer == self.panGestureRecognizer)
	{
		CGPoint translation = [self.panGestureRecognizer translationInView:self.view];
		if(fabs(translation.y) > fabs(translation.x))
			return NO;
	}
	
	return YES;
}

@end

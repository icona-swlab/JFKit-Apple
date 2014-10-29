//
//  JFSliderController.m
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



#import "JFSliderController.h"



// Custom types
typedef NS_ENUM(UInt8, JFSliderControllerTransition)
{
	JFSliderControllerTransitionNone,
	JFSliderControllerTransitionLeftToRoot,
	JFSliderControllerTransitionRightToRoot,
	JFSliderControllerTransitionRootToLeft,
	JFSliderControllerTransitionRootToRight,
};



@interface JFSliderController () <UIGestureRecognizerDelegate>

// Attributes
@property (assign, nonatomic)	CGFloat			currentSlideDestination;
@property (assign, nonatomic)	NSTimeInterval	currentSlideDuration;
@property (assign, nonatomic)	CGFloat			currentSlideLength;	// The sign reveals the sliding direction ('-' => left; '+' => right).
@property (assign, nonatomic)	CGFloat			currentSlideOrigin;

// Flags
@property (assign, nonatomic)				BOOL							animating;
@property (assign, nonatomic, readwrite)	JFSliderControllerPanel			currentFocalPanel;
@property (assign, nonatomic)				JFSliderControllerTransition	currentTransition;
@property (assign, nonatomic)				BOOL							shouldCancelCurrentTransition;

// Gesture recognizers
@property (strong, nonatomic, readonly)	UIPanGestureRecognizer*	panGestureRecognizer;

// User interface
@property (strong, nonatomic, readonly)	UIView*		leftPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rightPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rootPanelContainer;
@property (strong, nonatomic, readonly)	UIButton*	showRootPanelButton;

// User interface management
- (void)	installShowRootPanelButton;
- (void)	uninstallShowRootPanelButton;
- (void)	updatePanelContainersFrames;

// User interface management (Actions)
- (void)	showRootPanelButtonTapped:(UIButton*)sender;

// User interface management (Sliding)
- (void)	cleanUp:(BOOL)finished animated:(BOOL)animated;
- (void)	completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity;
- (BOOL)	prepareSlideWithTransition:(JFSliderControllerTransition)transition animated:(BOOL)animated;
- (BOOL)	prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated;
- (BOOL)	shouldPrepareSlideWithTransition:(JFSliderControllerTransition)transition;
- (void)	slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(BlockWithBool)completion;
- (void)	updateCurrentSlideDistancesForTransition:(JFSliderControllerTransition)transition;

// Gesture recognizers management (Actions)
- (void)	panGestureRecognized:(UIPanGestureRecognizer*)recognizer;

// Utilities
+ (NSString*)	convertTransitionToString:(JFSliderControllerTransition)transition;
- (NSString*)	convertTransitionToString:(JFSliderControllerTransition)transition;

@end



@implementation JFSliderController

#pragma mark - Properties

// Attributes
@synthesize currentSlideDestination	= _currentSlideDestination;
@synthesize currentSlideDuration	= _currentSlideDuration;
@synthesize currentSlideLength		= _currentSlideLength;
@synthesize currentSlideOrigin		= _currentSlideOrigin;
@synthesize	slideInDuration			= _slideInDuration;
@synthesize	slideInsets				= _slideInsets;
@synthesize	slideOutDuration		= _slideOutDuration;

// Flags
@synthesize animating						= _animating;
@synthesize	currentFocalPanel				= _currentFocalPanel;
@synthesize currentTransition				= _currentTransition;
@synthesize shouldCancelCurrentTransition	= _shouldCancelCurrentTransition;

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

- (void)setSlideInsets:(UIEdgeInsets)slideInsets
{
	if(UIEdgeInsetsEqualToEdgeInsets(_slideInsets, slideInsets))
		return;
	
	_slideInsets = slideInsets;
	
	if([self isViewLoaded])
		[self updatePanelContainersFrames];
}


#pragma mark - Properties accessors (Flags)

- (void)setCurrentFocalPanel:(JFSliderControllerPanel)currentFocalPanel
{
	if(_currentFocalPanel == currentFocalPanel)
		return;
	
	NSString* oldStateString = [self convertPanelToString:_currentFocalPanel];
	NSString* newStateString = [self convertPanelToString:currentFocalPanel];
	NSLog(@"%@: focal panel changed from '%@' to '%@'.", ClassName, oldStateString, newStateString);
	
	_currentFocalPanel = currentFocalPanel;
}

- (void)setCurrentTransition:(JFSliderControllerTransition)currentTransition
{
	if(_currentTransition == currentTransition)
		return;
	
	NSString* oldTransitionString = [self convertTransitionToString:_currentTransition];
	NSString* newTransitionString = [self convertTransitionToString:currentTransition];
	NSLog(@"%@: transition changed from '%@' to '%@'.", ClassName, oldTransitionString, newTransitionString);
	
	_currentTransition = currentTransition;
	
	if([self isViewLoaded])
		[self updateCurrentSlideDistancesForTransition:_currentTransition];
}


#pragma mark - Properties accessors (User interface)

- (void)setLeftPanel:(UIViewController*)leftPanel
{
	if(_leftPanel == leftPanel)
		return;
	
	if(_leftPanel && [self isViewLoaded])
		[_leftPanel.view removeFromSuperview];
	
	_leftPanel = leftPanel;
	
	if(_leftPanel && [self isViewLoaded])
	{
		_leftPanel.view.frame = self.leftPanelContainer.bounds;
		[self.leftPanelContainer addSubview:_leftPanel.view];
		[self.leftPanelContainer sendSubviewToBack:_leftPanel.view];
	}
}

- (void)setRightPanel:(UIViewController*)rightPanel
{
	if(_rightPanel == rightPanel)
		return;
	
	if(_rightPanel && [self isViewLoaded])
		[_rightPanel.view removeFromSuperview];
	
	_rightPanel = rightPanel;
	
	if(_rightPanel && [self isViewLoaded])
	{
		_rightPanel.view.frame = self.rightPanelContainer.bounds;
		[self.rightPanelContainer addSubview:_rightPanel.view];
		[self.rightPanelContainer sendSubviewToBack:_rightPanel.view];
	}
}

- (void)setRootPanel:(UIViewController*)rootPanel
{
	if(_rootPanel == rootPanel)
		return;
	
	if(_rootPanel && [self isViewLoaded])
		[_rootPanel.view removeFromSuperview];
	
	_rootPanel = rootPanel;
	
	if(_rootPanel && [self isViewLoaded])
	{
		_rootPanel.view.frame = self.rootPanelContainer.bounds;
		[self.rootPanelContainer addSubview:_rootPanel.view];
		[self.rootPanelContainer sendSubviewToBack:_rootPanel.view];
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
		_slideInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
		_slideOutDuration = 0.25;
		
		// Flags
		_animating = NO;
		_shouldCancelCurrentTransition = NO;
		_currentTransition = JFSliderControllerTransitionNone;
		_currentFocalPanel = JFSliderControllerPanelRoot;
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

- (BOOL)showPanel:(JFSliderControllerPanel)panel
{
	return [self showPanel:panel animated:YES completion:nil];
}

- (BOOL)showPanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(BlockWithBool)completion
{
	if(self.animating)
		return NO;
	
	if((self.currentFocalPanel != JFSliderControllerPanelRoot) && (panel != JFSliderControllerPanelRoot))
		return NO;
	
	JFSliderControllerTransition transition;
	switch(self.currentFocalPanel)
	{
		case JFSliderControllerPanelLeft:	transition = JFSliderControllerTransitionLeftToRoot;	break;
		case JFSliderControllerPanelRight:	transition = JFSliderControllerTransitionRightToRoot;	break;
		case JFSliderControllerPanelRoot:
		{
			switch(panel)
			{
				case JFSliderControllerPanelLeft:	transition = JFSliderControllerTransitionRootToLeft;	break;
				case JFSliderControllerPanelRight:	transition = JFSliderControllerTransitionRootToRight;	break;
				default:
					return NO;
			}
			break;
		}
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
	UIEdgeInsets insets = self.slideInsets;
	
	// Updates the left panel container frame.
	CGRect frame = bounds;
	frame.size.width = bounds.size.width - insets.left;
	self.leftPanelContainer.frame = frame;
	
	// Updates the right panel container frame.
	frame = bounds;
	frame.origin.x = insets.right;
	frame.size.width = bounds.size.width - insets.right;
	self.rightPanelContainer.frame = frame;
	
	// Updates the root panel container frame.
	frame = bounds;
	switch(self.currentFocalPanel)
	{
		case JFSliderControllerPanelLeft:
		{
			frame.origin.x = CGRectGetMaxX(self.leftPanelContainer.frame);
			break;
		}
		case JFSliderControllerPanelRight:
		{
			frame.origin.x = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(frame);
			break;
		}
		default:
			break;
	}
	self.rootPanelContainer.frame = frame;
	
	[self updateCurrentSlideDistancesForTransition:self.currentTransition];
}


#pragma mark - User interface management (Actions)

- (void)showRootPanelButtonTapped:(UIButton*)sender
{
	[self showPanel:JFSliderControllerPanelRoot];
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
	BOOL shouldCancel = self.shouldCancelCurrentTransition;
	
	BOOL didHidePanel = NO;
	BOOL didShowPanel = NO;
	BOOL shouldUninstallShowRootPanelButton = NO;
	
	JFSliderControllerPanel currentFocalPanel = self.currentFocalPanel;
	JFSliderControllerPanel panel = currentFocalPanel;
	UIView* panelContainer = nil;
	UIViewController* panelController = nil;
	
	switch(self.currentTransition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		case JFSliderControllerTransitionRightToRoot:
		{
			didHidePanel = YES;
			panel = ((self.currentTransition == JFSliderControllerTransitionLeftToRoot) ? JFSliderControllerPanelLeft : JFSliderControllerPanelRight);
			panelContainer = ((self.currentTransition == JFSliderControllerTransitionLeftToRoot) ? self.leftPanelContainer : self.rightPanelContainer);
			panelController = ((self.currentTransition == JFSliderControllerTransitionLeftToRoot) ? self.leftPanel : self.rightPanel);
			
			if(shouldCancel)
				break;
			
			currentFocalPanel = JFSliderControllerPanelRoot;
			shouldUninstallShowRootPanelButton = YES;
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			didShowPanel = YES;
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftPanel;
			
			if(shouldCancel)
			{
				shouldUninstallShowRootPanelButton = YES;
				break;
			}
			
			currentFocalPanel = JFSliderControllerPanelLeft;
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			didShowPanel = YES;
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightPanel;
			
			if(shouldCancel)
			{
				shouldUninstallShowRootPanelButton = YES;
				break;
			}
			
			currentFocalPanel = JFSliderControllerPanelRight;
			break;
		}
		default:
			break;
	}
	
	if(shouldUninstallShowRootPanelButton)
		[self uninstallShowRootPanelButton];
	
	self.animating = NO;
	self.shouldCancelCurrentTransition = NO;
	self.currentTransition = JFSliderControllerTransitionNone;
	
	if(shouldCancel)
	{
		if(didHidePanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:didCancelHidePanel:)])
				[self.delegate sliderController:self didCancelHidePanel:panel];
		}
		
		if(didShowPanel)
		{
			panelContainer.hidden = YES;
			
			[panelController viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:didCancelShowPanel:)])
				[self.delegate sliderController:self didCancelShowPanel:panel];
		}
	}
	else
	{
		self.currentFocalPanel = currentFocalPanel;
		
		panelContainer.userInteractionEnabled = YES;
		
		if(didHidePanel)
		{
			panelContainer.hidden = YES;
			
			[panelController viewDidDisappear:animated];
			if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:didHidePanel:)])
				[self.delegate sliderController:self didHidePanel:panel];
		}
		
		if(didShowPanel)
		{
			if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:didShowPanel:)])
				[self.delegate sliderController:self didShowPanel:panel];
		}
	}
}

- (void)completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity
{
	if(velocity != 0.0f)
	{
		switch(self.currentTransition)
		{
			case JFSliderControllerTransitionLeftToRoot:
			case JFSliderControllerTransitionRootToRight:
			{
				translation = ((velocity > 0.0f) ? 0.0f : self.currentSlideLength);
				break;
			}
			case JFSliderControllerTransitionRightToRoot:
			case JFSliderControllerTransitionRootToLeft:
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
	
	self.shouldCancelCurrentTransition = (translation == 0.0f);
	
	BlockWithBool completion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:YES];
	};
	
	[self slideWithTranslation:translation animated:YES completion:completion];
}

- (BOOL)prepareSlideWithTransition:(JFSliderControllerTransition)transition animated:(BOOL)animated
{
	if(self.animating)
		return NO;
	
	if(![self shouldPrepareSlideWithTransition:transition])
		return NO;
	
	[self updateCurrentSlideDistancesForTransition:transition];
	
	BOOL shouldInstallShowRootPanelButton = NO;
	BOOL willHidePanel = NO;
	BOOL willShowPanel = NO;
	
	JFSliderControllerPanel panel;
	UIView* panelContainer = nil;
	UIViewController* panelController = nil;
	
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		{
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftPanel;
			willHidePanel = YES;
			break;
		}
		case JFSliderControllerTransitionRightToRoot:
		{
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightPanel;
			willHidePanel = YES;
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftPanel;
			shouldInstallShowRootPanelButton = YES;
			willShowPanel = YES;
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightPanel;
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
		[panelController viewWillDisappear:animated];
		if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:willHidePanel:)])
			[self.delegate sliderController:self willHidePanel:panel];
	}
	
	if(willShowPanel)
	{
		[panelController viewWillAppear:animated];
		if(self.delegate && [self.delegate respondsToSelector:@selector(sliderController:willShowPanel:)])
			[self.delegate sliderController:self willShowPanel:panel];
		
		panelContainer.hidden = NO;
		
		[panelController viewDidAppear:animated];
	}
	
	if(shouldInstallShowRootPanelButton)
		[self installShowRootPanelButton];
	
	self.animating = YES;
	self.currentTransition = transition;
	
	return YES;
}

- (BOOL)prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated
{
	JFSliderControllerTransition transition = JFSliderControllerTransitionNone;
	JFSliderControllerPanel currentFocalPanel = self.currentFocalPanel;
	
	if(translation > 0.0f)
	{
		if(currentFocalPanel == JFSliderControllerPanelRoot)
			transition = JFSliderControllerTransitionRootToLeft;
		else if(currentFocalPanel == JFSliderControllerPanelRight)
			transition = JFSliderControllerTransitionRightToRoot;
	}
	else if(translation < 0.0f)
	{
		if(currentFocalPanel == JFSliderControllerPanelRoot)
			transition = JFSliderControllerTransitionRootToRight;
		else if(currentFocalPanel == JFSliderControllerPanelLeft)
			transition = JFSliderControllerTransitionLeftToRoot;
	}
	
	return [self prepareSlideWithTransition:transition animated:animated];
}

- (BOOL)shouldPrepareSlideWithTransition:(JFSliderControllerTransition)transition
{
	if(!self.delegate)
		return YES;
	
	BOOL retVal = YES;
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		case JFSliderControllerTransitionRightToRoot:
		{
			if([self.delegate respondsToSelector:@selector(sliderController:shouldShowPanel:)])
				retVal = [self.delegate sliderController:self shouldShowPanel:JFSliderControllerPanelRoot];
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			if([self.delegate respondsToSelector:@selector(sliderController:shouldShowPanel:)])
				retVal = [self.delegate sliderController:self shouldShowPanel:JFSliderControllerPanelLeft];
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			if([self.delegate respondsToSelector:@selector(sliderController:shouldShowPanel:)])
				retVal = [self.delegate sliderController:self shouldShowPanel:JFSliderControllerPanelRight];
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
	
	switch(self.currentTransition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		case JFSliderControllerTransitionRootToRight:
		{
			destination = MIN(destination, self.currentSlideOrigin);
			destination = MAX(destination, self.currentSlideDestination);
			break;
		}
		case JFSliderControllerTransitionRightToRoot:
		case JFSliderControllerTransitionRootToLeft:
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

- (void)updateCurrentSlideDistancesForTransition:(JFSliderControllerTransition)transition
{
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		{
			self.currentSlideOrigin = CGRectGetMaxX(self.leftPanelContainer.frame);
			self.currentSlideDestination = 0.0f;
			self.currentSlideDuration = self.slideOutDuration;
			break;
		}
		case JFSliderControllerTransitionRightToRoot:
		{
			self.currentSlideOrigin = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(self.rootPanelContainer.frame);
			self.currentSlideDestination = 0.0f;
			self.currentSlideDuration = self.slideOutDuration;
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			self.currentSlideOrigin = 0.0f;
			self.currentSlideDestination = CGRectGetMaxX(self.leftPanelContainer.frame);
			self.currentSlideDuration = self.slideInDuration;
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			self.currentSlideOrigin = 0.0f;
			self.currentSlideDestination = CGRectGetMinX(self.rightPanelContainer.frame) - CGRectGetWidth(self.rootPanelContainer.frame);
			self.currentSlideDuration = self.slideInDuration;
			break;
		}
		case JFSliderControllerTransitionNone:
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


#pragma mark - Gesture recognizers management (Actions)

- (void)panGestureRecognized:(UIPanGestureRecognizer*)recognizer
{
	CGPoint translation = [recognizer translationInView:self.view];
	switch(recognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			if(self.animating)
				[self slideWithTranslation:translation.x animated:NO completion:nil];
			else
				[self prepareSlideWithTranslation:translation.x animated:YES];
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			CGPoint velocity = [recognizer velocityInView:self.view];
			[self completeSlideWithTranslation:translation.x velocity:velocity.x];
			break;
		}
		case UIGestureRecognizerStateCancelled:
		{
			[self completeSlideWithTranslation:0.0f velocity:0.0f];
			break;
		}
		case UIGestureRecognizerStateFailed:
		{
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

+ (NSString*)convertPanelToString:(JFSliderControllerPanel)panel
{
	NSString* retVal;
	switch(panel)
	{
		case JFSliderControllerPanelLeft:	retVal = @"Left Panel";		break;
		case JFSliderControllerPanelRight:	retVal = @"Right Panel";	break;
		case JFSliderControllerPanelRoot:	retVal = @"Root Panel";		break;
		default:							retVal = @"Unknown";		break;
	}
	return retVal;
}

+ (NSString*)convertTransitionToString:(JFSliderControllerTransition)transition
{
	NSString* retVal;
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:	retVal = @"Left => Root";	break;
		case JFSliderControllerTransitionRightToRoot:	retVal = @"Right => Root";	break;
		case JFSliderControllerTransitionRootToLeft:	retVal = @"Root => Left";	break;
		case JFSliderControllerTransitionRootToRight:	retVal = @"Root => Right";	break;
		case JFSliderControllerTransitionNone:			retVal = @"None";			break;
		default:										retVal = @"Unknown";		break;
	}
	return retVal;
}

- (NSString*)convertPanelToString:(JFSliderControllerPanel)panel
{
	return [[self class] convertPanelToString:panel];
}

- (NSString*)convertTransitionToString:(JFSliderControllerTransition)transition
{
	return [[self class] convertTransitionToString:transition];
}

@end

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



@interface JFSliderController () <UIGestureRecognizerDelegate>

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	CGFloat			currentSlideDestination;
@property (assign, nonatomic)	NSTimeInterval	currentSlideDuration;
@property (assign, nonatomic)	CGFloat			currentSlideLength;	// The sign reveals the sliding direction ('-' => left; '+' => right).
@property (assign, nonatomic)	CGFloat			currentSlideOrigin;

// Flags
@property (assign, nonatomic, getter = isAnimating)	BOOL							animating;
@property (assign, nonatomic, readwrite)			JFSliderControllerPanel			currentActivePanel;
@property (assign, nonatomic, readwrite)			JFSliderControllerTransition	currentTransition;
@property (assign, nonatomic)						BOOL							shouldCancelCurrentTransition;

// Gestures
@property (strong, nonatomic, readonly)	UIPanGestureRecognizer*	panGestureRecognizer;

// User interface
@property (strong, nonatomic, readonly)	UIButton*	activateRootPanelButton;
@property (strong, nonatomic, readonly)	UIView*		leftPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rightPanelContainer;
@property (strong, nonatomic, readonly)	UIView*		rootPanelContainer;


#pragma mark Methods

// Notifications management
- (void)	notifyDidActivatePanel:(JFSliderControllerPanel)panel;
- (void)	notifyDidCancelActivatePanel:(JFSliderControllerPanel)panel;
- (void)	notifyDidCancelDeactivatePanel:(JFSliderControllerPanel)panel;
- (void)	notifyDidDeactivatePanel:(JFSliderControllerPanel)panel;
- (void)	notifyWillActivatePanel:(JFSliderControllerPanel)panel;
- (void)	notifyWillDeactivatePanel:(JFSliderControllerPanel)panel;

// User interface management
- (void)	installActivateRootPanelButton;
- (void)	uninstallActivateRootPanelButton;
- (void)	updatePanelContainersFrames;

// User interface management (Actions)
- (void)	panGestureRecognized:(UIPanGestureRecognizer*)recognizer;
- (void)	activateRootPanelButtonTapped:(UIButton*)sender;

// User interface management (Sliding)
- (void)	cleanUp:(BOOL)finished animated:(BOOL)animated;
- (void)	completeSlideWithTranslation:(CGFloat)translation velocity:(CGFloat)velocity;
- (BOOL)	prepareSlideWithTransition:(JFSliderControllerTransition)transition animated:(BOOL)animated;
- (BOOL)	prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated;
- (BOOL)	shouldPrepareSlideWithTransition:(JFSliderControllerTransition)transition;
- (void)	slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(JFBlockWithBOOL)completion;
- (void)	updateCurrentSlideDistancesForTransition:(JFSliderControllerTransition)transition;

@end



#pragma mark



@implementation JFSliderController

#pragma mark Properties

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
@synthesize	currentActivePanel				= _currentActivePanel;
@synthesize currentTransition				= _currentTransition;
@synthesize shouldCancelCurrentTransition	= _shouldCancelCurrentTransition;

// Gestures
@synthesize panGestureRecognizer	= _panGestureRecognizer;

// Relationships
@synthesize	delegate	= _delegate;

// User interface
@synthesize activateRootPanelButton	= _activateRootPanelButton;
@synthesize	leftPanelContainer		= _leftPanelContainer;
@synthesize	leftViewController		= _leftViewController;
@synthesize	rightPanelContainer		= _rightPanelContainer;
@synthesize	rightViewController		= _rightViewController;
@synthesize	rootPanelContainer		= _rootPanelContainer;
@synthesize	rootViewController		= _rootViewController;


#pragma mark Properties accessors (Attributes)

- (void)setSlideInsets:(UIEdgeInsets)slideInsets
{
	if(UIEdgeInsetsEqualToEdgeInsets(_slideInsets, slideInsets))
		return;
	
	_slideInsets = slideInsets;
	
	if([self isViewLoaded])
		[self updatePanelContainersFrames];
}


#pragma mark Properties accessors (Flags)

- (void)setCurrentTransition:(JFSliderControllerTransition)currentTransition
{
	if(_currentTransition == currentTransition)
		return;
	
	_currentTransition = currentTransition;
	
	if([self isViewLoaded])
		[self updateCurrentSlideDistancesForTransition:_currentTransition];
}


#pragma mark Properties accessors (User interface)

- (UIViewController*)activeViewController
{
	return [self viewControllerForPanel:self.currentActivePanel];
}

- (void)setLeftViewController:(UIViewController*)leftViewController
{
	if(_leftViewController == leftViewController)
		return;
	
	BOOL isVisible = ![self.leftPanelContainer isHidden];
	
	if(_leftViewController && [self isViewLoaded])
	{
		[_leftViewController willMoveToParentViewController:nil];
		
		if(isVisible)
			[_leftViewController beginAppearanceTransition:NO animated:NO];
		
		[_leftViewController.view removeFromSuperview];
		
		if(isVisible)
			[_leftViewController endAppearanceTransition];
		
		[_leftViewController removeFromParentViewController];
	}
	
	_leftViewController = leftViewController;
	
	if(_leftViewController && [self isViewLoaded])
	{
		[self addChildViewController:_leftViewController];
		
		_leftViewController.view.frame = self.leftPanelContainer.bounds;
		
		if(isVisible)
			[_leftViewController beginAppearanceTransition:YES animated:NO];
		
		[self.leftPanelContainer addSubview:_leftViewController.view];
		[self.leftPanelContainer sendSubviewToBack:_leftViewController.view];
		
		if(isVisible)
			[_leftViewController endAppearanceTransition];
		
		[_leftViewController didMoveToParentViewController:self];
	}
}

- (void)setRightViewController:(UIViewController*)rightViewController
{
	if(_rightViewController == rightViewController)
		return;
	
	BOOL isVisible = ![self.rightPanelContainer isHidden];
	
	if(_rightViewController && [self isViewLoaded])
	{
		[_rightViewController willMoveToParentViewController:nil];
		
		if(isVisible)
			[_rightViewController beginAppearanceTransition:NO animated:NO];
		
		[_rightViewController.view removeFromSuperview];
		
		if(isVisible)
			[_rightViewController endAppearanceTransition];
		
		[_rightViewController removeFromParentViewController];
	};
	
	_rightViewController = rightViewController;
	
	if(_rightViewController && [self isViewLoaded])
	{
		[self addChildViewController:_rightViewController];
		
		_rightViewController.view.frame = self.rightPanelContainer.bounds;
		
		if(isVisible)
			[_rightViewController beginAppearanceTransition:YES animated:NO];
		
		[self.rightPanelContainer addSubview:_rightViewController.view];
		[self.rightPanelContainer sendSubviewToBack:_rightViewController.view];
		
		if(isVisible)
			[_rightViewController endAppearanceTransition];
		
		[_rightViewController didMoveToParentViewController:self];
	}
}

- (void)setRootViewController:(UIViewController*)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	if(_rootViewController && [self isViewLoaded])
	{
		[_rootViewController willMoveToParentViewController:nil];
		[_rootViewController beginAppearanceTransition:NO animated:NO];
		[_rootViewController.view removeFromSuperview];
		[_rootViewController endAppearanceTransition];
		[_rootViewController removeFromParentViewController];
	}
	
	_rootViewController = rootViewController;
	
	if(_rootViewController && [self isViewLoaded])
	{
		[self addChildViewController:_rootViewController];
		
		_rootViewController.view.frame = self.rootPanelContainer.bounds;
		
		[_rootViewController beginAppearanceTransition:YES animated:NO];
		
		[self.rootPanelContainer addSubview:_rootViewController.view];
		[self.rootPanelContainer sendSubviewToBack:_rootViewController.view];
		
		[_rootViewController endAppearanceTransition];
		
		[_rootViewController didMoveToParentViewController:self];
	}
}


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_currentSlideDestination = 0.0f;
		_currentSlideDuration = 0.0f;
		_currentSlideLength = 0.0f;
		_currentSlideOrigin = 0.0f;
		_slideInDuration = JFAnimationDuration;
		_slideInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
		_slideOutDuration = JFAnimationDuration;
		
		// Flags
		_animating = NO;
		_shouldCancelCurrentTransition = NO;
		_currentTransition = JFSliderControllerTransitionNone;
		_currentActivePanel = JFSliderControllerPanelRoot;
	}
	return self;
}


#pragma mark Notifications management

- (void)notifyDidActivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:didActivatePanel:)])
		[delegate sliderController:self didActivatePanel:panel];
}

- (void)notifyDidCancelActivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:didCancelActivatePanel:)])
		[delegate sliderController:self didCancelActivatePanel:panel];
}

- (void)notifyDidCancelDeactivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:didCancelDeactivatePanel:)])
		[delegate sliderController:self didCancelDeactivatePanel:panel];
}

- (void)notifyDidDeactivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:didDeactivatePanel:)])
		[delegate sliderController:self didDeactivatePanel:panel];
}

- (void)notifyWillActivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:willActivatePanel:)])
		[delegate sliderController:self willActivatePanel:panel];
}

- (void)notifyWillDeactivatePanel:(JFSliderControllerPanel)panel
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(sliderController:willDeactivatePanel:)])
		[delegate sliderController:self willDeactivatePanel:panel];
}


#pragma mark User interface management

- (BOOL)activatePanel:(JFSliderControllerPanel)panel
{
	return [self activatePanel:panel animated:YES completion:nil];
}

- (BOOL)activatePanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(JFBlockWithBOOL)completion
{
	if([self isAnimating])
		return NO;
	
	if((self.currentActivePanel != JFSliderControllerPanelRoot) && (panel != JFSliderControllerPanelRoot))
		return NO;
	
	JFSliderControllerTransition transition;
	switch(self.currentActivePanel)
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
	
	JFBlockWithBOOL internalCompletion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:animated];
		if(completion)
			completion(finished);
	};
	
	[self slideWithTranslation:self.currentSlideLength animated:animated completion:internalCompletion];
	
	return YES;
}

- (void)installActivateRootPanelButton
{
	UIButton* button = self.activateRootPanelButton;
	button.frame = self.rootPanelContainer.bounds;
	[self.rootPanelContainer addSubview:button];
}

- (void)uninstallActivateRootPanelButton
{
	[self.activateRootPanelButton removeFromSuperview];
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
	switch(self.currentActivePanel)
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

- (UIViewController*)viewControllerForPanel:(JFSliderControllerPanel)panel
{
	UIViewController* retObj = nil;
	switch(panel)
	{
		case JFSliderControllerPanelLeft:	retObj = self.leftViewController;	break;
		case JFSliderControllerPanelRight:	retObj = self.rightViewController;	break;
		case JFSliderControllerPanelRoot:	retObj = self.rootViewController;	break;
			
		default:
			break;
	}
	return retObj;
}


#pragma mark User interface management (Actions)

- (void)activateRootPanelButtonTapped:(UIButton*)sender
{
	[self activatePanel:JFSliderControllerPanelRoot];
}

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
			if([self isAnimating])
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


#pragma mark User interface management (Sliding)

- (void)cleanUp:(BOOL)finished animated:(BOOL)animated
{
	BOOL shouldCancel = self.shouldCancelCurrentTransition;
	
	BOOL didActivateSidePanel = NO;
	BOOL didDeactivateSidePanel = NO;
	BOOL shouldUninstallActivateRootPanelButton = NO;
	
	JFSliderControllerPanel currentActivePanel = self.currentActivePanel;
	
	JFSliderControllerPanel panel = currentActivePanel;
	UIView* panelContainer = nil;
	UIViewController* panelController = nil;
	switch(self.currentTransition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		{
			didDeactivateSidePanel = YES;
			panel = JFSliderControllerPanelRoot;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftViewController;
			shouldUninstallActivateRootPanelButton = !shouldCancel;
			break;
		}
		case JFSliderControllerTransitionRightToRoot:
		{
			didDeactivateSidePanel = YES;
			panel = JFSliderControllerPanelRoot;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightViewController;
			shouldUninstallActivateRootPanelButton = !shouldCancel;
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			didActivateSidePanel = YES;
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftViewController;
			shouldUninstallActivateRootPanelButton = shouldCancel;
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			didActivateSidePanel = YES;
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightViewController;
			shouldUninstallActivateRootPanelButton = shouldCancel;
			break;
		}
		default:
			break;
	}
	
	if(shouldUninstallActivateRootPanelButton)
		[self uninstallActivateRootPanelButton];
	
	self.animating = NO;
	self.shouldCancelCurrentTransition = NO;
	self.currentTransition = JFSliderControllerTransitionNone;
	
	panelContainer.userInteractionEnabled = YES;
	
	if(shouldCancel)
	{
		if(didActivateSidePanel)
		{
			[panelController beginAppearanceTransition:NO animated:animated];
			panelContainer.hidden = YES;
			[panelController endAppearanceTransition];
		}
		
		[self notifyDidCancelDeactivatePanel:currentActivePanel];
		[self notifyDidCancelActivatePanel:panel];
	}
	else
	{
		self.currentActivePanel = panel;
		
		if(didDeactivateSidePanel)
		{
			[panelController beginAppearanceTransition:NO animated:animated];
			panelContainer.hidden = YES;
			[panelController endAppearanceTransition];
		}
		
		[self notifyDidDeactivatePanel:currentActivePanel];
		[self notifyDidActivatePanel:panel];
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
		translation = ((fabs(translation) >= fabs(self.currentSlideLength / 2.0f)) ? self.currentSlideLength : 0.0f);
	
	self.shouldCancelCurrentTransition = (translation == 0.0f);
	
	JFBlockWithBOOL completion = ^(BOOL finished)
	{
		[self cleanUp:finished animated:YES];
	};
	
	[self slideWithTranslation:translation animated:YES completion:completion];
}

- (BOOL)prepareSlideWithTransition:(JFSliderControllerTransition)transition animated:(BOOL)animated
{
	if([self isAnimating])
		return NO;
	
	if(![self shouldPrepareSlideWithTransition:transition])
		return NO;
	
	[self updateCurrentSlideDistancesForTransition:transition];
	
	BOOL shouldInstallActivateRootPanelButton = NO;
	BOOL willActivateSidePanel = NO;
	BOOL willDeactivateSidePanel = NO;
	
	JFSliderControllerPanel panel;
	UIView* panelContainer = nil;
	UIViewController* panelController = nil;
	
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		{
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftViewController;
			willDeactivateSidePanel = YES;
			break;
		}
		case JFSliderControllerTransitionRightToRoot:
		{
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightViewController;
			willDeactivateSidePanel = YES;
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			panel = JFSliderControllerPanelLeft;
			panelContainer = self.leftPanelContainer;
			panelController = self.leftViewController;
			shouldInstallActivateRootPanelButton = YES;
			willActivateSidePanel = YES;
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			panel = JFSliderControllerPanelRight;
			panelContainer = self.rightPanelContainer;
			panelController = self.rightViewController;
			shouldInstallActivateRootPanelButton = YES;
			willActivateSidePanel = YES;
			break;
		}
		default:
			return NO;
	}
	
	panelContainer.userInteractionEnabled = NO;
	
	if(willDeactivateSidePanel)
	{
		[self notifyWillDeactivatePanel:panel];
		[self notifyWillActivatePanel:JFSliderControllerPanelRoot];
	}
	
	if(willActivateSidePanel)
	{
		[self notifyWillDeactivatePanel:JFSliderControllerPanelRoot];
		[self notifyWillActivatePanel:panel];
		
		[panelController beginAppearanceTransition:YES animated:animated];
		panelContainer.hidden = NO;
		[panelController endAppearanceTransition];
	}
	
	if(shouldInstallActivateRootPanelButton)
		[self installActivateRootPanelButton];
	
	self.animating = YES;
	self.currentTransition = transition;
	
	return YES;
}

- (BOOL)prepareSlideWithTranslation:(CGFloat)translation animated:(BOOL)animated
{
	JFSliderControllerTransition transition = JFSliderControllerTransitionNone;
	JFSliderControllerPanel currentActivePanel = self.currentActivePanel;
	
	if(translation > 0.0f)
	{
		if(currentActivePanel == JFSliderControllerPanelRoot)
			transition = JFSliderControllerTransitionRootToLeft;
		else if(currentActivePanel == JFSliderControllerPanelRight)
			transition = JFSliderControllerTransitionRightToRoot;
	}
	else if(translation < 0.0f)
	{
		if(currentActivePanel == JFSliderControllerPanelRoot)
			transition = JFSliderControllerTransitionRootToRight;
		else if(currentActivePanel == JFSliderControllerPanelLeft)
			transition = JFSliderControllerTransitionLeftToRoot;
	}
	
	return [self prepareSlideWithTransition:transition animated:animated];
}

- (BOOL)shouldPrepareSlideWithTransition:(JFSliderControllerTransition)transition
{
	id<JFSliderControllerDelegate> delegate = self.delegate;
	
	BOOL retVal = YES;
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:
		case JFSliderControllerTransitionRightToRoot:
		{
			if(delegate && [delegate respondsToSelector:@selector(sliderController:shouldActivatePanel:)])
				retVal = [delegate sliderController:self shouldActivatePanel:JFSliderControllerPanelRoot];
			break;
		}
		case JFSliderControllerTransitionRootToLeft:
		{
			if(delegate && [delegate respondsToSelector:@selector(sliderController:shouldActivatePanel:)])
				retVal = [delegate sliderController:self shouldActivatePanel:JFSliderControllerPanelLeft];
			break;
		}
		case JFSliderControllerTransitionRootToRight:
		{
			if(delegate && [delegate respondsToSelector:@selector(sliderController:shouldActivatePanel:)])
				retVal = [delegate sliderController:self shouldActivatePanel:JFSliderControllerPanelRight];
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

- (void)slideWithTranslation:(CGFloat)translation animated:(BOOL)animated completion:(JFBlockWithBOOL)completion
{
	if(![self isAnimating])
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
	
	JFBlock animations = ^(void)
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


#pragma mark User interface management (View lifecycle)

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
	return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.rootViewController endAppearanceTransition];
	
	if(![self.leftPanelContainer isHidden])
		[self.leftViewController endAppearanceTransition];
	
	if(![self.rightPanelContainer isHidden])
		[self.rightViewController endAppearanceTransition];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self.rootViewController endAppearanceTransition];
	
	if(![self.leftPanelContainer isHidden])
		[self.leftViewController endAppearanceTransition];
	
	if(![self.rightPanelContainer isHidden])
		[self.rightViewController endAppearanceTransition];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// User interface
	_leftPanelContainer = [[UIView alloc] init];
	_rightPanelContainer = [[UIView alloc] init];
	_rootPanelContainer = [[UIView alloc] init];
	_activateRootPanelButton = [[UIButton alloc] init];
	
	// Gestures
	_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
	
	self.rootPanelContainer.clipsToBounds = YES;
	
	self.leftPanelContainer.backgroundColor = [UIColor lightGrayColor];
	self.rightPanelContainer.backgroundColor = [UIColor darkGrayColor];
	self.rootPanelContainer.backgroundColor = [UIColor blackColor];
	
	self.leftPanelContainer.hidden = YES;
	self.rightPanelContainer.hidden = YES;
	
	if(self.leftViewController)
	{
		[self addChildViewController:self.leftViewController];
		self.leftViewController.view.frame = self.leftPanelContainer.bounds;
		[self.leftPanelContainer addSubview:self.leftViewController.view];
		[self.leftViewController didMoveToParentViewController:self];
	}
	
	if(self.rightViewController)
	{
		[self addChildViewController:self.rightViewController];
		self.rightViewController.view.frame = self.rightPanelContainer.bounds;
		[self.rightPanelContainer addSubview:self.rightViewController.view];
		[self.rightViewController didMoveToParentViewController:self];
	}
	
	if(self.rootViewController)
	{
		[self addChildViewController:self.rootViewController];
		self.rootViewController.view.frame = self.rootPanelContainer.bounds;
		[self.rootPanelContainer addSubview:self.rootViewController.view];
		[self.rootViewController didMoveToParentViewController:self];
	}
	
	[self.view addSubview:self.leftPanelContainer];
	[self.view addSubview:self.rightPanelContainer];
	[self.view addSubview:self.rootPanelContainer];
	
	UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	self.leftPanelContainer.autoresizingMask = autoresizingMask;
	self.rightPanelContainer.autoresizingMask = autoresizingMask;
	self.rootPanelContainer.autoresizingMask = autoresizingMask;
	
	UIButton* button = self.activateRootPanelButton;
	button.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[button addTarget:self action:@selector(activateRootPanelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	[self updatePanelContainersFrames];
	
	self.panGestureRecognizer.delegate = self;
	
	[self.rootPanelContainer addGestureRecognizer:self.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.rootViewController beginAppearanceTransition:YES animated:animated];
	
	if(![self.leftPanelContainer isHidden])
		[self.leftViewController beginAppearanceTransition:YES animated:animated];
	
	if(![self.rightPanelContainer isHidden])
		[self.rightViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.rootViewController beginAppearanceTransition:NO animated:animated];
	
	if(![self.leftPanelContainer isHidden])
		[self.leftViewController beginAppearanceTransition:NO animated:animated];
	
	if(![self.rightPanelContainer isHidden])
		[self.rightViewController beginAppearanceTransition:NO animated:animated];
}


#pragma mark Utilities management (Debug)

+ (NSString*)debugStringFromPanel:(JFSliderControllerPanel)panel
{
	NSString* retObj;
	switch(panel)
	{
		case JFSliderControllerPanelLeft:	retObj = @"Left Panel";		break;
		case JFSliderControllerPanelRight:	retObj = @"Right Panel";	break;
		case JFSliderControllerPanelRoot:	retObj = @"Root Panel";		break;
		default:							retObj = @"Unknown";		break;
	}
	return retObj;
}

+ (NSString*)debugStringFromTransition:(JFSliderControllerTransition)transition
{
	NSString* retObj;
	switch(transition)
	{
		case JFSliderControllerTransitionLeftToRoot:	retObj = @"Left => Root";	break;
		case JFSliderControllerTransitionRightToRoot:	retObj = @"Right => Root";	break;
		case JFSliderControllerTransitionRootToLeft:	retObj = @"Root => Left";	break;
		case JFSliderControllerTransitionRootToRight:	retObj = @"Root => Right";	break;
		case JFSliderControllerTransitionNone:			retObj = @"None";			break;
		default:										retObj = @"Unknown";		break;
	}
	return retObj;
}

- (NSString*)debugStringFromPanel:(JFSliderControllerPanel)panel
{
	return [[self class] debugStringFromPanel:panel];
}

- (NSString*)debugStringFromTransition:(JFSliderControllerTransition)transition
{
	return [[self class] debugStringFromTransition:transition];
}


#pragma mark Protocol implementation (UIGestureRecognizerDelegate)

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

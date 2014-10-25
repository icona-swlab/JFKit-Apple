//
//  JFSlideViewController.m
//
//  Created by Jacopo Filié on 05/10/12.
//  Copyright (c) 2012 Icona s.r.l. All rights reserved.
//



#import "JFSlideViewController.h"

#import <QuartzCore/QuartzCore.h>



typedef enum {
	SlideStateRootViewVisible,
	SlideStateLeftViewVisible,
	SlideStateRightViewVisible
} SlideState;



@interface JFSlideViewController ()

// Attributes
@property (assign, nonatomic)	SlideState	slideState;

// Layout
@property (retain, nonatomic, readonly)	UIView*	leftViewContainer;
@property (retain, nonatomic, readonly)	UIView*	rightViewContainer;
@property (retain, nonatomic, readonly)	UIView*	rootViewContainer;

// View actions
- (void)	showRootViewButtonClicked:(UIButton*)sender;

// View management
- (void)	setupShowRootViewButton;

@end



@implementation JFSlideViewController

#pragma mark - Properties

// Attributes
@synthesize	fadeDuration		= _fadeDuration;
@synthesize	slideDuration		= _slideDuration;
@synthesize	slideState			= _slideState;
@synthesize	visibleSlideOffset	= _visibleSlideOffset;

// Layout
@synthesize	leftViewContainer	= _leftViewContainer;
@synthesize	leftViewController	= _leftViewController;
@synthesize	rightViewContainer	= _rightViewContainer;
@synthesize	rightViewController	= _rightViewController;
@synthesize	rootViewContainer	= _rootViewContainer;
@synthesize	rootViewController	= _rootViewController;

// Targets
@synthesize	delegate	= _delegate;


#pragma mark - Properties accessors

// Layout

- (void)setLeftViewController:(UIViewController*)leftViewController
{
	if(_leftViewController == leftViewController)
		return;
	
	if(_leftViewController && [self isViewLoaded])
		[_leftViewController.view removeFromSuperview];
	
	_leftViewController = leftViewController;
	
	if([self isViewLoaded])
	{
		_leftViewController.view.frame = self.leftViewContainer.bounds;
		[self.leftViewContainer addSubview:_leftViewController.view];
	}
}

- (void)setRightViewController:(UIViewController*)rightViewController
{
	if(_rightViewController == rightViewController)
		return;
	
	if(_rightViewController && [self isViewLoaded])
		[_rightViewController.view removeFromSuperview];
	
	_rightViewController = rightViewController;
	
	if([self isViewLoaded])
	{
		_rightViewController.view.frame = self.rightViewContainer.bounds;
		[self.rightViewContainer addSubview:_rightViewController.view];
	}
}

- (void)setRootViewController:(UIViewController*)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	if(_rootViewController && [self isViewLoaded])
		[_rootViewController.view removeFromSuperview];
	
	_rootViewController = rootViewController;
	
	if([self isViewLoaded])
	{
		_rootViewController.view.frame = self.rootViewContainer.bounds;
		[self.rootViewContainer addSubview:_rootViewController.view];
	}
}


#pragma mark - Memory management

- (id)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_fadeDuration = 0.25;
		_slideDuration = 0.25;
		_visibleSlideOffset = 40.0f;
		
		// Layout
		_leftViewContainer = [[UIView alloc] init];
		_rightViewContainer = [[UIView alloc] init];
		_rootViewContainer = [[UIView alloc] init];
		_rootViewContainer.backgroundColor = [UIColor blackColor];
	}
	return self;
}


#pragma mark - View delegate

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.leftViewContainer.frame = self.view.bounds;
	self.rightViewContainer.frame = self.view.bounds;
	self.rootViewContainer.frame = self.view.bounds;
	
	//self.rootViewContainer.layer.shadowOpacity = 0.5f;
	
	self.leftViewContainer.hidden = YES;
	self.rightViewContainer.hidden = YES;
	
	if(self.rootViewController)
	{
		self.rootViewController.view.frame = self.rootViewContainer.bounds;
		[self.rootViewContainer addSubview:self.rootViewController.view];
	}
	
	[self.view addSubview:self.leftViewContainer];
	[self.view addSubview:self.rightViewContainer];
	[self.view addSubview:self.rootViewContainer];
}


#pragma mark - View actions

- (void)showRootViewButtonClicked:(UIButton*)sender
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:shouldShowRootViewController:)])
		if(![self.delegate slideViewController:self shouldShowRootViewController:self.rootViewController])
			return;
	
	UIView* view = nil;
	UIViewController* viewController = nil;
	if(self.slideState == SlideStateLeftViewVisible)
	{
		view = self.leftViewContainer;
		viewController = self.leftViewController;
	}
	else if(self.slideState == SlideStateRightViewVisible)
	{
		view = self.rightViewContainer;
		viewController = self.rightViewController;
	}
	
	[viewController viewWillDisappear:YES];
	if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:willHideViewController:)])
		[self.delegate slideViewController:self willHideViewController:viewController];
	
	view.userInteractionEnabled = NO;
	
	if(sender)
		[sender removeFromSuperview];
	
	Block animations = ^(void)
	{
		self.rootViewContainer.frame = self.view.bounds;
	};
	
	BlockWithBool completion = ^(BOOL finished)
	{
		self.rootViewContainer.layer.shadowOffset = CGSizeZero;
		view.hidden = YES;
		view.userInteractionEnabled = YES;
		[viewController viewDidDisappear:YES];
		if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:didHideViewController:)])
			[self.delegate slideViewController:self didHideViewController:viewController];
		self.slideState = SlideStateRootViewVisible;
	};
	
	[UIView animateWithDuration:self.slideDuration animations:animations completion:completion];
}


#pragma mark - View management

- (void)setupShowRootViewButton
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = self.rootViewContainer.bounds;
	[button addTarget:self action:@selector(showRootViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.rootViewContainer addSubview:button];
}

- (void)showLeftView
{
	[self.leftViewController viewWillAppear:YES];
	if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:willShowViewController:)])
		[self.delegate slideViewController:self willShowViewController:self.leftViewController];
	
	self.rootViewContainer.layer.shadowOffset = CGSizeMake(-1.0f, 0.0f);
	self.leftViewContainer.hidden = NO;
	
	CGRect frame = self.leftViewContainer.frame;
	frame.size.width = self.view.bounds.size.width - self.visibleSlideOffset;
	self.leftViewContainer.frame = frame;
	
	frame = self.rootViewContainer.frame;
	frame.origin.x = self.view.bounds.size.width - self.visibleSlideOffset;
	
	Block animations = ^(void)
	{
		self.rootViewContainer.frame = frame;
	};
	
	BlockWithBool completion = ^(BOOL finished)
	{
		[self setupShowRootViewButton];
		[self.leftViewController viewDidAppear:YES];
		if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:didShowViewController:)])
			[self.delegate slideViewController:self didShowViewController:self.leftViewController];
		self.slideState = SlideStateLeftViewVisible;
	};
	
	[UIView animateWithDuration:self.slideDuration animations:animations completion:completion];
}

- (void)showRightView
{
	[self.rightViewController viewWillAppear:YES];
	if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:willShowViewController:)])
		[self.delegate slideViewController:self willShowViewController:self.rightViewController];
	
	self.rootViewContainer.layer.shadowOffset = CGSizeMake(1.0f, 0.0f);
	self.rightViewContainer.hidden = NO;
	
	CGRect frame = self.rightViewContainer.frame;
	frame.origin.x = self.visibleSlideOffset;
	frame.size.width = self.view.bounds.size.width - self.visibleSlideOffset;
	self.rightViewContainer.frame = frame;
	
	frame = self.rootViewContainer.frame;
	frame.origin.x = self.visibleSlideOffset - self.view.bounds.size.width;
	
	Block animations = ^(void)
	{
		self.rootViewContainer.frame = frame;
	};
	
	BlockWithBool completion = ^(BOOL finished)
	{
		[self setupShowRootViewButton];
		[self.rightViewController viewDidAppear:YES];
		if(self.delegate && [self.delegate respondsToSelector:@selector(slideViewController:didShowViewController:)])
			[self.delegate slideViewController:self didShowViewController:self.rightViewController];
		self.slideState = SlideStateRightViewVisible;
	};
	
	[UIView animateWithDuration:self.slideDuration animations:animations completion:completion];
}

- (void)showRootView
{
	[self showRootViewButtonClicked:nil];
}

@end

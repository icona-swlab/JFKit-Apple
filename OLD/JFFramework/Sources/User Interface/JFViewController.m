//
//  JFViewController.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFViewController.h"

#import "JFLogger.h"
#import "JFUtilities.h"



#pragma mark Notifications

// Navigation (Keys)
NSString* const	JFViewControllerIsAnimatedKey	= @"JFViewControllerIsAnimatedKey";
NSString* const	JFViewControllerParentKey		= @"JFViewControllerParentKey";

// Navigation (Names)
NSString* const	JFViewControllerDidMoveToParentNotification		= @"JFViewControllerDidMoveToParentNotification";
NSString* const	JFViewControllerHasBeenDismissedNotification	= @"JFViewControllerHasBeenDismissedNotification";
NSString* const	JFViewControllerHasBeenPoppedNotification		= @"JFViewControllerHasBeenPoppedNotification";
NSString* const	JFViewControllerHasBeenPresentedNotification	= @"JFViewControllerHasBeenPresentedNotification";
NSString* const	JFViewControllerHasBeenPushedNotification		= @"JFViewControllerHasBeenPushedNotification";
NSString* const	JFViewControllerWillBeDismissedNotification		= @"JFViewControllerWillBeDismissedNotification";
NSString* const	JFViewControllerWillBePoppedNotification		= @"JFViewControllerWillBePoppedNotification";
NSString* const	JFViewControllerWillBePresentedNotification		= @"JFViewControllerWillBePresentedNotification";
NSString* const	JFViewControllerWillBePushedNotification		= @"JFViewControllerWillBePushedNotification";
NSString* const	JFViewControllerWillMoveToParentNotification	= @"JFViewControllerWillMoveToParentNotification";



#pragma mark



@interface JFViewController ()

#pragma mark Methods

// Notifications management (Navigation)
- (void)	notifyDidMoveToParent:(UIViewController*)parent;
- (void)	notifyHasBeenDismissed:(BOOL)animated;
- (void)	notifyHasBeenPopped:(BOOL)animated;
- (void)	notifyHasBeenPresented:(BOOL)animated;
- (void)	notifyHasBeenPushed:(BOOL)animated;
- (void)	notifyWillBeDismissed:(BOOL)animated;
- (void)	notifyWillBePopped:(BOOL)animated;
- (void)	notifyWillBePresented:(BOOL)animated;
- (void)	notifyWillBePushed:(BOOL)animated;
- (void)	notifyWillMoveToParent:(UIViewController*)parent;

// Notifications management (Visibility)
- (void)	notifyViewDidAppear:(BOOL)animated;
- (void)	notifyViewDidDisappear:(BOOL)animated;
- (void)	notifyViewWillAppear:(BOOL)animated;
- (void)	notifyViewWillDisappear:(BOOL)animated;

@end



#pragma mark



@implementation JFViewController

#pragma mark Properties

// Relationships
@synthesize navigationDelegate	= _navigationDelegate;
@synthesize rotationDelegate	= _rotationDelegate;
@synthesize visibilityDelegate	= _visibilityDelegate;


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithNibName:StandardXIBName bundle:nil];
}


#pragma mark User interface management (Navigation)

- (void)hasBeenDismissed:(BOOL)animated
{}

- (void)hasBeenPopped:(BOOL)animated
{}

- (void)hasBeenPresented:(BOOL)animated
{}

- (void)hasBeenPushed:(BOOL)animated
{}

- (void)willBeDismissed:(BOOL)animated
{}

- (void)willBePopped:(BOOL)animated
{}

- (void)willBePresented:(BOOL)animated
{}

- (void)willBePushed:(BOOL)animated
{}


#pragma mark User interface management (Rotation)

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:didRotateFromInterfaceOrientation:)])
		[delegate viewController:self didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewControllerPreferredInterfaceOrientationForPresentation:)])
		return [delegate viewControllerPreferredInterfaceOrientationForPresentation:self];
	
	return [super preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewControllerShouldAutorotate:)])
		return [delegate viewControllerShouldAutorotate:self];
	
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewControllerSupportedInterfaceOrientations:)])
		return [delegate viewControllerSupportedInterfaceOrientations:self];
	
	return [super supportedInterfaceOrientations];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:willAnimateRotationToInterfaceOrientation:duration:)])
		[delegate viewController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:willRotateToInterfaceOrientation:duration:)])
		[delegate viewController:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


#pragma mark User interface management (View lifecycle)

- (void)didMoveToParentViewController:(UIViewController*)parent
{
	[super didMoveToParentViewController:parent];
	[self notifyDidMoveToParent:parent];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([self isBeingPresented])
	{
		[self hasBeenPresented:animated];
		[self notifyHasBeenPresented:animated];
	}
	
	if([self isMovingToParentViewController])
	{
		[self hasBeenPushed:animated];
		[self notifyHasBeenPushed:animated];
	}
	
	[self notifyViewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if([self isBeingDismissed])
	{
		[self hasBeenDismissed:animated];
		[self notifyHasBeenDismissed:animated];
	}
	
	if([self isMovingFromParentViewController])
	{
		[self hasBeenPopped:animated];
		[self notifyHasBeenPopped:animated];
	}
	
	[self notifyViewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if([self isBeingPresented])
	{
		[self willBePresented:animated];
		[self notifyWillBePresented:animated];
	}
	
	if([self isMovingToParentViewController])
	{
		[self willBePushed:animated];
		[self notifyWillBePushed:animated];
	}
	
	[self notifyViewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if([self isBeingDismissed])
	{
		[self willBeDismissed:animated];
		[self notifyWillBeDismissed:animated];
	}
	
	if([self isMovingFromParentViewController])
	{
		[self willBePopped:animated];
		[self notifyWillBePopped:animated];
	}
	
	[self notifyViewWillDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController*)parent
{
	[super willMoveToParentViewController:parent];
	[self notifyWillMoveToParent:parent];
}


#pragma mark Notifications management (Navigation)

- (void)notifyDidMoveToParent:(UIViewController*)parent
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:didMoveToParent:)])
		[delegate viewController:self didMoveToParent:parent];
	
	NSDictionary* userInfo = (parent ? @{JFViewControllerParentKey : parent} : nil);
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerDidMoveToParentNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenDismissed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenDismissed:)])
		[delegate viewController:self hasBeenDismissed:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenDismissedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPopped:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPopped:)])
		[delegate viewController:self hasBeenPopped:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPoppedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPresented:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPresented:)])
		[delegate viewController:self hasBeenPresented:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPresentedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPushed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPushed:)])
		[delegate viewController:self hasBeenPushed:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPushedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBeDismissed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBeDismissed:)])
		[delegate viewController:self willBeDismissed:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBeDismissedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePopped:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePopped:)])
		[delegate viewController:self willBePopped:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePoppedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePresented:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePresented:)])
		[delegate viewController:self willBePresented:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePresentedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePushed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePushed:)])
		[delegate viewController:self willBePushed:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePushedNotification object:self userInfo:userInfo];
}

- (void)notifyWillMoveToParent:(UIViewController*)parent
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willMoveToParent:)])
		[delegate viewController:self willMoveToParent:parent];
	
	NSDictionary* userInfo = (parent ? @{JFViewControllerParentKey : parent} : nil);
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillMoveToParentNotification object:self userInfo:userInfo];
}


#pragma mark Notifications management (Visibility)

- (void)notifyViewDidAppear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewDidAppearAnimated:)])
		[delegate viewController:self viewDidAppearAnimated:animated];
}

- (void)notifyViewDidDisappear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewDidDisappearAnimated:)])
		[delegate viewController:self viewDidDisappearAnimated:animated];
}

- (void)notifyViewWillAppear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewWillAppearAnimated:)])
		[delegate viewController:self viewWillAppearAnimated:animated];
}

- (void)notifyViewWillDisappear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewWillDisappearAnimated:)])
		[delegate viewController:self viewWillDisappearAnimated:animated];
}

@end

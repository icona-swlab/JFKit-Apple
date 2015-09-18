//
//  UIViewController+JFFramework.m
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



#import "UIViewController+JFFramework.h"

#import <objc/runtime.h>

#import "JFString.h"
#import "JFUtilities.h"
#import "JFWeakHandle.h"
#import "JRSwizzle.h"



#pragma mark - Macros

#define JFViewControllerNotification(_name)	(JFReversedDomain @".viewController.notification." _name)
#define JFViewControllerUserInfo(_name)		(JFReversedDomain @".viewController.userInfo." _name)



#pragma mark - Constants

// Notifications (Navigation)
NSString* const	JFViewControllerDidMoveToParentNotification		= JFViewControllerNotification(@"didMoveToParent");
NSString* const	JFViewControllerHasBeenDismissedNotification	= JFViewControllerNotification(@"hasBeenDismissed");
NSString* const	JFViewControllerHasBeenPoppedNotification		= JFViewControllerNotification(@"hasBeenPopped");
NSString* const	JFViewControllerHasBeenPresentedNotification	= JFViewControllerNotification(@"hasBeenPresented");
NSString* const	JFViewControllerHasBeenPushedNotification		= JFViewControllerNotification(@"hasBeenPushed");
NSString* const	JFViewControllerWillBeDismissedNotification		= JFViewControllerNotification(@"willBeDismissed");
NSString* const	JFViewControllerWillBePoppedNotification		= JFViewControllerNotification(@"willBePopped");
NSString* const	JFViewControllerWillBePresentedNotification		= JFViewControllerNotification(@"willBePresented");
NSString* const	JFViewControllerWillBePushedNotification		= JFViewControllerNotification(@"willBePushed");
NSString* const	JFViewControllerWillMoveToParentNotification	= JFViewControllerNotification(@"willMoveToParent");

// Notifications (Rotation)
NSString* const	JFViewControllerDidRotateFromInterfaceOrientationNotification			= JFViewControllerNotification(@"didRotateFromInterfaceOrientation");
NSString* const	JFViewControllerWillAnimateRotationToInterfaceOrientationNotification	= JFViewControllerNotification(@"willAnimateRotationToInterfaceOrientation");
NSString* const	JFViewControllerWillRotateToInterfaceOrientationNotification			= JFViewControllerNotification(@"willRotateToInterfaceOrientation");

// Notifications (Visibility)
NSString* const	JFViewControllerViewDidAppearNotification		= JFViewControllerNotification(@"viewDidAppear");
NSString* const	JFViewControllerViewDidDisappearNotification	= JFViewControllerNotification(@"viewDidDisappear");
NSString* const	JFViewControllerViewWillAppearNotification		= JFViewControllerNotification(@"viewWillAppear");
NSString* const	JFViewControllerViewWillDisappearNotification	= JFViewControllerNotification(@"viewDidAppear");

// User info keys
NSString* const	JFViewControllerDurationUserInfoKey				= JFViewControllerUserInfo(@"duration");
NSString* const	JFViewControllerInterfaceOrientationUserInfoKey	= JFViewControllerUserInfo(@"interfaceOrientation");
NSString* const	JFViewControllerIsAnimatedUserInfoKey			= JFViewControllerUserInfo(@"isAnimated");
NSString* const	JFViewControllerParentViewControllerUserInfoKey	= JFViewControllerUserInfo(@"parentViewController");



#pragma mark



@interface UIViewController (JFFramework_Private)

#pragma mark Methods

// User interface management (Navigation)
- (void)	jf_swizzled_didMoveToParentViewController:(UIViewController*)parent;
- (void)	jf_swizzled_willMoveToParentViewController:(UIViewController*)parent;

// User interface management (Rotation)
- (void)						jf_swizzled_didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (UIInterfaceOrientation)		jf_swizzled_preferredInterfaceOrientationForPresentation;
- (BOOL)						jf_swizzled_shouldAutorotate;
- (UIInterfaceOrientationMask)	jf_swizzled_supportedInterfaceOrientations;
- (void)						jf_swizzled_willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)						jf_swizzled_willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

// User interface management (Visibility)
- (void)	jf_swizzled_viewDidAppear:(BOOL)animated;
- (void)	jf_swizzled_viewDidDisappear:(BOOL)animated;
- (void)	jf_swizzled_viewWillAppear:(BOOL)animated;
- (void)	jf_swizzled_viewWillDisappear:(BOOL)animated;

@end



#pragma mark



@interface UIViewController (JFFramework_Navigation_Private)

#pragma mark Methods

// Notifications management
- (void)	jf_notifyDidMoveToParent:(UIViewController*)parent;
- (void)	jf_notifyHasBeenDismissed:(BOOL)animated;
- (void)	jf_notifyHasBeenPopped:(BOOL)animated;
- (void)	jf_notifyHasBeenPresented:(BOOL)animated;
- (void)	jf_notifyHasBeenPushed:(BOOL)animated;
- (void)	jf_notifyWillBeDismissed:(BOOL)animated;
- (void)	jf_notifyWillBePopped:(BOOL)animated;
- (void)	jf_notifyWillBePresented:(BOOL)animated;
- (void)	jf_notifyWillBePushed:(BOOL)animated;
- (void)	jf_notifyWillMoveToParent:(UIViewController*)parent;

@end



#pragma mark



@interface UIViewController (JFFramework_Rotation_Private)

#pragma mark Methods

// Notifications management
- (void)						jf_notifyDidRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (UIInterfaceOrientation)		jf_notifyPreferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)proposedInterfaceOrientation;
- (BOOL)						jf_notifyShouldAutorotate:(BOOL)proposedAnswer;
- (UIInterfaceOrientationMask)	jf_notifySupportedInterfaceOrientations:(UIInterfaceOrientationMask)proposedInterfaceOrientations;
- (void)						jf_notifyWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)						jf_notifyWillRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end



#pragma mark



@interface UIViewController (JFFramework_Visibility_Private)

#pragma mark Methods

// Notifications management
- (void)	jf_notifyViewDidAppear:(BOOL)animated;
- (void)	jf_notifyViewDidDisappear:(BOOL)animated;
- (void)	jf_notifyViewWillAppear:(BOOL)animated;
- (void)	jf_notifyViewWillDisappear:(BOOL)animated;

@end



#pragma mark



@implementation UIViewController (JFFramework)

#pragma mark Memory management

+ (void)load
{
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		
		// Prepares the swizzling block.
		void (^swizzleMethod)(SEL, SEL) = ^(SEL original, SEL swizzled)
		{
			NSError* error;
			[[self class] jr_swizzleMethod:original withMethod:swizzled error:&error];
			NSAssert(!error, @"Failed to swizzle '%@' for error '%@'.", NSStringFromSelector(original), error);
		};
		
		// Swizzle the navigation methods.
		swizzleMethod(@selector(didMoveToParentViewController:), @selector(jf_swizzled_didMoveToParentViewController:));
		swizzleMethod(@selector(willMoveToParentViewController:), @selector(jf_swizzled_willMoveToParentViewController:));
		
		// Swizzle the rotation methods.
		swizzleMethod(@selector(didRotateFromInterfaceOrientation:), @selector(jf_swizzled_didRotateFromInterfaceOrientation:));
		swizzleMethod(@selector(preferredInterfaceOrientationForPresentation), @selector(jf_swizzled_preferredInterfaceOrientationForPresentation));
		swizzleMethod(@selector(shouldAutorotate), @selector(jf_swizzled_shouldAutorotate));
		swizzleMethod(@selector(supportedInterfaceOrientations), @selector(jf_swizzled_supportedInterfaceOrientations));
		swizzleMethod(@selector(willAnimateRotationToInterfaceOrientation:duration:), @selector(jf_swizzled_willAnimateRotationToInterfaceOrientation:duration:));
		swizzleMethod(@selector(willRotateToInterfaceOrientation:duration:), @selector(jf_swizzled_willRotateToInterfaceOrientation:duration:));
		
		// Swizzle the visibility methods.
		swizzleMethod(@selector(viewDidAppear:), @selector(jf_swizzled_viewDidAppear:));
		swizzleMethod(@selector(viewDidDisappear:), @selector(jf_swizzled_viewDidDisappear:));
		swizzleMethod(@selector(viewWillAppear:), @selector(jf_swizzled_viewWillAppear:));
		swizzleMethod(@selector(viewWillDisappear:), @selector(jf_swizzled_viewWillDisappear:));
	});
}


#pragma mark User interface management (Navigation)

- (void)jf_swizzled_didMoveToParentViewController:(UIViewController*)parent
{
	[self jf_swizzled_didMoveToParentViewController:parent];
	[self jf_notifyDidMoveToParent:parent];
}

- (void)jf_swizzled_willMoveToParentViewController:(UIViewController*)parent
{
	[self jf_swizzled_willMoveToParentViewController:parent];
	[self jf_notifyWillMoveToParent:parent];
}


#pragma mark User interface management (Rotation)

- (void)jf_swizzled_didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self jf_swizzled_didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self jf_notifyDidRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (UIInterfaceOrientation)jf_swizzled_preferredInterfaceOrientationForPresentation
{
	return [self jf_notifyPreferredInterfaceOrientationForPresentation:[self jf_swizzled_preferredInterfaceOrientationForPresentation]];
}

- (BOOL)jf_swizzled_shouldAutorotate
{
	return [self jf_notifyShouldAutorotate:[self jf_swizzled_shouldAutorotate]];
}

- (UIInterfaceOrientationMask)jf_swizzled_supportedInterfaceOrientations
{
	return [self jf_notifySupportedInterfaceOrientations:[self jf_swizzled_supportedInterfaceOrientations]];
}

- (void)jf_swizzled_willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self jf_swizzled_willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self jf_notifyWillAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)jf_swizzled_willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self jf_swizzled_willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self jf_notifyWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


#pragma mark User interface management (Visibility)

- (void)jf_swizzled_viewDidAppear:(BOOL)animated
{
	[self jf_swizzled_viewDidAppear:animated];
	
	if([self isBeingPresented])
		[self hasBeenPresented:animated];
	
	if([self isMovingToParentViewController])
		[self hasBeenPushed:animated];
	
	[self jf_notifyViewDidAppear:animated];
}

- (void)jf_swizzled_viewDidDisappear:(BOOL)animated
{
	[self jf_swizzled_viewDidDisappear:animated];
	
	if([self isBeingDismissed])
		[self hasBeenDismissed:animated];
	
	if([self isMovingFromParentViewController])
		[self hasBeenPopped:animated];
		
	[self jf_notifyViewDidDisappear:animated];
}

- (void)jf_swizzled_viewWillAppear:(BOOL)animated
{
	[self jf_swizzled_viewWillAppear:animated];
	
	if([self isBeingPresented])
		[self willBePresented:animated];
	
	if([self isMovingToParentViewController])
		[self willBePushed:animated];

	[self jf_notifyViewWillAppear:animated];
}

- (void)jf_swizzled_viewWillDisappear:(BOOL)animated
{
	[self jf_swizzled_viewWillDisappear:animated];
	
	if([self isBeingDismissed])
		[self willBeDismissed:animated];
	
	if([self isMovingFromParentViewController])
		[self willBePopped:animated];
	
	[self jf_notifyViewWillDisappear:animated];
}

@end



#pragma mark



@implementation UIViewController (JFFramework_Navigation)

#pragma mark Properties accessors (Relationships)

- (id<JFViewControllerNavigationDelegate>)navigationDelegate
{
	JFWeakHandle* handle = objc_getAssociatedObject(self, @selector(navigationDelegate));
	return handle.object;
}

- (void)setNavigationDelegate:(id<JFViewControllerNavigationDelegate>)navigationDelegate
{
	JFWeakHandle* handle = nil;
	if(navigationDelegate)
	{
		handle = [[JFWeakHandle alloc] init];
		handle.object = navigationDelegate;
	}
	objc_setAssociatedObject(self, @selector(navigationDelegate), handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark  Notifications management

- (void)jf_notifyDidMoveToParent:(UIViewController*)parent
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:didMoveToParent:)])
		[delegate viewController:self didMoveToParent:parent];
	
	NSDictionary* userInfo = (parent ? @{JFViewControllerParentViewControllerUserInfoKey : parent} : nil);
	[MainNotificationCenter postNotificationName:JFViewControllerDidMoveToParentNotification object:self userInfo:userInfo];
}

- (void)jf_notifyHasBeenDismissed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenDismissedAnimated:)])
		[delegate viewController:self hasBeenDismissedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerHasBeenDismissedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyHasBeenPopped:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPoppedAnimated:)])
		[delegate viewController:self hasBeenPoppedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerHasBeenPoppedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyHasBeenPresented:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPresentedAnimated:)])
		[delegate viewController:self hasBeenPresentedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerHasBeenPresentedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyHasBeenPushed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:hasBeenPushedAnimated:)])
		[delegate viewController:self hasBeenPushedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerHasBeenPushedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillBeDismissed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBeDismissedAnimated:)])
		[delegate viewController:self willBeDismissedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillBeDismissedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillBePopped:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePoppedAnimated:)])
		[delegate viewController:self willBePoppedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillBePoppedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillBePresented:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePresentedAnimated:)])
		[delegate viewController:self willBePresentedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillBePresentedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillBePushed:(BOOL)animated
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willBePushedAnimated:)])
		[delegate viewController:self willBePushedAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillBePushedNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillMoveToParent:(UIViewController*)parent
{
	id<JFViewControllerNavigationDelegate> delegate = self.navigationDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:willMoveToParent:)])
		[delegate viewController:self willMoveToParent:parent];
	
	NSDictionary* userInfo = (parent ? @{JFViewControllerParentViewControllerUserInfoKey : parent} : nil);
	[MainNotificationCenter postNotificationName:JFViewControllerWillMoveToParentNotification object:self userInfo:userInfo];
}


#pragma mark User interface management

- (void)hasBeenDismissed:(BOOL)animated
{
	[self jf_notifyHasBeenDismissed:animated];
}

- (void)hasBeenPopped:(BOOL)animated
{
	[self jf_notifyHasBeenPopped:animated];
}

- (void)hasBeenPresented:(BOOL)animated
{
	[self jf_notifyHasBeenPresented:animated];
}

- (void)hasBeenPushed:(BOOL)animated
{
	[self jf_notifyHasBeenPushed:animated];
}

- (void)willBeDismissed:(BOOL)animated
{
	[self jf_notifyWillBeDismissed:animated];
}

- (void)willBePopped:(BOOL)animated
{
	[self jf_notifyWillBePopped:animated];
}

- (void)willBePresented:(BOOL)animated
{
	[self jf_notifyWillBePresented:animated];
}

- (void)willBePushed:(BOOL)animated
{
	[self jf_notifyWillBePushed:animated];
}

@end



#pragma mark



@implementation UIViewController (JFFramework_Rotation)

#pragma mark Properties accessors (Relationships)

- (id<JFViewControllerRotationDelegate>)rotationDelegate
{
	JFWeakHandle* handle = objc_getAssociatedObject(self, @selector(rotationDelegate));
	return handle.object;
}

- (void)setRotationDelegate:(id<JFViewControllerRotationDelegate>)rotationDelegate
{
	JFWeakHandle* handle = nil;
	if(rotationDelegate)
	{
		handle = [[JFWeakHandle alloc] init];
		handle.object = rotationDelegate;
	}
	objc_setAssociatedObject(self, @selector(rotationDelegate), handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark  Notifications management

- (void)jf_notifyDidRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:didRotateFromInterfaceOrientation:)])
		[delegate viewController:self didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	NSDictionary* userInfo = @{JFViewControllerInterfaceOrientationUserInfoKey : @(fromInterfaceOrientation)};
	[MainNotificationCenter postNotificationName:JFViewControllerDidRotateFromInterfaceOrientationNotification object:self userInfo:userInfo];
}

- (UIInterfaceOrientation)jf_notifyPreferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)proposedInterfaceOrientation
{
	UIInterfaceOrientation retVal = proposedInterfaceOrientation;
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:preferredInterfaceOrientationForPresentation:)])
		retVal = [delegate viewController:self preferredInterfaceOrientationForPresentation:retVal];
	
	return retVal;
}

- (BOOL)jf_notifyShouldAutorotate:(BOOL)proposedAnswer
{
	BOOL retVal = proposedAnswer;
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:shouldAutorotate:)])
		retVal = [delegate viewController:self shouldAutorotate:retVal];
	
	return retVal;
}

- (UIInterfaceOrientationMask)jf_notifySupportedInterfaceOrientations:(UIInterfaceOrientationMask)proposedInterfaceOrientations
{
	UIInterfaceOrientationMask retVal = proposedInterfaceOrientations;
	
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:supportedInterfaceOrientations:)])
		retVal = [delegate viewController:self supportedInterfaceOrientations:retVal];
	
	return retVal;
}

- (void)jf_notifyWillAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:willAnimateRotationToInterfaceOrientation:duration:)])
		[delegate viewController:self willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	NSDictionary* userInfo = @{JFViewControllerInterfaceOrientationUserInfoKey : @(toInterfaceOrientation), JFViewControllerDurationUserInfoKey : @(duration)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillAnimateRotationToInterfaceOrientationNotification object:self userInfo:userInfo];
}

- (void)jf_notifyWillRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	id<JFViewControllerRotationDelegate> delegate = self.rotationDelegate;
	if([delegate respondsToSelector:@selector(viewController:willRotateToInterfaceOrientation:duration:)])
		[delegate viewController:self willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	NSDictionary* userInfo = @{JFViewControllerInterfaceOrientationUserInfoKey : @(toInterfaceOrientation), JFViewControllerDurationUserInfoKey : @(duration)};
	[MainNotificationCenter postNotificationName:JFViewControllerWillRotateToInterfaceOrientationNotification object:self userInfo:userInfo];
}

@end



#pragma mark



@implementation UIViewController (JFFramework_Visibility)

#pragma mark Properties accessors (Relationships)

- (id<JFViewControllerVisibilityDelegate>)visibilityDelegate
{
	JFWeakHandle* handle = objc_getAssociatedObject(self, @selector(visibilityDelegate));
	return handle.object;
}

- (void)setVisibilityDelegate:(id<JFViewControllerVisibilityDelegate>)visibilityDelegate
{
	JFWeakHandle* handle = nil;
	if(visibilityDelegate)
	{
		handle = [[JFWeakHandle alloc] init];
		handle.object = visibilityDelegate;
	}
	objc_setAssociatedObject(self, @selector(visibilityDelegate), handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark  Notifications management

- (void)jf_notifyViewDidAppear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewDidAppearAnimated:)])
		[delegate viewController:self viewDidAppearAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerViewDidAppearNotification object:self userInfo:userInfo];
}

- (void)jf_notifyViewDidDisappear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewDidDisappearAnimated:)])
		[delegate viewController:self viewDidDisappearAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerViewDidDisappearNotification object:self userInfo:userInfo];
}

- (void)jf_notifyViewWillAppear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewWillAppearAnimated:)])
		[delegate viewController:self viewWillAppearAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerViewWillAppearNotification object:self userInfo:userInfo];
}

- (void)jf_notifyViewWillDisappear:(BOOL)animated
{
	id<JFViewControllerVisibilityDelegate> delegate = self.visibilityDelegate;
	if(delegate && [delegate respondsToSelector:@selector(viewController:viewWillDisappearAnimated:)])
		[delegate viewController:self viewWillDisappearAnimated:animated];
	
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedUserInfoKey : @(animated)};
	[MainNotificationCenter postNotificationName:JFViewControllerViewWillDisappearNotification object:self userInfo:userInfo];
}

@end

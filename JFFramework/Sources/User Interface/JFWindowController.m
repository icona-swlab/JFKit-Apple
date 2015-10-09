//
//  JFWindowController.m
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



#import "JFWindowController.h"

#import "JFLogger.h"



@interface JFWindowController ()

#pragma mark Properties

// Flags
@property (assign, nonatomic, readwrite, getter = isUserInterfaceLoaded)	BOOL	userInterfaceLoaded;

// User interface
@property (strong, nonatomic, readonly)	NSMutableSet*		privateObservedViewControllers;
@property (weak, nonatomic, readwrite)	UIViewController*	splashViewController;


#pragma mark Methods

// Notifications management
- (void)	notifiedViewControllerDidMoveToParent:(NSNotification*)notification;
- (void)	notifiedViewControllerHasBeenDismissed:(NSNotification*)notification;
- (void)	notifiedViewControllerHasBeenPopped:(NSNotification*)notification;
- (void)	notifiedViewControllerHasBeenPresented:(NSNotification*)notification;
- (void)	notifiedViewControllerHasBeenPushed:(NSNotification*)notification;
- (void)	notifiedViewControllerWillBeDismissed:(NSNotification*)notification;
- (void)	notifiedViewControllerWillBePopped:(NSNotification*)notification;
- (void)	notifiedViewControllerWillBePresented:(NSNotification*)notification;
- (void)	notifiedViewControllerWillBePushed:(NSNotification*)notification;
- (void)	notifiedViewControllerWillMoveToParent:(NSNotification*)notification;
- (void)	notifiedWindowDidBecomeHidden:(NSNotification*)notification;
- (void)	notifiedWindowDidBecomeKey:(NSNotification*)notification;
- (void)	notifiedWindowDidBecomeVisible:(NSNotification*)notification;
- (void)	notifiedWindowDidResignKey:(NSNotification*)notification;

@end



#pragma mark



@implementation JFWindowController

#pragma mark Properties

// Flags
@synthesize userInterfaceLoaded	= _userInterfaceLoaded;

// User interface
@synthesize privateObservedViewControllers	= _privateObservedViewControllers;
@synthesize splashViewController			= _splashViewController;
@synthesize window							= _window;


#pragma mark Properties accessors (User interface)

- (NSSet*)observedViewControllers
{
	return [self.privateObservedViewControllers copy];
}

- (UIViewController*)rootViewController
{
	return self.window.rootViewController;
}


#pragma mark Memory management

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
}

- (instancetype)initWithWindow:(UIWindow*)window
{
	self = (window ? [self init] : nil);
	if(self)
	{
		// Flags
		_userInterfaceLoaded = NO;
		
		// User interface
		_privateObservedViewControllers = [NSMutableSet new];
		_window = window;
		
		// Begins to listen for interesting notifications.
		NSNotificationCenter* center = MainNotificationCenter;
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:window];
		[center addObserver:self selector:@selector(notifiedWindowDidResignKey:) name:UIWindowDidResignKeyNotification object:window];
	}
	return self;
}


#pragma mark Notifications management

- (void)notifiedViewControllerDidMoveToParent:(NSNotification*)notification
{
	UIViewController* parent = [notification.userInfo objectForKey:JFViewControllerParentViewControllerUserInfoKey];
	[self observedViewController:notification.object didMoveToParent:parent];
}

- (void)notifiedViewControllerHasBeenDismissed:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object hasBeenDismissedAnimated:animated];
}

- (void)notifiedViewControllerHasBeenPopped:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object hasBeenPoppedAnimated:animated];
}

- (void)notifiedViewControllerHasBeenPresented:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object hasBeenPresentedAnimated:animated];
}

- (void)notifiedViewControllerHasBeenPushed:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object hasBeenPushedAnimated:animated];
}

- (void)notifiedViewControllerWillBeDismissed:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object willBeDismissedAnimated:animated];
}

- (void)notifiedViewControllerWillBePopped:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object willBePoppedAnimated:animated];
}

- (void)notifiedViewControllerWillBePresented:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object willBePresentedAnimated:animated];
}

- (void)notifiedViewControllerWillBePushed:(NSNotification*)notification
{
	BOOL animated = [[notification.userInfo objectForKey:JFViewControllerIsAnimatedUserInfoKey] boolValue];
	[self observedViewController:notification.object willBePushedAnimated:animated];
}

- (void)notifiedViewControllerWillMoveToParent:(NSNotification*)notification
{
	UIViewController* parent = [notification.userInfo objectForKey:JFViewControllerParentViewControllerUserInfoKey];
	[self observedViewController:notification.object willMoveToParent:parent];
}

- (void)notifiedWindowDidBecomeHidden:(NSNotification*)notification
{
	[self windowDidBecomeHidden];
}

- (void)notifiedWindowDidBecomeKey:(NSNotification*)notification
{
	[self windowDidBecomeKey];
}

- (void)notifiedWindowDidBecomeVisible:(NSNotification*)notification
{
	[self windowDidBecomeVisible];
}

- (void)notifiedWindowDidResignKey:(NSNotification*)notification
{
	[self windowDidResignKey];
}


#pragma mark User interface management

- (UIViewController*)createRootViewController
{
	return nil;
}


#pragma mark User interface management (Observation)

- (void)beginObservingViewController:(UIViewController*)viewController
{
	if(!viewController || [self.privateObservedViewControllers containsObject:viewController])
		return;
	
	[self.privateObservedViewControllers addObject:viewController];
	
	NSNotificationCenter* center = MainNotificationCenter;
	[center addObserver:self selector:@selector(notifiedViewControllerDidMoveToParent:) name:JFViewControllerDidMoveToParentNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenDismissed:) name:JFViewControllerHasBeenDismissedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPopped:) name:JFViewControllerHasBeenPoppedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPresented:) name:JFViewControllerHasBeenPresentedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPushed:) name:JFViewControllerHasBeenPushedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerWillBeDismissed:) name:JFViewControllerWillBeDismissedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerWillBePopped:) name:JFViewControllerWillBePoppedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerWillBePresented:) name:JFViewControllerWillBePresentedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerWillBePushed:) name:JFViewControllerWillBePushedNotification object:viewController];
	[center addObserver:self selector:@selector(notifiedViewControllerWillMoveToParent:) name:JFViewControllerWillMoveToParentNotification object:viewController];
	
	[self didBeginObservingViewController:viewController];
}

- (void)didBeginObservingViewController:(UIViewController*)viewController
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"WindowController '%@' did begin observing viewController '%@'.", JFStringFromObject(self), JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)didEndObservingViewController:(UIViewController*)viewController
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"WindowController '%@' did end observing viewController '%@'.", JFStringFromObject(self), JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)endObservingViewController:(UIViewController*)viewController
{
	if(!viewController || ![self.privateObservedViewControllers containsObject:viewController])
		return;
	
	NSNotificationCenter* center = MainNotificationCenter;
	[center removeObserver:self name:JFViewControllerDidMoveToParentNotification object:viewController];
	[center removeObserver:self name:JFViewControllerHasBeenDismissedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerHasBeenPoppedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerHasBeenPresentedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerHasBeenPushedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerWillBeDismissedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerWillBePoppedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerWillBePresentedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerWillBePushedNotification object:viewController];
	[center removeObserver:self name:JFViewControllerWillMoveToParentNotification object:viewController];
	
	[self.privateObservedViewControllers removeObject:viewController];
	
	[self didEndObservingViewController:viewController];
}

- (void)observedViewController:(UIViewController*)viewController didMoveToParent:(UIViewController*)parent
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' did move to parent '%@'.", JFStringFromObject(viewController), JFStringFromObject(parent)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	if(!parent && [self shouldEndObservingViewController:viewController])
		[self endObservingViewController:viewController];
}

- (void)observedViewController:(UIViewController*)viewController hasBeenDismissedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' has been dismissed.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	if([self shouldEndObservingViewController:viewController])
		[self endObservingViewController:viewController];
}

- (void)observedViewController:(UIViewController*)viewController hasBeenPoppedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' has been popped.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	if([self shouldEndObservingViewController:viewController])
		[self endObservingViewController:viewController];
}

- (void)observedViewController:(UIViewController*)viewController hasBeenPresentedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' has been presented.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController hasBeenPushedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' has been pushed.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController willBeDismissedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' will be dismissed.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController willBePoppedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' will be popped.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController willBePresentedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' will be presented.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController willBePushedAnimated:(BOOL)animated
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' will be pushed.", JFStringFromObject(viewController)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)observedViewController:(UIViewController*)viewController willMoveToParent:(UIViewController*)parent
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"View controller '%@' will move to parent '%@'.", JFStringFromObject(viewController), JFStringFromObject(parent)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (BOOL)shouldEndObservingViewController:(UIViewController*)viewController
{
	return YES;
}


#pragma mark User interface management (Splash screen)

- (UIViewController*)createSplashViewController
{
	return nil;
}

- (void)didDismissSplashViewController:(BOOL)animated
{}

- (void)didPresentSplashViewController:(BOOL)animated
{}

- (void)dismissSplashViewController:(BOOL)animated
{
	if(!self.splashViewController)
		return;
	
	__weak typeof(self) weakSelf = self;
	JFBlock completion = ^(void)
	{
		[weakSelf didDismissSplashViewController:animated];
	};
	
	[self willDismissSplashViewController:animated];
	[self.splashViewController.presentingViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)willDismissSplashViewController:(BOOL)animated
{}

- (void)willPresentSplashViewController:(BOOL)animated
{}


#pragma mark User interface management (Window lifecycle)

- (void)didLoadUserInterface
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface has been loaded.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)loadUserInterface
{
	// Prepares the rootViewController.
	UIViewController* rootViewController = [self createRootViewController];
	[self beginObservingViewController:rootViewController];
	self.window.rootViewController = rootViewController;
	
	// Prepares the splashViewController.
	UIViewController* splashViewController = [self createSplashViewController];
	if(splashViewController)
	{
		[self beginObservingViewController:splashViewController];
		self.splashViewController = splashViewController;
		
		BOOL animated = NO;
		
		__weak typeof(self) weakSelf = self;
		JFBlock completion = ^(void)
		{
			[weakSelf didPresentSplashViewController:animated];
		};
		
		[self willPresentSplashViewController:animated];
		[rootViewController presentViewController:splashViewController animated:animated completion:completion];
	}
}

- (void)willLoadUserInterface
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface will be loaded.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeHidden
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become hidden.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeKey
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become key.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeVisible
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become visible.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
	
	if(![self isUserInterfaceLoaded])
	{
		[self willLoadUserInterface];
		[self loadUserInterface];
		self.userInterfaceLoaded = YES;
		[self didLoadUserInterface];
	}
}

- (void)windowDidResignKey
{
	if([self shouldDebugLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did resign key.", JFStringFromObject(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

@end

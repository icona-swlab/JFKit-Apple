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
@property (strong, nonatomic, readonly)	NSMutableSet*		privateViewControllers;
@property (weak, nonatomic, readwrite)	UIViewController*	splashViewController;


#pragma mark Methods

// Notifications management
//- (void)	notifiedViewControllerDidMoveToParent:(NSNotification*)notification;
//- (void)	notifiedViewControllerHasBeenDismissed:(NSNotification*)notification;
//- (void)	notifiedViewControllerHasBeenPopped:(NSNotification*)notification;
//- (void)	notifiedViewControllerHasBeenPresented:(NSNotification*)notification;
//- (void)	notifiedViewControllerHasBeenPushed:(NSNotification*)notification;
//- (void)	notifiedViewControllerWillBeDismissed:(NSNotification*)notification;
//- (void)	notifiedViewControllerWillBePopped:(NSNotification*)notification;
//- (void)	notifiedViewControllerWillBePresented:(NSNotification*)notification;
//- (void)	notifiedViewControllerWillBePushed:(NSNotification*)notification;
//- (void)	notifiedViewControllerWillMoveToParent:(NSNotification*)notification;
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
@synthesize privateViewControllers	= _privateViewControllers;
@synthesize splashViewController	= _splashViewController;
@synthesize window					= _window;


#pragma mark Properties accessors (User interface)

- (NSSet*)viewControllers
{
	return [self.privateViewControllers copy];
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

//- (void)didReleaseViewController:(UIViewController*)viewController
//{
//	if([self shouldLog])
//	{
//		NSString* message = [NSString stringWithFormat:@"WindowController '%@' did release viewController '%@'.", JFStringFromID(self), JFStringFromID(viewController)];
//		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
//	}
//}
//
//- (void)didRetainViewController:(UIViewController*)viewController
//{
//	if([self shouldLog])
//	{
//		NSString* message = [NSString stringWithFormat:@"WindowController '%@' did retain viewController '%@'.", JFStringFromID(self), JFStringFromID(viewController)];
//		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
//	}
//}

- (instancetype)initWithWindow:(UIWindow*)window
{
	self = (window ? [self init] : nil);
	if(self)
	{
		// Flags
		_userInterfaceLoaded = NO;
		
		// User interface
		_privateViewControllers = [NSMutableSet new];
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

- (void)releaseViewController:(UIViewController*)viewController
{
	if(![self.privateViewControllers containsObject:viewController])
		return;
	
//	NSNotificationCenter* center = MainNotificationCenter;
//	[center removeObserver:self name:JFViewControllerDidMoveToParentNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerHasBeenDismissedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerHasBeenPoppedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerHasBeenPresentedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerHasBeenPushedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerWillBeDismissedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerWillBePoppedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerWillBePresentedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerWillBePushedNotification object:viewController];
//	[center removeObserver:self name:JFViewControllerWillMoveToParentNotification object:viewController];
	
	[self.privateViewControllers removeObject:viewController];
	
	//[self didReleaseViewController:viewController];
}

- (void)retainViewController:(UIViewController*)viewController
{
	if([self.privateViewControllers containsObject:viewController])
		return;
	
	[self.privateViewControllers addObject:viewController];
	
//	NSNotificationCenter* center = MainNotificationCenter;
//	[center addObserver:self selector:@selector(notifiedViewControllerDidMoveToParent:) name:JFViewControllerDidMoveToParentNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenDismissed:) name:JFViewControllerHasBeenDismissedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPopped:) name:JFViewControllerHasBeenPoppedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPresented:) name:JFViewControllerHasBeenPresentedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerHasBeenPushed:) name:JFViewControllerHasBeenPushedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerWillBeDismissed:) name:JFViewControllerWillBeDismissedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerWillBePopped:) name:JFViewControllerWillBePoppedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerWillBePresented:) name:JFViewControllerWillBePresentedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerWillBePushed:) name:JFViewControllerWillBePushedNotification object:viewController];
//	[center addObserver:self selector:@selector(notifiedViewControllerWillMoveToParent:) name:JFViewControllerWillMoveToParentNotification object:viewController];
	
	//[self didRetainViewController:viewController];
}


#pragma mark Notifications management

//- (void)notifiedViewControllerDidMoveToParent:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerHasBeenDismissed:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerHasBeenPopped:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerHasBeenPresented:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerHasBeenPushed:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerWillBeDismissed:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerWillBePopped:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerWillBePresented:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerWillBePushed:(NSNotification*)notification
//{}
//
//- (void)notifiedViewControllerWillMoveToParent:(NSNotification*)notification
//{}

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

- (UIViewController*)createSplashViewController
{
	return nil;
}


#pragma mark User interface management (Navigation)

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
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface has been loaded.", JFStringFromID(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)loadUserInterface
{
	// Prepares the rootViewController.
	UIViewController* rootViewController = [self createRootViewController];
	self.window.rootViewController = rootViewController;
	
	// Prepares the splashViewController.
	UIViewController* splashViewController = [self createSplashViewController];
	if(splashViewController)
	{
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
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface will be loaded.", JFStringFromID(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeHidden
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become hidden.", JFStringFromID(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeKey
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become key.", JFStringFromID(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeVisible
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become visible.", JFStringFromID(self.window)];
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
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did resign key.", JFStringFromID(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

@end



//- (BOOL)replaceRootViewControllerWithViewController:(UIViewController*)viewController
//{
//	return [self replaceRootViewControllerWithViewController:viewController completion:nil];
//}
//
//- (BOOL)replaceRootViewControllerWithViewController:(UIViewController*)viewController completion:(JFBlockWithBOOL)completion
//{
//	return [self replaceRootViewControllerWithViewController:viewController duration:JFAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve completion:completion];
//}
//
//- (BOOL)replaceRootViewControllerWithViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(JFBlockWithBOOL)completion
//{
//	if(!viewController)
//		return NO;
//
//	UIViewController* rootViewController = self.window.rootViewController;
//	if(rootViewController == viewController)
//		return NO;
//
//	JFBlockWithBOOL innerCompletion = ^(BOOL finished)
//	{
//		if(finished)
//			self.window.rootViewController = viewController;
//
//		if(completion)
//			completion(finished);
//	};
//
//	if(!rootViewController)
//	{
//		[MainOperationQueue addOperationWithBlock:^(void){
//			innerCompletion(YES);
//		}];
//		return YES;
//	}
//
//	UIView* fromView = rootViewController.view;
//	UIView* toView = viewController.view;
//
//	[UIView transitionFromView:fromView toView:toView duration:duration options:options completion:innerCompletion];
//
//	return YES;
//}

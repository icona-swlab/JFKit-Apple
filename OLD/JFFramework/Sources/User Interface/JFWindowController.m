//
//  JFWindowController.m
//  Copyright (C) 2015  Jacopo Filié
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


#pragma mark Methods

// Notifications management (UIWindow)
- (void)	notifiedThatWindowDidBecomeHidden:(NSNotification*)notification;
- (void)	notifiedThatWindowDidBecomeKey:(NSNotification*)notification;
- (void)	notifiedThatWindowDidBecomeVisible:(NSNotification*)notification;
- (void)	notifiedThatWindowDidResignKey:(NSNotification*)notification;

@end



#pragma mark



@implementation JFWindowController

#pragma mark Properties

// Flags
@synthesize userInterfaceLoaded	= _userInterfaceLoaded;

// User interface
@synthesize window	= _window;


#pragma mark Memory management

- (void)dealloc
{
	[NSDefaultNotificationCenter removeObserver:self];
}

- (instancetype)initWithWindow:(UIWindow*)window
{
	self = (window ? [self init] : nil);
	if(self)
	{
		// Flags
		_userInterfaceLoaded = NO;
		
		// User interface
		_window = window;
		
		// Begins to listen for interesting notifications.
		NSNotificationCenter* center = NSDefaultNotificationCenter;
		[center addObserver:self selector:@selector(notifiedThatWindowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:window];
		[center addObserver:self selector:@selector(notifiedThatWindowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:window];
		[center addObserver:self selector:@selector(notifiedThatWindowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:window];
		[center addObserver:self selector:@selector(notifiedThatWindowDidResignKey:) name:UIWindowDidResignKeyNotification object:window];
	}
	return self;
}


#pragma mark User interface management (Window lifecycle)

- (void)didLoadUserInterface
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface has been loaded.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)loadUserInterface
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface is being loaded.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)willLoadUserInterface
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' user interface will be loaded.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeHidden
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become hidden.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeKey
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become key.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}

- (void)windowDidBecomeVisible
{
	if([self shouldLog])
	{
		NSString* message = [NSString stringWithFormat:@"Window '%@' did become visible.", IDToString(self.window)];
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
		NSString* message = [NSString stringWithFormat:@"Window '%@' did resign key.", IDToString(self.window)];
		[self.logger logMessage:message level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	}
}


#pragma mark Notifications management (UIWindow)

- (void)notifiedThatWindowDidBecomeHidden:(NSNotification*)notification
{
	[self windowDidBecomeHidden];
}

- (void)notifiedThatWindowDidBecomeKey:(NSNotification*)notification
{
	[self windowDidBecomeKey];
}

- (void)notifiedThatWindowDidBecomeVisible:(NSNotification*)notification
{
	[self windowDidBecomeVisible];
}

- (void)notifiedThatWindowDidResignKey:(NSNotification*)notification
{
	[self windowDidResignKey];
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
//		[NSMainOperationQueue addOperationWithBlock:^(void){
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

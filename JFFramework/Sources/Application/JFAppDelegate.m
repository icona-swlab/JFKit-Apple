//
//  JFAppDelegate.m
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



#import "JFAppDelegate.h"

#import "NSObject+JFFramework.h"

#import "JFAlertsController.h"
#import "JFLogger.h"
#import "JFUtilities.h"
#if TARGET_OS_IPHONE
#import "JFWindowController.h"
#endif



@interface JFAppDelegate ()

#pragma mark Properties

// User interface
#if TARGET_OS_IPHONE
@property (strong, nonatomic)	JFWindowController*	windowController;
#endif

@end



#pragma mark



@implementation JFAppDelegate

#pragma mark Properties

// User interface
@synthesize alertsController	= _alertsController;
@synthesize window				= _window;
#if TARGET_OS_IPHONE
@synthesize windowController	= _windowController;
#endif


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
#ifdef DEBUG
		self.logger.level = JFLogLevel7Debug;
#endif
		
		// User interface
		_alertsController = [[JFAlertsController alloc] init];
	}
	return self;
}


#pragma mark User interface management

#if TARGET_OS_IPHONE
- (JFWindowController*)createControllerForWindow:(UIWindow*)window
{
	return nil;
}
#endif


#if TARGET_OS_IPHONE

#pragma mark Protocol implementation (UIApplicationDelegate)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	[self.logger logMessage:@"Application opened." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
	
	// Loads the user interface.
	self.window = [[UIWindow alloc] initWithFrame:MainScreen.bounds];
	JFWindowController* controller = [self createControllerForWindow:self.window];
	self.windowController = (controller ? controller : [[JFWindowController alloc] initWithWindow:self.window]);
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
	[self.logger logMessage:@"Application did become active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
	[self.logger logMessage:@"Application did enter background." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
	[self.logger logMessage:@"Application did receive memory warning." level:JFLogLevel4Warning hashtags:JFLogHashtagAttention];
}

- (void)applicationWillResignActive:(UIApplication*)application;
{
	[self.logger logMessage:@"Application will resign active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
	[self.logger logMessage:@"Application will enter foreground." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
	[self.logger logMessage:@"Application will terminate." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}


#else
#pragma mark Protocol implementation (NSApplicationDelegate)

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	[self.logger logMessage:@"Application opened." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillBecomeActive:(NSNotification*)notification
{
	[self.logger logMessage:@"Application will become active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
	[self.logger logMessage:@"Application did become active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillResignActive:(NSNotification*)notification
{
	[self.logger logMessage:@"Application will resign active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidResignActive:(NSNotification*)notification
{
	[self.logger logMessage:@"Application did resign active." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[self.logger logMessage:@"Application will terminate." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillHide:(NSNotification*)notification
{
	[self.logger logMessage:@"Application will hide." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidHide:(NSNotification*)notification
{
	[self.logger logMessage:@"Application did hide." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillUnhide:(NSNotification*)notification
{
	[self.logger logMessage:@"Application will unhide." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidUnhide:(NSNotification*)notification
{
	[self.logger logMessage:@"Application did unhide." level:JFLogLevel6Info hashtags:JFLogHashtagDeveloper];
}

#endif

@end

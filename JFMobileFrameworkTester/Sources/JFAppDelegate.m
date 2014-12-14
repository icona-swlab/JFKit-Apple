//
//  JFAppDelegate.m
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 14/12/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFAppDelegate.h"

#import "JFWindowManager.h"



@interface JFAppDelegate ()

// User interface
@property (strong, nonatomic)	JFWindowManager*	windowManager;

@end



@implementation JFAppDelegate

#pragma mark - Properties

// User interface
@synthesize window			= _window;
@synthesize windowManager	= _windowManager;


#pragma mark - Delegation management (UIApplicationDelegate)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	[[JFLogger defaultLogger] logMessage:@"Application opened." hashtags:LogHashtagDeveloper];
	
	// Loads the user interface.
	self.windowManager = [[JFWindowManager alloc] init];
	[self.windowManager loadUserInterface];
	self.window = self.windowManager.window;
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
	[[JFLogger defaultLogger] logMessage:@"Application did become active." hashtags:LogHashtagDeveloper];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
	[[JFLogger defaultLogger] logMessage:@"Application did enter background." hashtags:LogHashtagDeveloper];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
	[[JFLogger defaultLogger] logMessage:@"Application did receive memory warning." hashtags:(LogHashtagAttention | LogHashtagDeveloper)];
}

- (void)applicationWillResignActive:(UIApplication*)application;
{
	[[JFLogger defaultLogger] logMessage:@"Application will resign active." hashtags:LogHashtagDeveloper];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
	[[JFLogger defaultLogger] logMessage:@"Application will enter foreground." hashtags:LogHashtagDeveloper];
}

@end

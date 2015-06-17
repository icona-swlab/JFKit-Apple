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
#import "JFWindowController.h"



@interface JFAppDelegate ()

#pragma mark Properties

// User interface
@property (strong, nonatomic)	JFWindowController*	windowController;

@end



#pragma mark



@implementation JFAppDelegate

#pragma mark Properties

// User interface
@synthesize alertsController	= _alertsController;
@synthesize window				= _window;
@synthesize windowController	= _windowController;


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
#ifdef DEBUG
		self.logger.level = JFLogLevelDebug;
#endif
		
		// User interface
		_alertsController = [[JFAlertsController alloc] init];
	}
	return self;
}


#pragma mark User interface management

- (JFWindowController*)createControllerForWindow:(UIWindow*)window
{
	return nil;
}


#pragma mark Protocol implementation (UIApplicationDelegate)

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	[self.logger logMessage:@"Application opened." level:JFLogLevelDebug hashtags:JFLogHashtagDeveloper];
	
	// Loads the user interface.
	self.window = [[UIWindow alloc] initWithFrame:UIMainScreen.bounds];
	JFWindowController* controller = [self createControllerForWindow:self.window];
	self.windowController = (controller ? controller : [[JFWindowController alloc] initWithWindow:self.window]);
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
	[self.logger logMessage:@"Application did become active." level:JFLogLevelDebug hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
	[self.logger logMessage:@"Application did enter background." level:JFLogLevelDebug hashtags:JFLogHashtagDeveloper];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
	[self.logger logMessage:@"Application did receive memory warning." level:JFLogLevelWarning hashtags:JFLogHashtagAttention];
}

- (void)applicationWillResignActive:(UIApplication*)application;
{
	[self.logger logMessage:@"Application will resign active." level:JFLogLevelDebug hashtags:JFLogHashtagDeveloper];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
	[self.logger logMessage:@"Application will enter foreground." level:JFLogLevelDebug hashtags:JFLogHashtagDeveloper];
}

@end

//
//  JFAppDelegate.h
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



#import "JFUtilities.h"



@class JFAlertsController;
#if TARGET_OS_IPHONE
@class JFWindowController;
#endif



#if TARGET_OS_IPHONE
@interface JFAppDelegate : UIResponder <UIApplicationDelegate>
#else
@interface JFAppDelegate : NSObject <NSApplicationDelegate>
#endif

#pragma mark Properties

// User interface
@property (strong, nonatomic, readonly)	JFAlertsController*	alertsController;
#if TARGET_OS_IPHONE
@property (strong, nonatomic, readonly)	JFWindowController*	windowController;
#endif


#pragma mark Methods

#if TARGET_OS_IPHONE
// User interface management
- (JFWindowController*)	createControllerForWindow:(UIWindow*)window;
#endif

#if TARGET_OS_IPHONE
// Protocol implementation (UIApplicationDelegate)
- (BOOL)	application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
- (void)	applicationDidBecomeActive:(UIApplication*)application;
- (void)	applicationDidEnterBackground:(UIApplication*)application;
- (void)	applicationDidReceiveMemoryWarning:(UIApplication*)application;
- (void)	applicationWillEnterForeground:(UIApplication*)application;
- (void)	applicationWillResignActive:(UIApplication*)application;
- (void)	applicationWillTerminate:(UIApplication*)application;
#else
// Protocol implementation (NSApplicationDelegate)
- (void)	applicationDidBecomeActive:(NSNotification*)notification;
- (void)	applicationDidFinishLaunching:(NSNotification*)notification;
- (void)	applicationDidHide:(NSNotification*)notification;
- (void)	applicationDidResignActive:(NSNotification*)notification;
- (void)	applicationDidUnhide:(NSNotification*)notification;
- (void)	applicationWillBecomeActive:(NSNotification*)notification;
- (void)	applicationWillHide:(NSNotification*)notification;
- (void)	applicationWillResignActive:(NSNotification*)notification;
- (void)	applicationWillTerminate:(NSNotification *)notification;
- (void)	applicationWillUnhide:(NSNotification*)notification;
#endif

@end

//
//  AppDelegate.m
//  JFFramework-App-iOS
//
//  Created by Jacopo Filié on 17/08/15.
//
//



#import "AppDelegate.h"

#import "WindowController.h"



@interface AppDelegate ()

@end



@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	BOOL retVal = [super application:application didFinishLaunchingWithOptions:launchOptions];
	if(retVal)
	{}
	return retVal;
}

- (JFWindowController*)createControllerForWindow:(UIWindow*)window
{
	return [[WindowController alloc] initWithWindow:window];
}

@end

//
//  AppDelegate.m
//  JFFramework-App-OSX
//
//  Created by Jacopo Filié on 17/08/15.
//
//

#import "AppDelegate.h"

#import "JFShortcuts.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	[super applicationDidFinishLaunching:notification];
	
	__unused JFLogger* l0 = [JFLogger defaultLogger];
	__unused JFLogger* l1 = [JFLogger new];
	__unused JFLogger* l2 = [JFLogger new];
	
	__unused JFLogger* l3 = [NSObject defaultLogger];
	__unused JFLogger* l4 = [NSString defaultLogger];
	
	[NSObject setDefaultLogger:l1];
	[NSString setDefaultLogger:l2];
	
	__unused JFLogger* l5 = [NSObject defaultLogger];
	__unused JFLogger* l6 = [NSString defaultLogger];
	
	LogMethod;
}

@end

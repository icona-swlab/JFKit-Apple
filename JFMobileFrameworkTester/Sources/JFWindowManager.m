//
//  JFWindowManager.m
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 17/09/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFWindowManager.h"



@interface JFWindowManager ()

// Flags
@property (assign, nonatomic, readwrite)	BOOL	isUserInterfaceLoaded;

@end



@implementation JFWindowManager

#pragma mark - Properties

// Flags
@synthesize isUserInterfaceLoaded	= _isUserInterfaceLoaded;

// User interface
@synthesize window	= _window;


#pragma mark - Memory management

- (instancetype)init
{
	UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self = (window ? [super init] : nil);
	if(self)
	{
		// Flags
		_isUserInterfaceLoaded = NO;
		
		// User interface
		_window = window;
	}
	return self;
}


#pragma mark - User interface management

- (void)loadUserInterface
{
	if(self.isUserInterfaceLoaded)
		return;
	
	self.isUserInterfaceLoaded = YES;
	
	self.window.backgroundColor = [UIColor blackColor];
	self.window.rootViewController = [UIViewController new];
	self.window.rootViewController.view.backgroundColor = [UIColor redColor];
}

@end

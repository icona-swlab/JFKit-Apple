//
//  JFWindowManager.h
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 17/09/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



@interface JFWindowManager : NSObject

// Flags
@property (assign, nonatomic, readonly)	BOOL	isUserInterfaceLoaded;

// User interface
@property (strong, nonatomic, readonly)	UIWindow*	window;

// User interface management
- (void)	loadUserInterface;

@end

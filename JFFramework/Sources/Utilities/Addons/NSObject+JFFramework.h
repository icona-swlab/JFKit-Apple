//
//  NSObject+JFFramework.h
//  JFFramework
//
//  Created by Jacopo Filié on 17/06/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFLogger.h"



@interface NSObject (JFFramework)

#pragma mark Properties

// Flags
@property (assign)	BOOL	shouldLog;

// Utilities
@property (strong)	JFLogger*	logger;


#pragma mark Methods

// Properties accessors (Flags)
+ (BOOL)	defaultShouldLogValue;
+ (void)	setDefaultShouldLogValue:(BOOL)shouldLog;

// Properties accessors (Utilities)
+ (JFLogger*)	defaultLogger;
+ (void)		setDefaultLogger:(JFLogger*)logger;

@end

//
//  JFManager.h
//  JFFramework
//
//  Created by Jacopo Filié on 09/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



@class JFLogger;



@interface JFManager : NSObject

#pragma mark Properties

// Debugging
@property (strong)						JFLogger*	logger;
@property (assign, getter = isLogging)	BOOL		logging;


#pragma mark Methods

// Memory management
+ (instancetype)	defaultManager;

@end

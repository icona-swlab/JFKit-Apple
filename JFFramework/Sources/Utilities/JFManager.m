//
//  JFManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 09/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFManager.h"

#import "JFLogger.h"
#import "JFUtilities.h"



@implementation JFManager

#pragma mark Properties

// Debugging
@synthesize logger	= _logger;
@synthesize logging	= _logging;


#pragma mark Memory management

+ (instancetype)defaultManager
{
	static NSMutableDictionary* defaultManagers = nil;
	
	id retObj = nil;
	
	@synchronized(self)
	{
		if(!defaultManagers)
			defaultManagers = [NSMutableDictionary new];
		
		NSString* key = ClassName;
		
		retObj = [defaultManagers objectForKey:key];
		if(!retObj)
		{
			retObj = [[self alloc] init];
			if(retObj)
				[defaultManagers setObject:retObj forKey:key];
		}
	}
	
	return retObj;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Debugging
		_logger = [JFLogger defaultLogger];
		_logging = YES;
	}
	return self;
}

@end

//
//  NSObject+JFFramework.m
//  JFFramework
//
//  Created by Jacopo Filié on 17/06/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "NSObject+JFFramework.h"

#import <objc/runtime.h>



@implementation NSObject (JFFramework)

#pragma Class properties

// Flags
static BOOL	_defaultShouldLogValue	= YES;

// Utilities
static JFLogger*	_defaultLogger	= nil;


#pragma mark Properties accessors (Flags)

+ (BOOL)defaultShouldLogValue
{
	@synchronized(self)
	{
		return _defaultShouldLogValue;
	}
}

+ (void)setDefaultShouldLogValue:(BOOL)shouldLog
{
	@synchronized(self)
	{
		_defaultShouldLogValue = shouldLog;
	}
}

- (BOOL)shouldLog
{
	@synchronized(self)
	{
		BOOL retVal;
		NSNumber* number = objc_getAssociatedObject(self, @selector(shouldLog));
		if(!number)
		{
			retVal = [[self class] defaultShouldLogValue];
			[self setShouldLog:retVal];
		}
		else
			retVal = [number boolValue];
		return retVal;
	}
}

- (void)setShouldLog:(BOOL)shouldLog
{
	@synchronized(self)
	{
		objc_setAssociatedObject(self, @selector(shouldLog), @(shouldLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}


#pragma mark Properties accessors (Utilities)

+ (JFLogger*)defaultLogger
{
	@synchronized(self)
	{
		if(!_defaultLogger)
			_defaultLogger = [JFLogger defaultLogger];
		return _defaultLogger;
	}
}

+ (void)setDefaultLogger:(JFLogger*)logger
{
	@synchronized(self)
	{
		_defaultLogger = logger;
	}
}

- (JFLogger*)logger
{
	@synchronized(self)
	{
		JFLogger* retObj = objc_getAssociatedObject(self, @selector(logger));
		if(!retObj)
		{
			retObj = [[self class] defaultLogger];
			[self setLogger:retObj];
		}
		return retObj;
	}
}

- (void)setLogger:(JFLogger*)logger
{
	@synchronized(self)
	{
		objc_setAssociatedObject(self, @selector(logger), logger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end

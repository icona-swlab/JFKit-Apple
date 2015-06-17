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

#pragma mark Properties accessors (Flags)

+ (BOOL)defaultShouldLogValue
{
	@synchronized(self)
	{
		BOOL retVal = YES;
		NSNumber* number = objc_getAssociatedObject(self, @selector(defaultShouldLogValue));
		if(!number)
			[self setDefaultShouldLogValue:retVal];
		else
			retVal = [number boolValue];
		return retVal;
	}
}

+ (void)setDefaultShouldLogValue:(BOOL)shouldLog
{
	@synchronized(self)
	{
		objc_setAssociatedObject(self, @selector(defaultShouldLogValue), @(shouldLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
		JFLogger* retObj = objc_getAssociatedObject(self, @selector(defaultLogger));
		if(!retObj)
		{
			retObj = [JFLogger defaultLogger];
			[self setDefaultLogger:retObj];
		}
		return retObj;
	}
}

+ (void)setDefaultLogger:(JFLogger*)logger
{
	@synchronized(self)
	{
		objc_setAssociatedObject(self, @selector(defaultLogger), logger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

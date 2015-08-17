//
//  NSObject+JFFramework.m
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



#import "NSObject+JFFramework.h"

#import <objc/runtime.h>

#import "JFLogger.h"



@implementation NSObject (JFFramework)

#pragma mark Class properties

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

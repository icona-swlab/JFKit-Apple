//
//  NSObject+JFLogger.m
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



#import "NSObject+JFLogger.h"

#import <objc/runtime.h>

#import "JFLogger.h"



#pragma mark - Constants

static NSString* const	JFLoggerKey			= @"LoggerKey";
static NSString* const	JFShouldDebugLogKey	= @"ShouldDebugLogKey";
static NSString* const	JFShouldLogKey		= @"ShouldLogKey";



@implementation NSObject (JFLogger)

#pragma mark Properties accessors (Flags)

+ (BOOL)defaultShouldDebugLogValue
{
	@synchronized(JFShouldDebugLogKey)
	{
		BOOL retVal;
		NSNumber* number = objc_getAssociatedObject(self, @selector(defaultShouldDebugLogValue));
		if(number)
			retVal = [number boolValue];
		else if(self == [NSObject class])
		{
#ifdef DEBUG
			retVal = YES;
#else
			retVal = NO;
#endif
			[self setDefaultShouldDebugLogValue:retVal];
		}
		else
			retVal = [[self superclass] defaultShouldDebugLogValue];
		return retVal;
	}
}

+ (BOOL)defaultShouldLogValue
{
	@synchronized(JFShouldLogKey)
	{
		BOOL retVal;
		NSNumber* number = objc_getAssociatedObject(self, @selector(defaultShouldLogValue));
		if(number)
			retVal = [number boolValue];
		else if(self == [NSObject class])
		{
			retVal = YES;
			[self setDefaultShouldLogValue:retVal];
		}
		else
			retVal = [[self superclass] defaultShouldLogValue];
		return retVal;
	}
}

+ (void)setDefaultShouldDebugLogValue:(BOOL)shouldDebugLog
{
	@synchronized(JFShouldDebugLogKey)
	{
		objc_setAssociatedObject(self, @selector(defaultShouldDebugLogValue), @(shouldDebugLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

+ (void)setDefaultShouldLogValue:(BOOL)shouldLog
{
	@synchronized(JFShouldLogKey)
	{
		objc_setAssociatedObject(self, @selector(defaultShouldLogValue), @(shouldLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (BOOL)shouldDebugLog
{
	@synchronized(JFShouldDebugLogKey)
	{
		BOOL retVal;
		NSNumber* number = objc_getAssociatedObject(self, @selector(shouldDebugLog));
		if(number)
			retVal = [number boolValue];
		else
		{
			retVal = [[self class] defaultShouldDebugLogValue];
			[self setShouldDebugLog:retVal];
		}
		return retVal;
	}
}

- (BOOL)shouldLog
{
	@synchronized(JFShouldLogKey)
	{
		BOOL retVal;
		NSNumber* number = objc_getAssociatedObject(self, @selector(shouldLog));
		if(number)
			retVal = [number boolValue];
		else
		{
			retVal = [[self class] defaultShouldLogValue];
			[self setShouldLog:retVal];
		}
		return retVal;
	}
}

- (void)setShouldDebugLog:(BOOL)shouldDebugLog
{
	@synchronized(JFShouldDebugLogKey)
	{
		objc_setAssociatedObject(self, @selector(shouldDebugLog), @(shouldDebugLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)setShouldLog:(BOOL)shouldLog
{
	@synchronized(JFShouldLogKey)
	{
		objc_setAssociatedObject(self, @selector(shouldLog), @(shouldLog), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}


#pragma mark Properties accessors (Utilities)

+ (JFLogger*)defaultLogger
{
	@synchronized(JFLoggerKey)
	{
		JFLogger* retObj = objc_getAssociatedObject(self, @selector(defaultLogger));
		if(!retObj)
		{
			if(self == [NSObject class])
			{
				retObj = [JFLogger defaultLogger];
				[self setDefaultLogger:retObj];
			}
			else
				retObj = [[self superclass] defaultLogger];
		}
		return retObj;
	}
}

+ (void)setDefaultLogger:(JFLogger*)logger
{
	@synchronized(JFLoggerKey)
	{
		objc_setAssociatedObject(self, @selector(defaultLogger), logger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (JFLogger*)logger
{
	@synchronized(JFLoggerKey)
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
	@synchronized(JFLoggerKey)
	{
		objc_setAssociatedObject(self, @selector(logger), logger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end

//
//  NSIndexPath+JFFramework.m
//  JFFramework
//
//  Created by Jacopo Filié on 01/07/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "NSIndexPath+JFFramework.h"



@implementation NSIndexPath (JFFramework)

#pragma mark Memory management

+ (instancetype)indexPathWithSymbolSeparatedValues:(NSString*)symbolSeparatedValues symbol:(NSString*)symbol
{
	return [[self alloc] initWithSymbolSeparatedValues:symbolSeparatedValues symbol:symbol];
}

- (instancetype)initWithSymbolSeparatedValues:(NSString*)symbolSeparatedValues symbol:(NSString*)symbol
{
	if(!symbolSeparatedValues)
	{
		self = nil;
		return nil;
	}
	
	if(symbol)
	{
		NSArray* values = [symbolSeparatedValues componentsSeparatedByString:symbol];
		NSUInteger length = [values count];
		NSUInteger* integers = (NSUInteger*)malloc(sizeof(NSUInteger) * length);
		for(NSUInteger i = 0; i < length; i++)
		{
			NSString* value = [values objectAtIndex:i];
			integers[i] = [value integerValue];
		}
		self = [self initWithIndexes:integers length:length];
		free(integers);
	}
	else
		self = [self initWithIndex:[symbolSeparatedValues integerValue]];
	return self;
}

@end

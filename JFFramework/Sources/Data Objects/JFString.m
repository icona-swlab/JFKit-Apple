//
//  JFString.m
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



#import "JFString.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

NSString* const	JFEmptyString	= @"";
NSString* const	JFFalseString	= @"False";
NSString* const	JFNoString		= @"No";
NSString* const	JFTrueString	= @"True";
NSString* const	JFYesString		= @"Yes";

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

BOOL JFStringIsEmpty(NSString* string)
{
	return (string && [string isEqualToString:JFEmptyString]);
}

BOOL JFStringIsNullOrEmpty(NSString* string)
{
	return (!string || [string isEqualToString:JFEmptyString]);
}

NSString* JFStringMakeRandom(NSUInteger length)
{
	static NSString* characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return JFStringMakeRandomWithCharacters(length, characters);
}

NSString* JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters)
{
	if(!characters)
		return nil;
	
	if((length == 0) || (JFStringIsEmpty(characters)))
		return JFEmptyString;
	
	u_int32_t count = (u_int32_t)[characters length];
	
	NSMutableString* retObj = [NSMutableString stringWithCapacity:length];
	for(NSUInteger i = 0; i < length; i++)
	{
		NSUInteger index = arc4random_uniform(count);
		[retObj appendFormat:@"%C", [characters characterAtIndex:index]];
	}
	return [retObj copy];
}


#pragma mark Functions (Conversions)

NSString* JFStringFromBool(BOOL value)
{
	return (value ? JFYesString : JFNoString);
}

NSString* JFStringFromBoolean(Boolean value)
{
	return (value ? JFTrueString : JFFalseString);
}

NSString* JFStringFromDouble(double value)
{
	return [NSString stringWithFormat:@"%f", value];
}

NSString* JFStringFromFloat(float value)
{
	return [NSString stringWithFormat:@"%f", value];
}

NSString* JFStringFromHex(unsigned int value)
{
	return [NSString stringWithFormat:@"%x", value];
}

NSString* JFStringFromID(id object)
{
	return [NSString stringWithFormat:@"%p", object];
}

NSString* JFStringFromInt(int value)
{
	return [NSString stringWithFormat:@"%d", value];
}

NSString* JFStringFromLong(long value)
{
	return [NSString stringWithFormat:@"%ld", value];
}

NSString* JFStringFromLongLong(long long value)
{
	return [NSString stringWithFormat:@"%lld", value];
}

NSString* JFStringFromNSInteger(NSInteger value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%ld", (long)value];
#else
	return [NSString stringWithFormat:@"%d", (int)value];
#endif
}

NSString* JFStringFromNSUInteger(NSUInteger value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
#else
	return [NSString stringWithFormat:@"%u", (unsigned int)value];
#endif
}

NSString* JFStringFromObject(id object)
{
	return [NSString stringWithFormat:@"<%@: %@>", JFStringFromObjectClass(object), JFStringFromID(object)];
}

NSString* JFStringFromPointer(void* pointer)
{
	return [NSString stringWithFormat:@"%p", pointer];
}

NSString* JFStringFromSInt8(SInt8 value)
{
	return [NSString stringWithFormat:@"%hhd", value];
}

NSString* JFStringFromSInt16(SInt16 value)
{
	return [NSString stringWithFormat:@"%hd", value];
}

NSString* JFStringFromSInt32(SInt32 value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%d", (signed int)value];
#else
	return [NSString stringWithFormat:@"%ld", (signed long)value];
#endif
}

NSString* JFStringFromSInt64(SInt64 value)
{
	return [NSString stringWithFormat:@"%lld", value];
}

NSString* JFStringFromUInt8(UInt8 value)
{
	return [NSString stringWithFormat:@"%hhu", value];
}

NSString* JFStringFromUInt16(UInt16 value)
{
	return [NSString stringWithFormat:@"%hu", value];
}

NSString* JFStringFromUInt32(UInt32 value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%u", (unsigned int)value];
#else
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
#endif
}

NSString* JFStringFromUInt64(UInt64 value)
{
	return [NSString stringWithFormat:@"%llu", value];
}

NSString* JFStringFromUnsignedInt(unsigned int value)
{
	return [NSString stringWithFormat:@"%u", value];
}

NSString* JFStringFromUnsignedLong(unsigned long value)
{
	return [NSString stringWithFormat:@"%lu", value];
}

NSString* JFStringFromUnsignedLongLong(unsigned long long value)
{
	return [NSString stringWithFormat:@"%llu", value];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

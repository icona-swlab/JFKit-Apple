//
//  JFUtilities.h
//  Copyright (C) 2015  Jacopo Filié
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



#import "JFUtilities.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants (Colors)

UInt8 const Color8ComponentMaxValue		= 0x3;
UInt8 const Color16ComponentMaxValue	= 0xF;
UInt8 const Color32ComponentMaxValue	= 0xFF;


#pragma mark - Constants (Strings)

NSString* const	EmptyString	= @"";
NSString* const	FalseString	= @"NO";
NSString* const	TrueString	= @"YES";

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions (Colors)

#if TARGET_OS_IPHONE

UIColor* colorWithComponents(Color32Components components)
{
	UInt8 red	= components.red;
	UInt8 green	= components.green;
	UInt8 blue	= components.blue;
	UInt8 alpha	= components.alpha;
	
	return colorWithRGBA(red, green, blue, alpha);
}

UIColor* colorWithHex(UInt32 value)
{
	Color32 color;
	color.value = value;
	
	return colorWithComponents(color.components);
}

UIColor* colorWithRGB(UInt8 r, UInt8 g, UInt8 b)
{
	return colorWithRGBA(r, g, b, UCHAR_MAX);
}

UIColor* colorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a)
{
	CGFloat maxValue = UCHAR_MAX;
	
	CGFloat red		= (CGFloat)r / maxValue;
	CGFloat green	= (CGFloat)g / maxValue;
	CGFloat blue	= (CGFloat)b / maxValue;
	CGFloat alpha	= (CGFloat)a / maxValue;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#else

NSColor* colorWithComponents(Color32Components components)
{
	UInt8 red	= components.red;
	UInt8 green	= components.green;
	UInt8 blue	= components.blue;
	UInt8 alpha	= components.alpha;
	
	return colorWithRGBA(red, green, blue, alpha);
}

NSColor* colorWithHex(UInt32 value)
{
	Color32 color;
	color.value = value;
	
	return colorWithComponents(color.components);
}

NSColor* colorWithRGB(UInt8 r, UInt8 g, UInt8 b)
{
	return colorWithRGBA(r, g, b, UCHAR_MAX);
}

NSColor* colorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a)
{
	CGFloat maxValue = UCHAR_MAX;
	
	CGFloat red		= (CGFloat)r / maxValue;
	CGFloat green	= (CGFloat)g / maxValue;
	CGFloat blue	= (CGFloat)b / maxValue;
	CGFloat alpha	= (CGFloat)a / maxValue;
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

#endif


#pragma mark - Functions (Math)

Degrees degreesFromRadians(Radians radians)
{
	return radians * 180.0 / M_PI;
}

Radians radiansFromDegress(Degrees degrees)
{
	return degrees * M_PI / 180.0;
}


#pragma mark - Functions (Runtime)

void performSelector(NSObject* target, SEL action)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL) = (void*)implementation;
	performMethod(target, action);
}

void performSelector1(NSObject* target, SEL action, id object)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id) = (void*)implementation;
	performMethod(target, action, object);
}

void performSelector2(NSObject* target, SEL action, id obj1, id obj2)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id, id) = (void*)implementation;
	performMethod(target, action, obj1, obj2);
}


#pragma mark - Functions (Streams)

ByteStream ByteStreamAlloc(NSUInteger length)
{
	return ByteStreamMake(((length > 0) ? (Byte*)malloc(length) : NULL), length);
}

ByteStream ByteStreamCCopy(ByteStream byteStream, NSUInteger length)
{
	length = MIN(length, byteStream.length);
	if(length == 0)
		return ByteStreamNull;
	
	ByteStream retVal = ByteStreamAlloc(length);
	memcpy(retVal.bytes, byteStream.bytes, length);
	return retVal;
}

ByteStream ByteStreamCopy(ByteStream byteStream)
{
	ByteStream retVal = ByteStreamAlloc(byteStream.length);
	memcpy(retVal.bytes, byteStream.bytes, retVal.length);
	return retVal;
}

BOOL ByteStreamEqualToByteStream(ByteStream byteStream1, ByteStream byteStream2)
{
	if(byteStream1.bytes != byteStream2.bytes)		return NO;
	if(byteStream1.length != byteStream2.length)	return NO;
	
	return YES;
}

void ByteStreamFree(ByteStream byteStream)
{
	if(byteStream.bytes)
		free(byteStream.bytes);
}

ByteStream ByteStreamMake(Byte* bytes, NSUInteger length)
{
	ByteStream retVal;
	retVal.bytes = bytes;
	retVal.length = length;
	return retVal;
}

ByteStream ByteStreamRealloc(ByteStream byteStream, NSUInteger length)
{
	Byte* bytes = (Byte*)realloc(byteStream.bytes, length);
	if(!bytes)
		return byteStream;
	
	byteStream.bytes = bytes;
	byteStream.length = length;
	return byteStream;
}


#pragma mark - Functions (Strings)

NSString* stringFromBool(BOOL value)
{
	return (value ? TrueString : FalseString);
}

NSString* stringFromDouble(double value)
{
	return [NSString stringWithFormat:@"%f", value];
}

NSString* stringFromFloat(float value)
{
	return [NSString stringWithFormat:@"%f", value];
}

NSString* stringFromHex(unsigned int value)
{
	return [NSString stringWithFormat:@"%x", value];
}

NSString* stringFromNSInteger(NSInteger value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%ld", (long)value];
#else
	return [NSString stringWithFormat:@"%d", (int)value];
#endif
}

NSString* stringFromNSUInteger(NSUInteger value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
#else
	return [NSString stringWithFormat:@"%u", (unsigned int)value];
#endif
}

NSString* stringFromObjectPointer(id value)
{
	return [NSString stringWithFormat:@"%p", value];
}

NSString* stringFromPointer(void* value)
{
	return [NSString stringWithFormat:@"%p", value];
}

NSString* stringFromSInt8(SInt8 value)
{
	return [NSString stringWithFormat:@"%hhd", value];
}

NSString* stringFromSInt16(SInt16 value)
{
	return [NSString stringWithFormat:@"%hd", value];
}

NSString* stringFromSInt32(SInt32 value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%d", (signed int)value];
#else
	return [NSString stringWithFormat:@"%ld", (signed long)value];
#endif
}

NSString* stringFromSInt64(SInt64 value)
{
	return [NSString stringWithFormat:@"%lld", value];
}

NSString* stringFromUInt8(UInt8 value)
{
	return [NSString stringWithFormat:@"%hhu", value];
}

NSString* stringFromUInt16(UInt16 value)
{
	return [NSString stringWithFormat:@"%hu", value];
}

NSString* stringFromUInt32(UInt32 value)
{
#if __LP64__
	return [NSString stringWithFormat:@"%u", (unsigned int)value];
#else
	return [NSString stringWithFormat:@"%lu", (unsigned long)value];
#endif
}

NSString* stringFromUInt64(UInt64 value)
{
	return [NSString stringWithFormat:@"%llu", value];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

//
//  JFUtilities.h
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



#import "JFUtilities.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Constants (Animations)

NSTimeInterval const	JFAnimationDuration	= 1.0 / 3.0;


#pragma mark Constants (Colors)

UInt8 const Color8ComponentMaxValue		= 0x3;
UInt8 const Color16ComponentMaxValue	= 0xF;
UInt8 const Color32ComponentMaxValue	= 0xFF;


#pragma mark Constants (Strings)

NSString* const	JFEmptyString	= @"";
NSString* const	JFFalseString	= @"False";
NSString* const	JFNoString		= @"No";
NSString* const	JFTrueString	= @"True";
NSString* const	JFYesString		= @"Yes";

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Functions (Colors)

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


#pragma mark Functions (Images)

#if TARGET_OS_IPHONE

NSString* JFGetLaunchImageName()
{
	return JFGetLaunchImageNameForOrientation(UIStatusBarOrientation);
}

NSString* JFGetLaunchImageNameForOrientation(UIInterfaceOrientation orientation)
{
	static NSString* const NameKey				= @"UILaunchImageName";
	static NSString* const MinimumOSVersionKey	= @"UILaunchImageMinimumOSVersion";
	static NSString* const OrientationKey		= @"UILaunchImageOrientation";
	static NSString* const SizeKey				= @"UILaunchImageSize";
	
	static NSDictionary* LaunchScreens = nil;
	if(!LaunchScreens)
	{
		NSArray* dicts = JFApplicationInfoForKey(@"UILaunchImages");
		
		NSString* searchString = @"-700";
		
		NSMutableDictionary* mDicts = [NSMutableDictionary dictionaryWithCapacity:[dicts count]];
		for(NSDictionary* dict in dicts)
		{
			NSString* key = [dict objectForKey:NameKey];
			NSMutableDictionary* mDict = [dict mutableCopy];
			[mDict removeObjectForKey:NameKey];
			[mDicts setObject:[mDict copy] forKey:key];
			
			NSRange range = [key rangeOfString:searchString];
			if(range.location != NSNotFound)
			{
				key = [key stringByReplacingOccurrencesOfString:searchString withString:JFEmptyString];
				[mDict removeObjectForKey:MinimumOSVersionKey];
				[mDicts setObject:[mDict copy] forKey:key];
			}
		}
		LaunchScreens = [mDicts copy];
	}
	
	static CGSize screenSize = {0.0, 0.0};
	if(CGSizeEqualToSize(screenSize, CGSizeZero))
	{
		UIScreen* screen = UIMainScreen;
		CGRect screenBounds = (iOS8Plus ? [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace] : screen.bounds);
		screenSize = screenBounds.size;
	}
	
	static NSString* landscapeRetObj = nil;
	static NSString* portraitRetObj = nil;
	
	BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
	
	NSString* retObj = (isLandscape ? landscapeRetObj : (isPortrait ? portraitRetObj : nil));
	
	if(!retObj)
	{
		NSString* retObjVersion = nil;
		for(NSString* key in [LaunchScreens allKeys])
		{
			NSDictionary* dict = [LaunchScreens objectForKey:key];
			
			// Checks the orientation and jumps to the next if not satisfied.
			NSString* orientationString = [dict objectForKey:OrientationKey];
			if([orientationString isEqualToString:@"Portrait"])
			{
				if(isLandscape)
					continue;
			}
			else if([orientationString isEqualToString:@"Landscape"])
			{
				if(isPortrait)
					continue;
			}
			else
				continue;
			
			// Checks the size and jumps to the next if not satisfied.
			NSString* sizeString = [dict objectForKey:SizeKey];
			CGSize size = CGSizeFromString(sizeString);
			if(!CGSizeEqualToSize(size, screenSize))
				continue;
			
			// Checks the minimum iOS version and jumps to the next if not satisfied.
			NSString* minVersion = [dict objectForKey:MinimumOSVersionKey];
			if(minVersion)
			{
				if(!iOSPlus(minVersion))
					continue;
				
				// Checks if the current image minVersion is better than the last used image version.
				if(retObjVersion && [minVersion compare:retObjVersion options:NSNumericSearch] != NSOrderedDescending)
					continue;
			}
			else if(retObjVersion)
				continue;
			
			if(isLandscape)	landscapeRetObj = key;
			if(isPortrait)	portraitRetObj = key;
			
			retObj = key;
			retObjVersion = minVersion;
			
			if(iOSExact(minVersion))
				break;
		}
	}
	
	return retObj;
}

#endif


#pragma mark Functions (Info)

id JFApplicationInfoForKey(NSString* key)
{
	return [[NSMainBundle infoDictionary] objectForKey:key];
}


#pragma mark Functions (Math)

Degrees degreesFromRadians(Radians radians)
{
	return radians * 180.0 / M_PI;
}

Radians radiansFromDegress(Degrees degrees)
{
	return degrees * M_PI / 180.0;
}


#pragma mark Functions (Objects)

BOOL JFAreObjectsEqual(id obj1, id obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^validateClass)(Class) = ^BOOL(Class class)
	{
		if(![obj1 isKindOfClass:class])	return NO;
		if(![obj2 isKindOfClass:class])	return NO;
		return YES;
	};
	
	if(validateClass([NSArray class]))		return [obj1 isEqualToArray:obj2];
	if(validateClass([NSData class]))		return [obj1 isEqualToData:obj2];
	if(validateClass([NSDate class]))		return [obj1 isEqualToDate:obj2];
	if(validateClass([NSDictionary class]))	return [obj1 isEqualToDictionary:obj2];
	if(validateClass([NSNumber class]))		return [obj1 isEqualToNumber:obj2];
	if(validateClass([NSSet class]))		return [obj1 isEqualToSet:obj2];
	if(validateClass([NSString class]))		return [obj1 isEqualToString:obj2];
	
	return [obj1 isEqual:obj2];
}


#pragma mark Functions (Randomness)

NSString* JFRandomString(NSUInteger length)
{
	if(length == 0)
		return JFEmptyString;
	
	static NSString* characters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	
	NSMutableString* retObj = [NSMutableString stringWithCapacity:length];
	for(NSUInteger i = 0; i < length; i++)
	{
		NSUInteger index = arc4random_uniform((u_int32_t)[characters length]);
		[retObj appendFormat:@"%C", [characters characterAtIndex:index]];
	}
	
	return [retObj copy];
}


#pragma mark Functions (Runtime)

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


#pragma mark Functions (Streams)

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


#pragma mark Functions (Strings)

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

NSString* JFStringFromID(id value)
{
	return [NSString stringWithFormat:@"%p", value];
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

NSString* JFStringFromPointer(void* value)
{
	return [NSString stringWithFormat:@"%p", value];
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

BOOL JFStringIsEmpty(NSString* string)
{
	return (string && [string isEqualToString:JFEmptyString]);
}

BOOL JFStringIsNullOrEmpty(NSString* string)
{
	return (!string || [string isEqualToString:JFEmptyString]);
}


#pragma mark Functions (OLD)

#if TARGET_OS_IPHONE

NSString* standardXIBNameForViewController(UIViewController* viewController)
{
	NSString* retVal = nil;
	Class class = [viewController class];
	while(!retVal && class)
	{
		NSString* className = NSStringFromClass(class);
		NSRange range = [className rangeOfString:@"Controller" options:NSBackwardsSearch];
		
		NSString* path = nil;
		NSString* xibName = nil;
		if(range.location != NSNotFound)
		{
			NSString* baseName = [className stringByReplacingCharactersInRange:range withString:JFEmptyString];
			
			if(iPad)
			{
				xibName = [baseName stringByAppendingString:@"~iPad"];
				path = [NSMainBundle pathForResource:xibName ofType:@"nib"];
			}
			
			if(!path)
			{
				xibName = baseName;
				path = [NSMainBundle pathForResource:xibName ofType:@"nib"];
			}
		}
		
		if(path)
			retVal = xibName;
		else
			class = [class superclass];
	}
	return retVal;
}

BOOL isSystemVersion(NSString* version)
{
	if(!version)
		return NO;
	
	return [DeviceSystemVersion hasPrefix:version];
}

BOOL isSystemVersionExact(NSString* version)
{
	if(!version)
		return NO;
	
	return ([version compare:DeviceSystemVersion options:NSNumericSearch] == NSOrderedSame);
}

BOOL isSystemVersionPlus(NSString* version)
{
	if(!version)
		return NO;
	
	return ([version compare:DeviceSystemVersion options:NSNumericSearch] != NSOrderedDescending);
}

void setNetworkActivityIndicatorHidden(BOOL hidden)
{
	static NSUInteger counter = 0;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		counter += (hidden ? -1 : 1);
		UIApp.networkActivityIndicatorVisible = (counter > 0);
	});
}

#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

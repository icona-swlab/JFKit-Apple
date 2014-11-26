//
//  JFUtilities.m
//  Copyright (C) 2014  Jacopo Filié
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



#pragma mark - Constants (Strings)

NSString* const	EmptyString	= @"";



#pragma mark - Functions (C)

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


#pragma mark - Functions (Info)

NSString* appInfoForKey(NSString* key)
{
	return [[MainBundle infoDictionary] objectForKey:key];
}

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
			NSString* baseName = [className stringByReplacingCharactersInRange:range withString:EmptyString];
			
			if(iPad)
			{
				xibName = [baseName stringByAppendingString:@"~iPad"];
				path = [MainBundle pathForResource:xibName ofType:@"nib"];
			}
			
			if(!path)
			{
				xibName = baseName;
				path = [MainBundle pathForResource:xibName ofType:@"nib"];
			}
		}
		
		if(path)
			retVal = xibName;
		else
			class = [class superclass];
	}
	return retVal;
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


#pragma mark - Functions (System version)

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


#pragma mark - Functions (Trigonometry)

double convertDegreesToRadians(double degrees)
{
	return degrees * M_PI / 180.0;
}

double convertRadiansToDegrees(double radians)
{
	return radians * 180.0 / M_PI;
}


#pragma mark - Functions (User interface)

void setNetworkActivityIndicatorHidden(BOOL hidden)
{
	static NSUInteger counter = 0;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		counter += (hidden ? -1 : 1);
		UIApp.networkActivityIndicatorVisible = (counter > 0);
	});
}

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
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

NSString* standardXIBNameForViewController(UIViewController* viewController)
{
	NSString* className = ObjectClassString(viewController);
	NSRange range = [className rangeOfString:@"Controller" options:NSBackwardsSearch];
	return [className stringByReplacingCharactersInRange:range withString:EmptyString];
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

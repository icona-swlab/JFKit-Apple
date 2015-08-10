//
//  JFByteStream.m
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



#import "JFByteStream.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

JFByteStream const	JFByteStreamZero	= {NULL, 0};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

JFByteStream JFByteStreamAlloc(NSUInteger length)
{
	if(length == 0)
		return JFByteStreamZero;
	
	Byte* bytes = (Byte*)malloc(length * sizeof(Byte));
	
	return JFByteStreamMake(bytes, length);
}

JFByteStream JFByteStreamCCopy(JFByteStream byteStream, NSUInteger length)
{
	length = MIN(length, byteStream.length);
	if(length == 0)
		return JFByteStreamZero;
	
	JFByteStream retVal = JFByteStreamAlloc(length);
	memcpy(retVal.bytes, byteStream.bytes, length);
	return retVal;
}

JFByteStream JFByteStreamCopy(JFByteStream byteStream)
{
	JFByteStream retVal = JFByteStreamAlloc(byteStream.length);
	memcpy(retVal.bytes, byteStream.bytes, retVal.length);
	return retVal;
}

BOOL JFByteStreamEqualToByteStream(JFByteStream byteStream1, JFByteStream byteStream2)
{
	if(byteStream1.length != byteStream2.length)
		return NO;
	
	Byte* bytes1 = byteStream1.bytes;
	Byte* bytes2 = byteStream2.bytes;
	
	if(!bytes1 && !bytes2)	return YES;
	if(!bytes1 || !bytes2)	return NO;
	
	return (memcmp(bytes1, bytes2, byteStream1.length) == 0);
}

void JFByteStreamFree(JFByteStream byteStream)
{
	if(byteStream.bytes)
		free(byteStream.bytes);
}

JFByteStream JFByteStreamMake(Byte* bytes, NSUInteger length)
{
	JFByteStream retVal;
	retVal.bytes = bytes;
	retVal.length = length;
	return retVal;
}

JFByteStream JFByteStreamRealloc(JFByteStream byteStream, NSUInteger length)
{
	Byte* bytes = (Byte*)realloc(byteStream.bytes, length * sizeof(Byte));
	if(!bytes)
		return byteStream;
	
	byteStream.bytes = bytes;
	byteStream.length = length;
	return byteStream;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

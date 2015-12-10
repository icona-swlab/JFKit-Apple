//
//	The MIT License (MIT)
//
//	Copyright (c) 2015 Jacopo Filié
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
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

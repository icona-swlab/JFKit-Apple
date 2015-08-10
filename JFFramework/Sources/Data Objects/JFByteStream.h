//
//  JFByteStream.h
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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedefs

typedef struct {
	Byte*		bytes;
	NSUInteger	length;
} JFByteStream;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT JFByteStream const	JFByteStreamZero;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT JFByteStream	JFByteStreamAlloc(NSUInteger length);
FOUNDATION_EXPORT JFByteStream	JFByteStreamCCopy(JFByteStream byteStream, NSUInteger length);
FOUNDATION_EXPORT JFByteStream	JFByteStreamCopy(JFByteStream byteStream);
FOUNDATION_EXPORT BOOL			JFByteStreamEqualToByteStream(JFByteStream byteStream1, JFByteStream byteStream2);
FOUNDATION_EXPORT void			JFByteStreamFree(JFByteStream byteStream);
FOUNDATION_EXPORT JFByteStream	JFByteStreamMake(Byte* bytes, NSUInteger length);
FOUNDATION_EXPORT JFByteStream	JFByteStreamRealloc(JFByteStream byteStream, NSUInteger length);

////////////////////////////////////////////////////////////////////////////////////////////////////

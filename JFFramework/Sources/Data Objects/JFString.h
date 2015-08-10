//
//  JFString.h
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

#pragma mark - Macros

#define JFKVCPropertyName(_property)			[[JFKVCPropertyPath(_property) componentsSeparatedByString:@"."] lastObject]
#define JFKVCPropertyPath(_property)			(JFEmptyString#_property)
#define JFStringFromCString(_cStr)				JFStringFromEncodedCString(_cStr, NSUTF8StringEncoding)
#define JFStringFromEncodedCString(_cStr, _enc)	[NSString stringWithCString:_cStr encoding:_enc]
#define	JFStringFromObjectClass(_obj)			NSStringFromClass([_obj class])
#define JFStringToCString(_str)					JFStringToEncodedCString(_str, NSUTF8StringEncoding)
#define JFStringToEncodedCString(_str, _enc)	[_str cStringUsingEncoding:_enc]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT NSString* const	JFEmptyString;
FOUNDATION_EXPORT NSString* const	JFFalseString;
FOUNDATION_EXPORT NSString* const	JFNoString;
FOUNDATION_EXPORT NSString* const	JFTrueString;
FOUNDATION_EXPORT NSString* const	JFYesString;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT BOOL		JFStringIsEmpty(NSString* string);
FOUNDATION_EXPORT BOOL		JFStringIsNullOrEmpty(NSString* string);
FOUNDATION_EXPORT NSString*	JFStringMakeRandom(NSUInteger length);
FOUNDATION_EXPORT NSString*	JFStringMakeRandomWithCharacters(NSUInteger length, NSString* characters);


#pragma mark Functions (Conversions)

FOUNDATION_EXPORT NSString*	JFStringFromBool(BOOL value);
FOUNDATION_EXPORT NSString*	JFStringFromBoolean(Boolean value);
FOUNDATION_EXPORT NSString*	JFStringFromDouble(double value);
FOUNDATION_EXPORT NSString*	JFStringFromFloat(float value);
FOUNDATION_EXPORT NSString*	JFStringFromHex(unsigned int value);
FOUNDATION_EXPORT NSString*	JFStringFromID(id value);
FOUNDATION_EXPORT NSString*	JFStringFromInt(int value);
FOUNDATION_EXPORT NSString*	JFStringFromLong(long value);
FOUNDATION_EXPORT NSString*	JFStringFromLongLong(long long value);
FOUNDATION_EXPORT NSString*	JFStringFromNSInteger(NSInteger value);
FOUNDATION_EXPORT NSString*	JFStringFromNSUInteger(NSUInteger value);
FOUNDATION_EXPORT NSString*	JFStringFromPointer(void* value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt8(SInt8 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt16(SInt16 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt32(SInt32 value);
FOUNDATION_EXPORT NSString*	JFStringFromSInt64(SInt64 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt8(UInt8 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt16(UInt16 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt32(UInt32 value);
FOUNDATION_EXPORT NSString*	JFStringFromUInt64(UInt64 value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedInt(unsigned int value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLong(unsigned long value);
FOUNDATION_EXPORT NSString*	JFStringFromUnsignedLongLong(unsigned long long value);

////////////////////////////////////////////////////////////////////////////////////////////////////

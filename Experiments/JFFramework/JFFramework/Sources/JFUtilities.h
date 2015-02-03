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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros (Localization)

#define LocalizedString(arg_key, arg_defVal)							LocalizedStringWithComment(arg_key, arg_defVal, nil)
#define LocalizedStringWithComment(arg_key, arg_defVal, arg_comment)	NSLocalizedStringWithDefaultValue(arg_key, nil, NSMainBundle, arg_defVal, arg_comment)


#pragma mark - Macros (Streams)

#define ByteStreamNull	ByteStreamAlloc(0)


#pragma mark - Macros (Strings)

#define BoolToString(arg_val)							stringFromBool(arg_val)
#define CStringToString(arg_str)						CStringToStringWithEncoding(arg_str, NSUTF8StringEncoding)
#define CStringToStringWithEncoding(arg_str, arg_enc)	[NSString stringWithCString:arg_str encoding:arg_enc]
#define DoubleToString(arg_val)							stringFromDouble(arg_val)
#define FloatToString(arg_val)							stringFromFloat(arg_val)
#define HexToString(arg_val)							stringFromHex(arg_val)
#define	IsEmptyString(arg_str)							[arg_str isEqualToString:EmptyString]
#define	IsNullOrEmptyString(arg_str)					(!arg_str || IsEmptyString(arg_str))
#define NSIntegerToString(arg_val)						stringFromNSInteger(arg_val)
#define NSUIntegerToString(arg_val)						stringFromNSUInteger(arg_val)
#define	ObjectClassString(arg_obj)						NSStringFromClass([arg_obj class])
#define ObjectPointerToString(arg_val)					stringFromObjectPointer(arg_val)
#define PointerToString(arg_val)						stringFromPointer(arg_val)
#define KVCPropertyName(arg_property)					[[KVCPropertyPath(arg_property) componentsSeparatedByString:@"."] lastObject]
#define KVCPropertyPath(arg_property)					(@""#arg_property)
#define SInt8ToString(arg_val)							stringFromSInt8(arg_val)
#define SInt16ToString(arg_val)							stringFromSInt16(arg_val)
#define SInt32ToString(arg_val)							stringFromSInt32(arg_val)
#define SInt64ToString(arg_val)							stringFromSInt64(arg_val)
#define StringToCString(arg_str)						StringToCStringWithEncoding(arg_str, NSUTF8StringEncoding)
#define StringToCStringWithEncoding(arg_str, arg_enc)	[arg_str cStringUsingEncoding:arg_enc]
#define UInt8ToString(arg_val)							stringFromUInt8(arg_val)
#define UInt16ToString(arg_val)							stringFromUInt16(arg_val)
#define UInt32ToString(arg_val)							stringFromUInt32(arg_val)
#define UInt64ToString(arg_val)							stringFromUInt64(arg_val)

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedefs (Math)

typedef double	Degrees;
typedef double	Radians;


#pragma mark - Typedefs (Streams)

typedef struct {
	Byte*		bytes;
	NSUInteger	length;
} ByteStream;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants (Strings)

extern	NSString* const	EmptyString;
extern	NSString* const	FalseString;
extern	NSString* const	TrueString;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions (Math)

extern Degrees	degreesFromRadians(Radians radians);
extern Radians	radiansFromDegress(Degrees degrees);


#pragma mark - Functions (Runtime)

extern void	performSelector(NSObject* target, SEL action);
extern void performSelector1(NSObject* target, SEL action, id object);
extern void performSelector2(NSObject* target, SEL action, id obj1, id obj2);


#pragma mark - Functions (Streams)

extern ByteStream	ByteStreamAlloc(NSUInteger length);
extern ByteStream	ByteStreamCCopy(ByteStream byteStream, NSUInteger length);
extern ByteStream	ByteStreamCopy(ByteStream byteStream);
extern BOOL			ByteStreamEqualToByteStream(ByteStream byteStream1, ByteStream byteStream2);
extern void			ByteStreamFree(ByteStream byteStream);
extern ByteStream	ByteStreamMake(Byte* bytes, NSUInteger length);
extern ByteStream	ByteStreamRealloc(ByteStream byteStream, NSUInteger length);


#pragma mark - Functions (Strings)

extern NSString*	stringFromBool(BOOL value);
extern NSString*	stringFromDouble(double value);
extern NSString*	stringFromFloat(float value);
extern NSString*	stringFromHex(unsigned int value);
extern NSString*	stringFromNSInteger(NSInteger value);
extern NSString*	stringFromNSUInteger(NSUInteger value);
extern NSString*	stringFromObjectPointer(id value);
extern NSString*	stringFromPointer(void* value);
extern NSString*	stringFromSInt8(SInt8 value);
extern NSString*	stringFromSInt16(SInt16 value);
extern NSString*	stringFromSInt32(SInt32 value);
extern NSString*	stringFromSInt64(SInt64 value);
extern NSString*	stringFromUInt8(UInt8 value);
extern NSString*	stringFromUInt16(UInt16 value);
extern NSString*	stringFromUInt32(UInt32 value);
extern NSString*	stringFromUInt64(UInt64 value);

////////////////////////////////////////////////////////////////////////////////////////////////////

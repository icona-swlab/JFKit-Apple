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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Macros (Colors)

#define ColorAlpha(_val)	colorWithRGBA(0, 0, 0, _val)
#define ColorBlue(_val)		colorWithRGB(0, 0, _val)
#define ColorGray(_val)		colorWithRGB(_val, _val, _val)
#define ColorGreen(_val)	colorWithRGB(0, _val, 0)
#define ColorRed(_val)		colorWithRGB(_val, 0, 0)


#pragma mark Macros (Info)

#define AppDisplayName	appInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier	appInfoForKey(@"CFBundleIdentifier")
#define AppName			appInfoForKey(@"CFBundleName")
#define AppVersionLong	appInfoForKey(@"CFBundleVersion")
#define AppVersionShort	appInfoForKey(@"CFBundleShortVersionString")
#define	ClassName		ObjectClassString(self)
#define	LogMethod		NSLog(@"%@: executing '%@'.", ClassName, MethodName)
#define MethodName		NSStringFromSelector(_cmd)


#pragma mark Macros (Localization)

#define LocalizedString(_key, _defVal)						LocalizedStringWithComment(_key, _defVal, nil)
#define LocalizedStringWithComment(_key, _defVal, _comment)	NSLocalizedStringWithDefaultValue(_key, nil, NSMainBundle, _defVal, _comment)


#pragma mark Macros (Shortcuts)

#define NSMainBundle	[NSBundle mainBundle]


#pragma mark Macros (Streams)

#define ByteStreamNull	ByteStreamAlloc(0)


#pragma mark Macros (Strings)

#define BoolToString(_val)						stringFromBool(_val)
#define CStringToString(_str)					CStringToStringWithEncoding(_str, NSUTF8StringEncoding)
#define CStringToStringWithEncoding(_str, _enc)	[NSString stringWithCString:_str encoding:_enc]
#define DoubleToString(_val)					stringFromDouble(_val)
#define FloatToString(_val)						stringFromFloat(_val)
#define HexToString(_val)						stringFromHex(_val)
#define IDToString(_val)						stringFromID(_val)
#define IntToString(_val)						stringFromInt(_val)
#define	IsEmptyString(_str)						[_str isEqualToString:EmptyString]
#define	IsNullOrEmptyString(_str)				(!_str || IsEmptyString(_str))
#define LongToString(_val)						stringFromLong(_val)
#define LongLongToString(_val)					stringFromLongLong(_val)
#define NSIntegerToString(_val)					stringFromNSInteger(_val)
#define NSUIntegerToString(_val)				stringFromNSUInteger(_val)
#define	ObjectClassString(_obj)					NSStringFromClass([_obj class])
#define PointerToString(_val)					stringFromPointer(_val)
#define KVCPropertyName(_property)				[[KVCPropertyPath(_property) componentsSeparatedByString:@"."] lastObject]
#define KVCPropertyPath(_property)				(@""#_property)
#define SInt8ToString(_val)						stringFromSInt8(_val)
#define SInt16ToString(_val)					stringFromSInt16(_val)
#define SInt32ToString(_val)					stringFromSInt32(_val)
#define SInt64ToString(_val)					stringFromSInt64(_val)
#define StringToCString(_str)					StringToCStringWithEncoding(_str, NSUTF8StringEncoding)
#define StringToCStringWithEncoding(_str, _enc)	[_str cStringUsingEncoding:_enc]
#define UInt8ToString(_val)						stringFromUInt8(_val)
#define UInt16ToString(_val)					stringFromUInt16(_val)
#define UInt32ToString(_val)					stringFromUInt32(_val)
#define UInt64ToString(_val)					stringFromUInt64(_val)
#define UnsignedIntToString(_val)				stringFromUnsignedInt(_val)
#define UnsignedLongToString(_val)				stringFromUnsignedLong(_val)
#define UnsignedLongLongToString(_val)			stringFromUnsignedLongLong(_val)


#pragma mark Macros (OLD)

#if TARGET_OS_IPHONE
#define AreArraysEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToArray:arg_obj2])
#define AreDatesEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToDate:arg_obj2])
#define AreObjectsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqual:arg_obj2])
#define AreSetsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToSet:arg_obj2])
#define AreStringsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToString:arg_obj2])
#define NSDefaultNotificationCenter	[NSNotificationCenter defaultCenter]
#define	UIApp						[UIApplication sharedApplication]
#define	UIAppDelegate				((AppDelegate*)[UIApp delegate])
#define UIAppLanguage				[UIAppLanguages firstObject]
#define UIAppLanguages				[NSMainBundle preferredLocalizations]
#define UICurrentDevice				[UIDevice currentDevice]
#define UIIdiom						[UICurrentDevice userInterfaceIdiom]
#define UIMainScreen				[UIScreen mainScreen]
#define UIDeviceOrientation		[UICurrentDevice orientation]
#define UIStatusBarOrientation	[UIApp statusBarOrientation]
#define BundleResourceURL(arg_filename)						[NSMainBundle URLForResource:[arg_filename stringByDeletingPathExtension] withExtension:[arg_filename pathExtension]]
#define BundleResourceURLWithType(arg_filename, arg_type)	[NSMainBundle URLForResource:arg_filename withExtension:arg_type]
#define DeviceSystemVersion		UICurrentDevice.systemVersion
#define iOS(arg_version)		isSystemVersion(arg_version)
#define iOSExact(arg_version)	isSystemVersionExact(arg_version)
#define iOSPlus(arg_version)	isSystemVersionPlus(arg_version)
#define iOS6					iOS(@"6.")
#define iOS6Plus				iOSPlus(@"6.")
#define iOS7					iOS(@"7.")
#define iOS7Plus				iOSPlus(@"7.")
#define iOS8					iOS(@"8.")
#define iOS8Plus				iOSPlus(@"8.")
#define iPad					(UIIdiom == UIUserInterfaceIdiomPad)
#define iPhone					(UIIdiom == UIUserInterfaceIdiomPhone)
#define HideNetworkActivityIndicator	setNetworkActivityIndicatorHidden(YES)
#define ShowNetworkActivityIndicator	setNetworkActivityIndicatorHidden(NO)
#define StandardXIBName	standardXIBNameForViewController(self) // Class name without the word "Controller" (e.g. "UIViewController" -> "UIView").
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedef (Blocks)

typedef void	(^Block)			(void);
typedef void	(^CheckerBlock)		(BOOL success, NSError* error);
typedef void	(^CompletionBlock)	(id object, NSError* error);


#pragma mark Typedefs (Colors)

typedef struct {
	UInt8	red		: 2;
	UInt8	green	: 2;
	UInt8	blue	: 2;
	UInt8	alpha	: 2;
} Color8Components;

typedef struct {
	UInt8	red		: 4;
	UInt8	green	: 4;
	UInt8	blue	: 4;
	UInt8	alpha	: 4;
} Color16Components;

typedef struct {
	UInt8	red		: 8;
	UInt8	green	: 8;
	UInt8	blue	: 8;
	UInt8	alpha	: 8;
} Color32Components;

typedef union {
	Color8Components	components;
	UInt8				value;
} Color8;

typedef union {
	Color16Components	components;
	UInt16				value;
} Color16;

typedef union {
	Color32Components	components;
	UInt32				value;
} Color32;


#pragma mark Typedefs (Math)

typedef double	Degrees;
typedef double	Radians;


#pragma mark Typedefs (Metrics)

typedef NS_ENUM(UInt64, SIMetrics) {
	
	// Binary
	SIKibi	= 1024ULL,
	SIMebi	= SIKibi * SIKibi,
	SIGibi	= SIMebi * SIKibi,
	SITebi	= SIGibi * SIKibi,
	
	// Decimal
	SIKilo	= 1000ULL,
	SIMega	= SIKilo * SIKilo,
	SIGiga	= SIMega * SIKilo,
	SITera	= SIGiga * SIKilo,
};


#pragma mark Typedefs (Streams)

typedef struct {
	Byte*		bytes;
	NSUInteger	length;
} ByteStream;


#pragma mark Typedefs (OLD)

#if TARGET_OS_IPHONE
typedef void	(^BlockWithBool)			(BOOL value);
typedef void	(^BlockWithError)			(NSError* error);
typedef void	(^BlockWithObject)			(id object);
typedef void	(^BlockWithObjectAndError)	(id object, NSError* error);
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Constants (Colors)

extern UInt8 const Color8ComponentMaxValue;
extern UInt8 const Color16ComponentMaxValue;
extern UInt8 const Color32ComponentMaxValue;


#pragma mark Constants (Strings)

extern	NSString* const	EmptyString;
extern	NSString* const	FalseString;
extern	NSString* const	TrueString;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Functions (Colors)

#if TARGET_OS_IPHONE
extern UIColor*	colorWithComponents(Color32Components components);
extern UIColor*	colorWithHex(UInt32 value);
extern UIColor*	colorWithRGB(UInt8 r, UInt8 g, UInt8 b);
extern UIColor*	colorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a);
#else
extern NSColor*	colorWithComponents(Color32Components components);
extern NSColor*	colorWithHex(UInt32 value);
extern NSColor*	colorWithRGB(UInt8 r, UInt8 g, UInt8 b);
extern NSColor*	colorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a);
#endif


#pragma mark Functions (Info)

extern NSString*	appInfoForKey(NSString* key);


#pragma mark Functions (Math)

extern Degrees	degreesFromRadians(Radians radians);
extern Radians	radiansFromDegress(Degrees degrees);


#pragma mark Functions (Runtime)

extern void	performSelector(NSObject* target, SEL action);
extern void performSelector1(NSObject* target, SEL action, id object);
extern void performSelector2(NSObject* target, SEL action, id obj1, id obj2);


#pragma mark Functions (Streams)

extern ByteStream	ByteStreamAlloc(NSUInteger length);
extern ByteStream	ByteStreamCCopy(ByteStream byteStream, NSUInteger length);
extern ByteStream	ByteStreamCopy(ByteStream byteStream);
extern BOOL			ByteStreamEqualToByteStream(ByteStream byteStream1, ByteStream byteStream2);
extern void			ByteStreamFree(ByteStream byteStream);
extern ByteStream	ByteStreamMake(Byte* bytes, NSUInteger length);
extern ByteStream	ByteStreamRealloc(ByteStream byteStream, NSUInteger length);


#pragma mark Functions (Strings)

extern NSString*	stringFromBool(BOOL value);
extern NSString*	stringFromDouble(double value);
extern NSString*	stringFromFloat(float value);
extern NSString*	stringFromHex(unsigned int value);
extern NSString*	stringFromID(id value);
extern NSString*	stringFromInt(int value);
extern NSString*	stringFromLong(long value);
extern NSString*	stringFromLongLong(long long value);
extern NSString*	stringFromNSInteger(NSInteger value);
extern NSString*	stringFromNSUInteger(NSUInteger value);
extern NSString*	stringFromPointer(void* value);
extern NSString*	stringFromSInt8(SInt8 value);
extern NSString*	stringFromSInt16(SInt16 value);
extern NSString*	stringFromSInt32(SInt32 value);
extern NSString*	stringFromSInt64(SInt64 value);
extern NSString*	stringFromUInt8(UInt8 value);
extern NSString*	stringFromUInt16(UInt16 value);
extern NSString*	stringFromUInt32(UInt32 value);
extern NSString*	stringFromUInt64(UInt64 value);
extern NSString*	stringFromUnsignedInt(unsigned int value);
extern NSString*	stringFromUnsignedLong(unsigned long value);
extern NSString*	stringFromUnsignedLongLong(unsigned long long value);


#pragma mark Functions (OLD)

#if TARGET_OS_IPHONE
extern NSString*	standardXIBNameForViewController(UIViewController* viewController);
extern BOOL	isSystemVersion(NSString* version);
extern BOOL	isSystemVersionExact(NSString* version);
extern BOOL	isSystemVersionPlus(NSString* version);
extern void	setNetworkActivityIndicatorHidden(BOOL hidden);
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

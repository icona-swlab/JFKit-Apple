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

#define AppDisplayName	JFApplicationInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier	JFApplicationInfoForKey(@"CFBundleIdentifier")
#define AppName			JFApplicationInfoForKey(@"CFBundleName")
#define AppVersionLong	JFApplicationInfoForKey(@"CFBundleVersion")
#define AppVersionShort	JFApplicationInfoForKey(@"CFBundleShortVersionString")
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

#define BoolToString(_val)						JFStringFromBool(_val)
#define CStringToString(_str)					CStringToStringWithEncoding(_str, NSUTF8StringEncoding)
#define CStringToStringWithEncoding(_str, _enc)	[NSString stringWithCString:_str encoding:_enc]
#define DoubleToString(_val)					JFStringFromDouble(_val)
#define FloatToString(_val)						JFStringFromFloat(_val)
#define HexToString(_val)						JFStringFromHex(_val)
#define IDToString(_val)						JFStringFromID(_val)
#define IntToString(_val)						JFStringFromInt(_val)
#define	IsEmptyString(_str)						[_str isEqualToString:EmptyString]
#define	IsNullOrEmptyString(_str)				(!_str || IsEmptyString(_str))
#define LongToString(_val)						JFStringFromLong(_val)
#define LongLongToString(_val)					JFStringFromLongLong(_val)
#define NSIntegerToString(_val)					JFStringFromNSInteger(_val)
#define NSUIntegerToString(_val)				JFStringFromNSUInteger(_val)
#define	ObjectClassString(_obj)					NSStringFromClass([_obj class])
#define PointerToString(_val)					JFStringFromPointer(_val)
#define KVCPropertyName(_property)				[[KVCPropertyPath(_property) componentsSeparatedByString:@"."] lastObject]
#define KVCPropertyPath(_property)				(@""#_property)
#define SInt8ToString(_val)						JFStringFromSInt8(_val)
#define SInt16ToString(_val)					JFStringFromSInt16(_val)
#define SInt32ToString(_val)					JFStringFromSInt32(_val)
#define SInt64ToString(_val)					JFStringFromSInt64(_val)
#define StringToCString(_str)					StringToCStringWithEncoding(_str, NSUTF8StringEncoding)
#define StringToCStringWithEncoding(_str, _enc)	[_str cStringUsingEncoding:_enc]
#define UInt8ToString(_val)						JFStringFromUInt8(_val)
#define UInt16ToString(_val)					JFStringFromUInt16(_val)
#define UInt32ToString(_val)					JFStringFromUInt32(_val)
#define UInt64ToString(_val)					JFStringFromUInt64(_val)
#define UnsignedIntToString(_val)				JFStringFromUnsignedInt(_val)
#define UnsignedLongToString(_val)				JFStringFromUnsignedLong(_val)
#define UnsignedLongLongToString(_val)			JFStringFromUnsignedLongLong(_val)


#pragma mark Macros (OLD)

#if TARGET_OS_IPHONE
#define NSMainOperationQueue		[NSOperationQueue mainQueue]
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

typedef void	(^JFBlock)					(void);
typedef void	(^JFBlockWithArray)			(NSArray* array);
typedef void	(^JFBlockWithBOOL)			(BOOL value);
typedef void	(^JFBlockWithDictionary)	(NSDictionary* dictionary);
typedef void	(^JFBlockWithError)			(NSError* error);
typedef void	(^JFBlockWithInteger)		(NSInteger value);
typedef void	(^JFBlockWithNotification)	(NSNotification* notification);
typedef void	(^JFBlockWithObject)		(id object);
typedef void	(^JFBlockWithSet)			(NSSet* set);
typedef void	(^JFCompletionBlock)		(BOOL succeded, id object, NSError* error);
typedef void	(^JFSimpleCompletionBlock)	(BOOL succeded, NSError* error);


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

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Constants (Animations)

extern NSTimeInterval const	JFAnimationDuration;


#pragma mark Constants (Colors)

extern UInt8 const Color8ComponentMaxValue;
extern UInt8 const Color16ComponentMaxValue;
extern UInt8 const Color32ComponentMaxValue;


#pragma mark Constants (Strings)

extern NSString* const	EmptyString;
extern NSString* const	FalseString;
extern NSString* const	TrueString;

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

extern NSString*	JFApplicationInfoForKey(NSString* key);


#pragma mark Functions (Math)

extern Degrees	degreesFromRadians(Radians radians);
extern Radians	radiansFromDegress(Degrees degrees);


#pragma mark Functions (Objects)

extern BOOL	JFAreObjectsEqual(id obj1, id obj2);


#pragma mark Functions (Randomness)

extern NSString*	JFRandomString(NSUInteger length);


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

extern NSString*	JFStringFromBool(BOOL value);
extern NSString*	JFStringFromDouble(double value);
extern NSString*	JFStringFromFloat(float value);
extern NSString*	JFStringFromHex(unsigned int value);
extern NSString*	JFStringFromID(id value);
extern NSString*	JFStringFromInt(int value);
extern NSString*	JFStringFromLong(long value);
extern NSString*	JFStringFromLongLong(long long value);
extern NSString*	JFStringFromNSInteger(NSInteger value);
extern NSString*	JFStringFromNSUInteger(NSUInteger value);
extern NSString*	JFStringFromPointer(void* value);
extern NSString*	JFStringFromSInt8(SInt8 value);
extern NSString*	JFStringFromSInt16(SInt16 value);
extern NSString*	JFStringFromSInt32(SInt32 value);
extern NSString*	JFStringFromSInt64(SInt64 value);
extern NSString*	JFStringFromUInt8(UInt8 value);
extern NSString*	JFStringFromUInt16(UInt16 value);
extern NSString*	JFStringFromUInt32(UInt32 value);
extern NSString*	JFStringFromUInt64(UInt64 value);
extern NSString*	JFStringFromUnsignedInt(unsigned int value);
extern NSString*	JFStringFromUnsignedLong(unsigned long value);
extern NSString*	JFStringFromUnsignedLongLong(unsigned long long value);


#pragma mark Functions (OLD)

#if TARGET_OS_IPHONE
extern NSString*	standardXIBNameForViewController(UIViewController* viewController);
extern BOOL	isSystemVersion(NSString* version);
extern BOOL	isSystemVersionExact(NSString* version);
extern BOOL	isSystemVersionPlus(NSString* version);
extern void	setNetworkActivityIndicatorHidden(BOOL hidden);
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

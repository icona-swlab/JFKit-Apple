//
//  JFUtilities.h
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



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#pragma mark - Macros (C)

#define ByteStreamNull	ByteStreamAlloc(0)


#pragma mark - Macros (Colors)

#define ColorAlpha(arg_val)							ColorWithRGBA(0.0f, 0.0f, 0.0f, arg_val)
#define ColorBlue(arg_val)							ColorWithRGB(0.0f, 0.0f, arg_val)
#define ColorGray(arg_val)							ColorWithRGB(arg_val, arg_val, arg_val)
#define ColorGreen(arg_val)							ColorWithRGB(0.0f, arg_val, 0.0f)
#define ColorRed(arg_val)							ColorWithRGB(arg_val, 0.0f, 0.0f)
#define ColorWithHex(arg_val)						ColorWithHexA(arg_val, 255.0f)
#define ColorWithHexA(arg_val, arg_a)				ColorWithRGBA(((arg_val & 0xFF0000) >> 16), ((arg_val & 0xFF00) >> 8), (arg_val & 0xFF), arg_a)
#define ColorWithRGB(arg_r, arg_g, arg_b)			ColorWithRGBA(arg_r, arg_g, arg_b, 255.0f)
#define ColorWithRGBA(arg_r, arg_g, arg_b, arg_a)	[UIColor colorWithRed:(((float)arg_r)/255.0f) green:(((float)arg_g)/255.0f) blue:(((float)arg_b)/255.0f) alpha:(((float)arg_a)/255.0f)]


#pragma mark - Macros (Debug)

#define	LogMethod	NSLog(@"%@: executing '%@'.", ClassName, MethodName)


#pragma mark - Macros (Equality)

#define AreDatesEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToDate:arg_obj2])
#define AreObjectsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqual:arg_obj2])
#define AreSetsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToSet:arg_obj2])
#define AreStringsEqual(arg_obj1, arg_obj2)	((!arg_obj1 && !arg_obj2) || [arg_obj1 isEqualToString:arg_obj2])


#pragma mark - Macros (Info)

#define AppDisplayName	appInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier	appInfoForKey(@"CFBundleIdentifier")
#define AppName			appInfoForKey(@"CFBundleName")
#define AppVersionLong	appInfoForKey(@"CFBundleVersion")
#define AppVersionShort	appInfoForKey(@"CFBundleShortVersionString")
#define	ClassName		ObjectClassString(self)
#define MethodName		NSStringFromSelector(_cmd)
#define StandardXIBName	standardXIBNameForViewController(self) // Class name without the word "Controller" (e.g. "UIViewController" -> "UIView").


#pragma mark - Macros (Localization)

#define LocalizedString(arg_key, arg_defVal)							LocalizedStringWithComment(arg_key, arg_defVal, nil)
#define LocalizedStringWithComment(arg_key, arg_defVal, arg_comment)	NSLocalizedStringWithDefaultValue(arg_key, nil, [NSBundle mainBundle], arg_defVal, arg_comment)


#pragma mark - Macros (Resources)

#define BundleResourceURL(arg_filename)	[[NSBundle mainBundle] URLForResource:[arg_filename stringByDeletingPathExtension] withExtension:[arg_filename pathExtension]]


#pragma mark - Macros (Shortcuts)

#define	UIApp			[UIApplication sharedApplication]
#define	UIAppDelegate	((AppDelegate*)[UIApp delegate])


#pragma mark - Macros (Strings)

#define BoolToString(arg_val)							(arg_val ? @"YES" : @"NO")
#define CStringToString(arg_str)						CStringToStringWithEncoding(arg_str, NSUTF8StringEncoding)
#define CStringToStringWithEncoding(arg_str, arg_enc)	[NSString stringWithCString:arg_str encoding:arg_enc]
#define DoubleToString(arg_val)							[NSString stringWithFormat:@"%f", (double)arg_val]
#define FloatToString(arg_val)							[NSString stringWithFormat:@"%f", (float)arg_val]
#define HexToString(arg_val)							[NSString stringWithFormat:@"%x", (unsigned int)arg_val]
#define	IsEmptyString(arg_str)							[arg_str isEqualToString:EmptyString]
#define	IsNullOrEmptyString(arg_str)					(!arg_str || IsEmptyString(arg_str))
#if __LP64__
#define NSIntegerToString(arg_val)						SInt64ToString(arg_val)
#define NSUIntegerToString(arg_val)						UInt64ToString(arg_val)
#else
#define NSIntegerToString(arg_val)						SInt32ToString(arg_val)
#define NSUIntegerToString(arg_val)						UInt32ToString(arg_val)
#endif
#define	ObjectClassString(arg_obj)						NSStringFromClass([arg_obj class])
#define PointerToString(arg_val)						[NSString stringWithFormat:@"%p", (id)arg_val]
#define SInt8ToString(arg_val)							[NSString stringWithFormat:@"%hhd", (char)arg_val]
#define SInt16ToString(arg_val)							[NSString stringWithFormat:@"%hd", (short)arg_val]
#define SInt32ToString(arg_val)							[NSString stringWithFormat:@"%d", (int)arg_val]
#define SInt64ToString(arg_val)							[NSString stringWithFormat:@"%lld", (long long)arg_val]
#define StringToCString(arg_str)						StringToCStringWithEncoding(arg_str, NSUTF8StringEncoding)
#define StringToCStringWithEncoding(arg_str, arg_enc)	[arg_str cStringUsingEncoding:arg_enc]
#define UInt8ToString(arg_val)							[NSString stringWithFormat:@"%hhu", (unsigned char)arg_val]
#define UInt16ToString(arg_val)							[NSString stringWithFormat:@"%hu", (unsigned short)arg_val]
#define UInt32ToString(arg_val)							[NSString stringWithFormat:@"%u", (unsigned int)arg_val]
#define UInt64ToString(arg_val)							[NSString stringWithFormat:@"%llu", (unsigned long long)arg_val]


#pragma mark - Macros (System version)
#define DeviceSystemVersion	[UIDevice currentDevice].systemVersion
#define iOS(arg_version)	[DeviceSystemVersion hasPrefix:arg_version]
#define iOS6				iOS(@"6.")
#define iOS7				iOS(@"7.")
#define iOS8				iOS(@"8.")
#define iPad				([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define iPhone				([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define iPhoneC				(iPhone && ([UIScreen mainScreen].bounds.size.height == 480.0f)) // iPhone with 3.5'' display.
#define iPhone5				(iPhone && ([UIScreen mainScreen].bounds.size.height == 568.0f)) // iPhone with 4'' display.


#pragma mark - Macros (User interface)

#define HideNetworkActivityIndicator	setNetworkActivityIndicatorHidden(YES)
#define ShowNetworkActivityIndicator	setNetworkActivityIndicatorHidden(NO)


#pragma mark - Typedef (Blocks)

typedef void (^Block)(void);
typedef void (^BlockWithBool)(BOOL value);
typedef void (^BlockWithError)(NSError* error);
typedef void (^BlockWithObject)(id object);
typedef void (^BlockWithObjectAndError)(id object, NSError* error);


#pragma mark - Typedef (C)

typedef struct {
	Byte*		bytes;
	NSUInteger	length;
} ByteStream;


#pragma mark - Constants (Strings)

extern	NSString* const	EmptyString;


#pragma mark - Functions (C)

extern ByteStream	ByteStreamAlloc(NSUInteger length);
extern ByteStream	ByteStreamCCopy(ByteStream byteStream, NSUInteger length);
extern ByteStream	ByteStreamCopy(ByteStream byteStream);
extern BOOL			ByteStreamEqualToByteStream(ByteStream byteStream1, ByteStream byteStream2);
extern void			ByteStreamFree(ByteStream byteStream);
extern ByteStream	ByteStreamMake(Byte* bytes, NSUInteger length);
extern ByteStream	ByteStreamRealloc(ByteStream byteStream, NSUInteger length);


#pragma mark - Functions (Info)

extern NSString* appInfoForKey(NSString* key);
extern NSString* standardXIBNameForViewController(UIViewController* viewController);


#pragma mark - Functions (User interface)

extern void setNetworkActivityIndicatorHidden(BOOL hidden);

//
//  JFUtilities.h
//
//  Created by Jacopo Filié on 25/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#pragma mark - Macros (Debug)

#define	LogMethod	NSLog(@"%@: executing '%@'.", ClassName, MethodName)


#pragma mark - Macros (Info)

#define AppDisplayName	appInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier	appInfoForKey(@"CFBundleIdentifier")
#define AppName			appInfoForKey(@"CFBundleName")
#define AppVersionLong	appInfoForKey(@"CFBundleVersion")
#define AppVersionShort	appInfoForKey(@"CFBundleShortVersionString")
#define	ClassName		ObjectClassString(self)
#define	MethodName		NSStringFromSelector(_cmd)


#pragma mark - Macros (Shortcuts)

#define	UIApp			[UIApplication sharedApplication]
#define	UIAppDelegate	((AppDelegate*)[UIApp delegate])


#pragma mark - Macros (Strings)

#define BoolToString(arg_val)			((arg_val) ? @"YES" : @"NO")
#define DoubleToString(arg_val)			[NSString stringWithFormat:@"%f", (double)(arg_val)]
#define FloatToString(arg_val)			[NSString stringWithFormat:@"%f", (float)(arg_val)]
#define HexToString(arg_val)			[NSString stringWithFormat:@"%x", (unsigned int)(arg_val)]
#define	IsEmptyString(arg_str)			[(arg_str) isEqualToString:EmptyString]
#define	IsNullOrEmptyString(arg_str)	(!(arg_str) || IsEmptyString(arg_str))
#define NSIntegerToString(arg_val)		SInt32ToString(arg_val)
#define NSUIntegerToString(arg_val)		UInt32ToString(arg_val)
#define	ObjectClassString(arg_obj)		NSStringFromClass([(arg_obj) class])
#define PointerToString(arg_val)		[NSString stringWithFormat:@"%p", (id)(arg_val)]
#define SIntToString(arg_val)			[NSString stringWithFormat:@"%d", (int)(arg_val)]
#define SInt8ToString(arg_val)			[NSString stringWithFormat:@"%hhd", (char)(arg_val)]
#define SInt16ToString(arg_val)			[NSString stringWithFormat:@"%hd", (short)(arg_val)]
#define SInt32ToString(arg_val)			[NSString stringWithFormat:@"%ld", (long)(arg_val)]
#define SInt64ToString(arg_val)			[NSString stringWithFormat:@"%lld", (long long)(arg_val)]
#define UIntToString(arg_val)			[NSString stringWithFormat:@"%u", (unsigned int)(arg_val)]
#define UInt8ToString(arg_val)			[NSString stringWithFormat:@"%hhu", (unsigned char)(arg_val)]
#define UInt16ToString(arg_val)			[NSString stringWithFormat:@"%hu", (unsigned short)(arg_val)]
#define UInt32ToString(arg_val)			[NSString stringWithFormat:@"%lu", (unsigned long)(arg_val)]
#define UInt64ToString(arg_val)			[NSString stringWithFormat:@"%llu", (unsigned long long)(arg_val)]


#pragma mark - Macros (User interface)

#define HideNetworkActivityIndicator	setNetworkActivityIndicatorHidden(YES)
#define ShowNetworkActivityIndicator	setNetworkActivityIndicatorHidden(NO)


#pragma mark - Constants (Strings)

extern	NSString* const	EmptyString;


#pragma mark - Functions (Info)

extern NSString* appInfoForKey(NSString* key);


#pragma mark - Functions (User interface)

extern void setNetworkActivityIndicatorHidden(BOOL hidden);

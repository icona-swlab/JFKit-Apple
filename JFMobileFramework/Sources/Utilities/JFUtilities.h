//
//  JFUtilities.h
//
//  Created by Jacopo Filié on 25/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>



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


#pragma mark - Macros (Strings)

#define	IsEmptyString(arg_str)			[(arg_str) isEqualToString:EmptyString]
#define	IsNullOrEmptyString(arg_str)	(!(arg_str) || IsEmptyString(arg_str))
#define	ObjectClassString(arg_obj)		NSStringFromClass([(arg_obj) class])


#pragma mark - Functions (Info)

extern NSString* appInfoForKey(NSString* key);
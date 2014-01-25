//
//  JFUtilities.h
//
//  Created by Jacopo Filié on 25/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>



#pragma mark - Macro (Info)

#define	SelfClassString	ObjectClassString(self)


#pragma mark - Macro (Strings)

#define	IsEmptyString(arg_str)			[(arg_str) isEqualToString:EmptyString]
#define	IsNullOrEmptyString(arg_str)	(!(arg_str) || IsEmptyString(arg_str))
#define	ObjectClassString(arg_obj)		NSStringFromClass([(arg_obj) class])

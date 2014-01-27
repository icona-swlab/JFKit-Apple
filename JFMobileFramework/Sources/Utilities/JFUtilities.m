//
//  JFUtilities.m
//
//  Created by Jacopo Filié on 25/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFUtilities.h"



#pragma mark - Functions (Info)

NSString* appInfoForKey(NSString* key)
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}
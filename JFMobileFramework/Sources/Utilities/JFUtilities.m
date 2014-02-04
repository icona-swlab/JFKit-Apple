//
//  JFUtilities.m
//
//  Created by Jacopo Filié on 25/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFUtilities.h"



#pragma mark - Constants (Strings)

NSString* const	EmptyString	= @"";


#pragma mark - Functions (Info)

NSString* appInfoForKey(NSString* key)
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}


#pragma mark - Functions (User interface)

void setNetworkActivityIndicatorHidden(BOOL hidden)
{
	static NSUInteger counter = 0;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		counter += (hidden ? -1 : 1);
		UIApp.networkActivityIndicatorVisible = (counter > 0);
	});
}

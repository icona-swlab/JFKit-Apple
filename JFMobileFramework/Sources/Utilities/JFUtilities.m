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

NSString* standardXIBNameForViewController(UIViewController* viewController)
{
	NSString* className = ObjectClassString(viewController);
	NSRange range = [className rangeOfString:@"Controller" options:NSBackwardsSearch];
	return [className stringByReplacingCharactersInRange:range withString:EmptyString];
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

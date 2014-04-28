//
//  JFUtilities.m
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

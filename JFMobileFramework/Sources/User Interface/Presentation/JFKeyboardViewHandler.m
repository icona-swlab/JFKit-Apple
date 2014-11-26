//
//  JFKeyboardViewHandler.m
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



#import "JFKeyboardViewHandler.h"



@interface JFKeyboardViewHandler ()

// Notifications management (UIKeyboard)
- (void)	notifiedThatKeyboardWillHide:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillShow:(NSNotification*)notification;

@end



@implementation JFKeyboardViewHandler

#pragma mark - Properties

// Attributes
@synthesize constant	= _constant;

// Constraints
@synthesize resizableViewBottomConstraint	= _resizableViewBottomConstraint;

// User interface
@synthesize resizableView	= _resizableView;


#pragma mark - Memory management

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_constant = 0.0f;
		
		// Begins to listen for interesting notifications.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedThatKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedThatKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}


#pragma mark - Notifications management (UIKeyboard)

- (void)notifiedThatKeyboardWillHide:(NSNotification*)notification
{
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (curve << 16));
	
	self.resizableViewBottomConstraint.constant = self.constant;
	[self.resizableView.superview setNeedsUpdateConstraints];
	
	Block animations = ^()
	{
		[self.resizableView.superview layoutIfNeeded];
	};
	
	[UIView animateWithDuration:duration delay:0.0 options:options animations:animations completion:nil];
}

- (void)notifiedThatKeyboardWillShow:(NSNotification*)notification
{
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect keyboardFrameEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (curve << 16));
	
	self.resizableViewBottomConstraint.constant = self.constant + CGRectGetHeight(keyboardFrameEnd);
	[self.resizableView.superview setNeedsUpdateConstraints];
	
	Block animations = ^()
	{
		[self.resizableView.superview layoutIfNeeded];
	};
	
	[UIView animateWithDuration:duration delay:0.0 options:options animations:animations completion:nil];
}

@end

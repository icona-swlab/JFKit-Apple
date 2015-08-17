//
//  JFKeyboardEventsHandler.m
//  Copyright (C) 2015  Jacopo Filié
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



#import "JFKeyboardEventsHandler.h"

#import "JFUtilities.h"



@interface JFKeyboardEventsHandler ()

#pragma mark Methods

// Notifications management (UIKeyboard)
- (void)	notifiedThatKeyboardDidChangeFrame:(NSNotification*)notification;
- (void)	notifiedThatKeyboardDidHide:(NSNotification*)notification;
- (void)	notifiedThatKeyboardDidShow:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillChangeFrame:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillHide:(NSNotification*)notification;
- (void)	notifiedThatKeyboardWillShow:(NSNotification*)notification;

// Utilities management
- (JFKeyboardInfo*)	createInfoFromDictionary:(NSDictionary*)dictionary;

@end



#pragma mark



@implementation JFKeyboardEventsHandler

#pragma mark Properties

// Attributes
@synthesize constant	= _constant;

// Constraints
@synthesize resizableViewBottomConstraint	= _resizableViewBottomConstraint;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize resizableView	= _resizableView;


#pragma mark Memory management

- (void)dealloc
{
	[NSDefaultNotificationCenter removeObserver:self];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_constant = 0.0f;
		
		// Begins to listen for interesting notifications.
		NSNotificationCenter* center = NSDefaultNotificationCenter;
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[center addObserver:self selector:@selector(notifiedThatKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}


#pragma mark Notifications management (UIKeyboard)

- (void)notifiedThatKeyboardDidChangeFrame:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didChangeFrame:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didChangeFrame:info];
	}
}

- (void)notifiedThatKeyboardDidHide:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didHide:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didHide:info];
	}
}

- (void)notifiedThatKeyboardDidShow:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:didShow:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self didShow:info];
	}
}

- (void)notifiedThatKeyboardWillChangeFrame:(NSNotification*)notification
{
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willChangeFrame:)])
	{
		JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
		[delegate keyboardEventsHandler:self willChangeFrame:info];
	}
}

- (void)notifiedThatKeyboardWillHide:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
	
	if(self.resizableView && self.resizableViewBottomConstraint)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (info.animationCurve << 16));
		
		self.resizableViewBottomConstraint.constant = 0;
		[self.resizableView.superview setNeedsUpdateConstraints];
		
		JFBlock animations = ^()
		{
			[self.resizableView.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willHide:)])
		[delegate keyboardEventsHandler:self willHide:info];
}

- (void)notifiedThatKeyboardWillShow:(NSNotification*)notification
{
	JFKeyboardInfo* info = [self createInfoFromDictionary:notification.userInfo];
	
	if(self.resizableView && self.resizableViewBottomConstraint)
	{
		UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | (info.animationCurve << 16));
		
		CGFloat height = ((!iOS8Plus && UIInterfaceOrientationIsLandscape(UIStatusBarOrientation)) ? CGRectGetWidth(info.endingFrame) : CGRectGetHeight(info.endingFrame));
		
		self.resizableViewBottomConstraint.constant = height - self.constant;
		[self.resizableView.superview setNeedsUpdateConstraints];
		
		JFBlock animations = ^()
		{
			[self.resizableView.superview layoutIfNeeded];
		};
		
		[UIView animateWithDuration:info.animationDuration delay:0.0 options:options animations:animations completion:nil];
	}
	
	id<JFKeyboardEventsHandlerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(keyboardEventsHandler:willShow:)])
		[delegate keyboardEventsHandler:self willShow:info];
}


#pragma mark Utilities management

- (JFKeyboardInfo*)createInfoFromDictionary:(NSDictionary*)dictionary
{
	NSNumber* animationCurve	= [dictionary objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	NSNumber* animationDuration	= [dictionary objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSValue* beginningFrame		= [dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey];
	NSValue* endingFrame		= [dictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
	
	JFKeyboardInfo* retObj = [[JFKeyboardInfo alloc] init];
	
	retObj.animationCurve		= [animationCurve unsignedIntegerValue];
	retObj.animationDuration	= [animationDuration doubleValue];
	retObj.beginningFrame		= [beginningFrame CGRectValue];
	retObj.endingFrame			= [endingFrame CGRectValue];
	
	return retObj;
}

@end



#pragma mark



@implementation JFKeyboardInfo

#pragma mark Properties

// Attributes
@synthesize animationCurve		= _animationCurve;
@synthesize animationDuration	= _animationDuration;
@synthesize beginningFrame		= _beginningFrame;
@synthesize endingFrame			= _endingFrame;


#pragma mark Protocol implementation (NSCopying)

- (id)copyWithZone:(NSZone*)zone
{
	typeof(self) retObj = [[[self class] alloc] init];
	
	// Attributes
	retObj->_animationCurve		= _animationCurve;
	retObj->_animationDuration	= _animationDuration;
	retObj->_beginningFrame		= _beginningFrame;
	retObj->_endingFrame		= _endingFrame;
	
	return retObj;
}

@end

//
//  JFAlert.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFAlert.h"



@interface JFAlert () <UIActionSheetDelegate, UIAlertViewDelegate>

#pragma mark Properties

// Blocks
@property (copy, nonatomic)	Block	dismissCompletion;
@property (copy, nonatomic)	Block	presentCompletion;

// Flags
@property (assign, nonatomic, readwrite)	BOOL	isVisible;

// User interface
@property (strong, nonatomic)	UIActionSheet*	actionSheet;
@property (strong, nonatomic)	UIAlertView*	alertView;
@property (strong, nonatomic)	NSArray*		currentButtons;


#pragma mark Methods

// User interface management
- (BOOL)	prepareActionSheet:(Block)completion;
- (BOOL)	prepareAlertView:(Block)completion;

// User interface management (Alerts handling)
- (void)	alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)	alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)	alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)	didPresentAlert:(id)alert;
- (void)	willPresentAlert:(id)alert;

// Notifications management
- (void)	notifyDidDismissWithButton:(JFAlertButton*)button;
- (void)	notifyDidPresent;
- (void)	notifyWillDismissWithButton:(JFAlertButton*)button;
- (void)	notifyWillPresent;

@end



#pragma mark



@implementation JFAlert

#pragma mark Properties

// Blocks
@synthesize dismissCompletion	= _dismissCompletion;
@synthesize presentCompletion	= _presentCompletion;

// Data
@synthesize message	= _message;
@synthesize title	= _title;

// Flags
@synthesize isVisible	= _isVisible;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize actionSheet			= _actionSheet;
@synthesize alertView			= _alertView;
@synthesize cancelButton		= _cancelButton;
@synthesize destructiveButton	= _destructiveButton;
@synthesize currentButtons		= _currentButtons;
@synthesize otherButtons		= _otherButtons;


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Flags
		_isVisible = NO;
	}
	return self;
}


#pragma mark User interface management

- (BOOL)dismiss:(Block)completion
{
	if(!self.isVisible || (!self.actionSheet && !self.alertView))
		return NO;
	
	self.dismissCompletion = completion;
	
	if(self.actionSheet)	[self.actionSheet dismissWithClickedButtonIndex:[self.actionSheet cancelButtonIndex] animated:YES];
	else if(self.alertView)	[self.alertView dismissWithClickedButtonIndex:[self.alertView cancelButtonIndex] animated:YES];
	
	return YES;
}

- (BOOL)dismissWithClickedButton:(JFAlertButton*)button completion:(Block)completion
{
	if(!self.isVisible || (!self.actionSheet && !self.alertView))
		return NO;
	
	NSArray* buttons = self.currentButtons;
	
	if(![buttons containsObject:button])
		return NO;
	
	self.dismissCompletion = completion;
	
	NSInteger index = [buttons indexOfObject:button];
	
	if(self.actionSheet)	[self.actionSheet dismissWithClickedButtonIndex:index animated:YES];
	else if(self.alertView)	[self.alertView dismissWithClickedButtonIndex:index animated:YES];
	
	return YES;
}

- (BOOL)prepareActionSheet:(Block)completion
{
	if(self.isVisible || self.actionSheet || self.alertView)
		return NO;
	
	JFAlertButton* cancelButton = self.cancelButton;
	JFAlertButton* destructiveButton = self.destructiveButton;
	NSArray* otherButtons = self.otherButtons;
	
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:([otherButtons count] + 2)];
	if(destructiveButton)	[buttons addObject:destructiveButton];
	if(cancelButton)		[buttons addObject:cancelButton];
	if(otherButtons)		[buttons addObjectsFromArray:otherButtons];
	
	if([buttons count] == 0)
		return NO;
	
	self.presentCompletion = completion;
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:cancelButton.title destructiveButtonTitle:destructiveButton.title otherButtonTitles:nil];
	
	for(NSUInteger i = 0; i < [otherButtons count]; i++)
	{
		JFAlertButton* button = [otherButtons objectAtIndex:i];
		[actionSheet addButtonWithTitle:button.title];
	}
	
	self.actionSheet = actionSheet;
	self.currentButtons = [buttons copy];
	
	return YES;
}

- (BOOL)prepareAlertView:(Block)completion
{
	if(self.isVisible || self.actionSheet || self.alertView)
		return NO;
	
	JFAlertButton* cancelButton = self.cancelButton;
	if(!cancelButton)
		return NO;
	
	NSArray* otherButtons = self.otherButtons;
	
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:([otherButtons count] + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons)
		[buttons addObjectsFromArray:otherButtons];
	
	self.presentCompletion = completion;
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelButton.title otherButtonTitles:nil];
	
	for(NSUInteger i = 0; i < [otherButtons count]; i++)
	{
		JFAlertButton* button = [otherButtons objectAtIndex:i];
		[alertView addButtonWithTitle:button.title];
	}
	
	self.alertView = alertView;
	self.currentButtons = [buttons copy];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(Block)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromBarButtonItem:barButtonItem animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(Block)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromRect:rect inView:view animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(Block)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromTabBar:tabBar];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(Block)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromToolbar:toolbar];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromView:(UIView*)view completion:(Block)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showInView:view];
	
	return YES;
}

- (BOOL)presentAsAlertView:(Block)completion
{
	if(![self prepareAlertView:completion])
		return NO;
	
	[self.alertView show];
	
	return YES;
}


#pragma mark User interface management (Alerts handling)

- (void)alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	JFAlertButton* button = ((buttonIndex < 0) ? nil : [self.currentButtons objectAtIndex:buttonIndex]);
	if(button && button.action)
		button.action();
}

- (void)alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.isVisible = NO;
	
	JFAlertButton* button = ((buttonIndex < 0) ? nil : [self.currentButtons objectAtIndex:buttonIndex]);
	
	if(alert == self.actionSheet)		self.actionSheet = nil;
	else if(alert == self.alertView)	self.alertView = nil;
	
	self.currentButtons = nil;
	
	[self notifyDidDismissWithButton:button];
	
	if(self.dismissCompletion)
	{
		Block completion = self.dismissCompletion;
		self.dismissCompletion = nil;
		completion();
	}
}

- (void)alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	JFAlertButton* button = ((buttonIndex < 0) ? nil : [self.currentButtons objectAtIndex:buttonIndex]);
	
	[self notifyWillDismissWithButton:button];
}

- (void)didPresentAlert:(id)alert
{
	[self notifyDidPresent];
	
	if(self.presentCompletion)
	{
		Block completion = self.presentCompletion;
		self.presentCompletion = nil;
		completion();
	}
}

- (void)willPresentAlert:(id)alert
{
	self.isVisible = YES;
	
	[self notifyWillPresent];
}


#pragma mark Protocol implementation (UIActionSheetDelegate)

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet clickedButtonAtIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet didDismissWithButtonIndex:buttonIndex];
}

- (void)actionSheet:(UIActionSheet*)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:actionSheet willDismissWithButtonIndex:buttonIndex];
}

- (void)didPresentActionSheet:(UIActionSheet*)actionSheet
{
	[self didPresentAlert:actionSheet];
}

- (void)willPresentActionSheet:(UIActionSheet*)actionSheet
{
	[self willPresentAlert:actionSheet];
}


#pragma mark Protocol implementation (UIAlertViewDelegate)

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self alert:alertView clickedButtonAtIndex:buttonIndex];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:alertView didDismissWithButtonIndex:buttonIndex];
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self alert:alertView willDismissWithButtonIndex:buttonIndex];
}

- (void)didPresentAlertView:(UIAlertView*)alertView
{
	[self didPresentAlert:alertView];
}

- (void)willPresentAlertView:(UIAlertView*)alertView
{
	[self willPresentAlert:alertView];
}


#pragma mark Notifications management

- (void)notifyDidDismissWithButton:(JFAlertButton*)button
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alert:didDismissWithButton:)])
		[self.delegate alert:self didDismissWithButton:button];
}

- (void)notifyDidPresent
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertDidPresent:)])
		[self.delegate alertDidPresent:self];
}

- (void)notifyWillDismissWithButton:(JFAlertButton*)button
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alert:willDismissWithButton:)])
		[self.delegate alert:self willDismissWithButton:button];
}

- (void)notifyWillPresent
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertWillPresent:)])
		[self.delegate alertWillPresent:self];
}

@end



#pragma mark



@implementation JFAlertButton

#pragma mark Properties

// Blocks
@synthesize	action	= _action;

// Data
@synthesize	title	= _title;


#pragma mark Memory management

+ (instancetype)buttonWithTitle:(NSString*)title action:(Block)action
{
	return [(JFAlertButton*)[self alloc] initWithTitle:title action:action];
}

- (instancetype)initWithTitle:(NSString*)title action:(Block)action
{
	self = (title ? [self init] : nil);
	if(self)
	{
		// Blocks
		_action = (action ? [action copy] : nil);
		_title = [title copy];
	}
	return self;
}

@end

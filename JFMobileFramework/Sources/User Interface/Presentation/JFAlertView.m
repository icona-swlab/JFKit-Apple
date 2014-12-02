//
//  JFAlertView.m
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



#import "JFAlertView.h"

#import "JFUtilities.h"



@interface JFAlertView () <UIAlertViewDelegate>

// Blocks
@property (copy, nonatomic)	Block	dismissCompletion;
@property (copy, nonatomic)	Block	presentCompletion;

// Flags
@property (assign, nonatomic, readwrite)	BOOL	isVisible;

// User interface
@property (strong, nonatomic)	UIAlertView*	alertView;
@property (strong, nonatomic)	NSArray*		currentButtons;
@end



@implementation JFAlertView

#pragma mark - Properties

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
@synthesize alertView		= _alertView;
@synthesize buttons			= _buttons;
@synthesize currentButtons	= _currentButtons;


#pragma mark - Memory management

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


#pragma mark - User interface management

- (BOOL)dismissWithClickedButton:(JFAlertViewButton*)button completion:(Block)completion
{
	if(!self.isVisible)
		return NO;
	
	NSArray* buttons = self.currentButtons;
	
	if(![buttons containsObject:button])
		return NO;
	
	self.dismissCompletion = completion;
	
	NSInteger index = [buttons indexOfObject:button];
	
	[self.alertView dismissWithClickedButtonIndex:index animated:YES];
	
	return YES;
}

- (BOOL)present:(Block)completion
{
	if(self.isVisible)
		return NO;
	
	NSArray* buttons = self.buttons;
	
	JFAlertViewButton* cancelButton = [buttons firstObject];
	if(!cancelButton)
		return NO;
	
	self.presentCompletion = completion;
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelButton.title otherButtonTitles:nil];
	
	for(NSUInteger i = 1; i < [buttons count]; i++)
	{
		JFAlertViewButton* button = [buttons objectAtIndex:i];
		[alertView addButtonWithTitle:button.title];
	}
	
	self.alertView = alertView;
	self.currentButtons = buttons;
	
	[alertView show];
	
	return YES;
}


#pragma mark - Protocol implementation (UIAlertViewDelegate)

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	JFAlertViewButton* button = [self.currentButtons objectAtIndex:buttonIndex];
	if(button.action)
		button.action();
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.isVisible = NO;
	
	JFAlertViewButton* button = [self.currentButtons objectAtIndex:buttonIndex];
	
	self.alertView = nil;
	self.currentButtons = nil;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButton:)])
		[self.delegate alertView:self didDismissWithButton:button];
	
	if(self.dismissCompletion)
	{
		Block completion = self.dismissCompletion;
		self.dismissCompletion = nil;
		completion();
	}
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButton:)])
	{
		JFAlertViewButton* button = [self.currentButtons objectAtIndex:buttonIndex];
		[self.delegate alertView:self willDismissWithButton:button];
	}
}

- (void)didPresentAlertView:(UIAlertView*)alertView
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidPresent:)])
		[self.delegate alertViewDidPresent:self];
	
	if(self.presentCompletion)
	{
		Block completion = self.presentCompletion;
		self.presentCompletion = nil;
		completion();
	}
}

- (void)willPresentAlertView:(UIAlertView*)alertView
{
	self.isVisible = YES;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillPresent:)])
		[self.delegate alertViewWillPresent:self];
	
}

@end



@implementation JFAlertViewButton

#pragma mark - Properties

// Blocks
@synthesize	action	= _action;

// Data
@synthesize	title	= _title;


#pragma mark - Memory management

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

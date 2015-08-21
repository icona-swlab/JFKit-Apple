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



#if TARGET_OS_IPHONE
@interface JFAlert () <UIActionSheetDelegate, UIAlertViewDelegate>
#else
@interface JFAlert ()
#endif

#pragma mark Properties

// Blocks
@property (copy, nonatomic)	JFBlock	dismissCompletion;
@property (copy, nonatomic)	JFBlock	presentCompletion;

// Flags
#if !TARGET_OS_IPHONE
@property (assign, nonatomic, getter = isApplicationModal)		BOOL	applicationModal;
#endif
@property (assign, nonatomic, readwrite, getter = isVisible)	BOOL	visible;

// Timing
@property (strong, nonatomic)	NSTimer*	timer;

// User interface
#if TARGET_OS_IPHONE
@property (strong, nonatomic)	UIActionSheet*	actionSheet;
@property (strong, nonatomic)	UIAlertView*	alertView;
#else
@property (strong, nonatomic)	NSAlert*		alertView;
#endif
@property (strong, nonatomic)	NSArray*		currentButtons;


#pragma mark Methods

// Data management
- (JFAlertButton*)	buttonAtIndex:(NSInteger)buttonIndex;

// Notifications management
- (void)	notifyDidDismissWithButton:(JFAlertButton*)button;
- (void)	notifyDidPresent;
- (void)	notifyWillDismissWithButton:(JFAlertButton*)button;
- (void)	notifyWillPresent;

// User interface management
#if TARGET_OS_IPHONE
- (BOOL)	prepareActionSheet:(JFBlock)completion;
#endif
- (BOOL)	prepareAlertView:(JFBlock)completion;

// User interface management (Alerts handling)
- (void)	alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)	alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)	alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex;
#if !TARGET_OS_IPHONE
- (void)	alertDidEnd:(NSAlert*)alert returnCode:(NSModalResponse)returnCode contextInfo:(void*)contextInfo;
#endif
- (void)	didPresentAlert:(id)alert;
- (void)	willPresentAlert:(id)alert;

@end



#pragma mark



@implementation JFAlert

#pragma mark Properties

// Attributes
#if !TARGET_OS_IPHONE
@synthesize style	= _style;
#endif

// Blocks
@synthesize dismissCompletion	= _dismissCompletion;
@synthesize presentCompletion	= _presentCompletion;

// Data
@synthesize message	= _message;
@synthesize title	= _title;

// Flags
#if !TARGET_OS_IPHONE
@synthesize applicationModal	= _applicationModal;
#endif
@synthesize visible	= _visible;

// Relationships
@synthesize delegate	= _delegate;

// Timing
@synthesize timer	= _timer;

// User interface
#if TARGET_OS_IPHONE
@synthesize actionSheet			= _actionSheet;
#endif
@synthesize alertView			= _alertView;
@synthesize cancelButton		= _cancelButton;
#if TARGET_OS_IPHONE
@synthesize destructiveButton	= _destructiveButton;
#endif
@synthesize currentButtons		= _currentButtons;
@synthesize otherButtons		= _otherButtons;


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Flags
#if !TARGET_OS_IPHONE
		_applicationModal = NO;
#endif
		_visible = NO;
	}
	return self;
}


#pragma mark Data management

- (JFAlertButton*)buttonAtIndex:(NSInteger)buttonIndex
{
	NSArray* buttons = self.currentButtons;
	if((buttonIndex < 0) || (buttonIndex >= [buttons count]))
		return nil;
	
	return [buttons objectAtIndex:buttonIndex];
}


#pragma mark Notifications management

- (void)notifyDidDismissWithButton:(JFAlertButton*)button
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alert:didDismissWithButton:)])
		[delegate alert:self didDismissWithButton:button];
}

- (void)notifyDidPresent
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alertDidPresent:)])
		[delegate alertDidPresent:self];
}

- (void)notifyWillDismissWithButton:(JFAlertButton*)button
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alert:willDismissWithButton:)])
		[delegate alert:self willDismissWithButton:button];
}

- (void)notifyWillPresent
{
	id<JFAlertDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(alertWillPresent:)])
		[delegate alertWillPresent:self];
}


#pragma mark User interface management

- (BOOL)dismiss:(JFBlock)completion
{
	return [self dismissWithClickedButton:nil completion:completion];
}

- (BOOL)dismissWithClickedButton:(JFAlertButton*)button completion:(JFBlock)completion
{
	BOOL shouldAbort = (![self isVisible] || !self.alertView);
	
#if TARGET_OS_IPHONE
	if(shouldAbort && self.actionSheet)
		shouldAbort = NO;
#endif
	
	if(shouldAbort)
		return NO;
	
	NSInteger index = 0;
	if(button)
	{
		NSArray* buttons = self.currentButtons;
		if([buttons containsObject:button])
			index = [buttons indexOfObject:button];
		else
			button = nil;
	}
	
	self.dismissCompletion = completion;
	
	if(self.alertView)
	{
#if TARGET_OS_IPHONE
		UIAlertView* alertView = self.alertView;
		NSInteger buttonIndex = (button ? index : [alertView cancelButtonIndex]);
		[self alert:alertView clickedButtonAtIndex:buttonIndex];
		[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
#else
		NSWindow* sheet = self.alertView.window;
		if(button)
		{
			NSModalResponse returnCode = NSAlertFirstButtonReturn + index;
			
			if([self isApplicationModal])
				[NSApp stopModalWithCode:returnCode];
			else
			{
				if(OSX10_9Plus)
					[sheet.sheetParent endSheet:sheet returnCode:returnCode];
				else
					[NSApp endSheet:sheet returnCode:returnCode];
			}
		}
		else
		{
			if([self isApplicationModal])
				[NSApp stopModal];
			else
			{
				if(OSX10_9Plus)
					[sheet.sheetParent endSheet:sheet];
				else
					[NSApp endSheet:sheet];
			}
		}
#endif
	}
#if TARGET_OS_IPHONE
	else if(self.actionSheet)
	{
		UIActionSheet* actionSheet = self.actionSheet;
		NSInteger buttonIndex = (button ? index : [actionSheet cancelButtonIndex]);
		[self alert:actionSheet clickedButtonAtIndex:buttonIndex];
		[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	}
#endif
	
	return YES;
}

#if TARGET_OS_IPHONE

- (BOOL)prepareActionSheet:(JFBlock)completion
{
	if([self isVisible] || self.actionSheet || self.alertView)
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

#endif

- (BOOL)prepareAlertView:(JFBlock)completion
{
	if([self isVisible] || self.alertView)
		return NO;
	
#if TARGET_OS_IPHONE
	if(self.actionSheet)
		return NO;
#endif
	
	JFAlertButton* cancelButton = self.cancelButton;
	if(!cancelButton)
		return NO;
	
	NSArray* otherButtons = self.otherButtons;
	
	NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:([otherButtons count] + 1)];
	[buttons addObject:cancelButton];
	if(otherButtons)
		[buttons addObjectsFromArray:otherButtons];
	
	self.presentCompletion = completion;
	
#if TARGET_OS_IPHONE
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelButton.title otherButtonTitles:nil];
#else
	NSAlert* alertView = [NSAlert new];
	alertView.informativeText = self.message;
	alertView.messageText = self.title;
	[alertView addButtonWithTitle:cancelButton.title];
#endif
	
	for(NSUInteger i = 0; i < [otherButtons count]; i++)
	{
		JFAlertButton* button = [otherButtons objectAtIndex:i];
		[alertView addButtonWithTitle:button.title];
	}
	
	self.alertView = alertView;
	self.currentButtons = [buttons copy];
	
	return YES;
}

#if TARGET_OS_IPHONE

- (BOOL)presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(JFBlock)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromBarButtonItem:barButtonItem animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(JFBlock)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromRect:rect inView:view animated:YES];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(JFBlock)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromTabBar:tabBar];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(JFBlock)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showFromToolbar:toolbar];
	
	return YES;
}

- (BOOL)presentAsActionSheetFromView:(UIView*)view completion:(JFBlock)completion
{
	if(![self prepareActionSheet:completion])
		return NO;
	
	[self.actionSheet showInView:view];
	
	return YES;
}

#else

- (BOOL)presentAsActionSheetForWindow:(NSWindow*)window completion:(JFBlock)completion
{
	if(![self prepareAlertView:completion])
		return NO;
	
	self.applicationModal = NO;
	
	NSAlert* alert = self.alertView;
	
	[self willPresentAlert:alert];
	
	if(OSX10_9Plus)
	{
		void (^handler)(NSModalResponse) = ^(NSModalResponse returnCode)
		{
			[self alertDidEnd:alert returnCode:returnCode contextInfo:NULL];
		};
		
		[alert beginSheetModalForWindow:window completionHandler:handler];
	}
	else
	{
		SEL selector = @selector(alertDidEnd:returnCode:contextInfo:);
		
		[alert beginSheetModalForWindow:window modalDelegate:self didEndSelector:selector contextInfo:NULL];
	}
	
	[self didPresentAlert:alert];
	
	return YES;
}

#endif

- (BOOL)presentAsAlertView:(JFBlock)completion
{
	return [self presentAsAlertViewWithTimeout:0.0 completion:completion];
}

- (BOOL)presentAsAlertViewWithTimeout:(NSTimeInterval)timeout completion:(JFBlock)completion
{
	if(![self prepareAlertView:completion])
		return NO;
	
	if(timeout > 0.0)
	{
		SEL selector = @selector(dismiss:);
		
		NSMethodSignature* signature = [self methodSignatureForSelector:selector];
		NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
		invocation.selector = selector;
		invocation.target = self;
		
		self.timer = [NSTimer timerWithTimeInterval:timeout invocation:invocation repeats:NO];
	}
	
#if TARGET_OS_IPHONE
	[self.alertView show];
#else
	self.applicationModal = YES;
	[MainOperationQueue addOperationWithBlock:^{
		NSAlert* alert = self.alertView;
		[self willPresentAlert:alert];
		[self didPresentAlert:alert];
		NSModalResponse returnCode = [alert runModal];
		[self alertDidEnd:alert returnCode:returnCode contextInfo:NULL];
	}];
#endif
	
	return YES;
}


#pragma mark User interface management (Alerts handling)

- (void)alert:(id)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	if(button && button.action)
		button.action();
}

- (void)alert:(id)alert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.visible = NO;
	
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	
#if TARGET_OS_IPHONE
	self.actionSheet = nil;
#else
	self.applicationModal = NO;
#endif
	
	self.alertView = nil;
	self.currentButtons = nil;
	
	[self notifyDidDismissWithButton:button];
	
	if(self.dismissCompletion)
	{
		JFBlock completion = self.dismissCompletion;
		self.dismissCompletion = nil;
		completion();
	}
}

- (void)alert:(id)alert willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(self.timer)
	{
		[self.timer invalidate];
		self.timer = nil;
	}
	
	JFAlertButton* button = [self buttonAtIndex:buttonIndex];
	
	[self notifyWillDismissWithButton:button];
}

#if !TARGET_OS_IPHONE

- (void)alertDidEnd:(NSAlert*)alert returnCode:(NSModalResponse)returnCode contextInfo:(void*)contextInfo
{
	if(returnCode < 0)
		returnCode = NSAlertFirstButtonReturn;
	
	NSInteger buttonIndex = returnCode - NSAlertFirstButtonReturn;
	
	[self alert:alert clickedButtonAtIndex:buttonIndex];
	[self alert:alert willDismissWithButtonIndex:buttonIndex];
	if(!OSX10_9Plus && ![self isApplicationModal])
		[alert.window orderOut:alert];
	[self alert:alert didDismissWithButtonIndex:buttonIndex];
}

#endif

- (void)didPresentAlert:(id)alert
{
	NSTimer* timer = self.timer;
	if(timer)
	{
#if TARGET_OS_IPHONE
		NSString* runLoopMode = NSDefaultRunLoopMode;
#else
		NSString* runLoopMode = NSModalPanelRunLoopMode;
#endif
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:runLoopMode];
	}
	
	[self notifyDidPresent];
	
	if(self.presentCompletion)
	{
		JFBlock completion = self.presentCompletion;
		self.presentCompletion = nil;
		completion();
	}
}

- (void)willPresentAlert:(id)alert
{
	self.visible = YES;
	
	[self notifyWillPresent];
}


#if TARGET_OS_IPHONE

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

#endif

@end



#pragma mark



@implementation JFAlertButton

#pragma mark Properties

// Blocks
@synthesize	action	= _action;

// Data
@synthesize	title	= _title;


#pragma mark Memory management

+ (instancetype)buttonWithTitle:(NSString*)title action:(JFBlock)action
{
	return [(JFAlertButton*)[self alloc] initWithTitle:title action:action];
}

- (instancetype)initWithTitle:(NSString*)title action:(JFBlock)action
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

//
//  JFAlert.h
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



#import "JFUtilities.h"



@class JFAlert;
@class JFAlertButton;



@protocol JFAlertDelegate <NSObject>

@optional

- (void)	alertDidPresent:(JFAlert*)alert;
- (void)	alertWillPresent:(JFAlert*)alert;

- (void)	alert:(JFAlert*)alert didDismissWithButton:(JFAlertButton*)button;
- (void)	alert:(JFAlert*)alert willDismissWithButton:(JFAlertButton*)button;

@end



#pragma mark



@interface JFAlert : NSObject

#pragma mark Properties

// Attributes
#if !TARGET_OS_IPHONE
@property (assign, nonatomic)	NSAlertStyle	style;
#endif

// Data
@property (copy, nonatomic)	NSString*	message;	// Ignored by the iOS action sheet.
@property (copy, nonatomic)	NSString*	title;

// Flags
@property (assign, nonatomic, readonly, getter = isVisible)	BOOL	visible;

// Relationships
@property (weak, nonatomic)	id<JFAlertDelegate>	delegate;

// User interface
@property (strong, nonatomic)	JFAlertButton*	cancelButton;
#if TARGET_OS_IPHONE
@property (strong, nonatomic)	JFAlertButton*	destructiveButton;	// Only used by the iOS action sheet.
#endif
@property (copy, nonatomic)		NSArray*		otherButtons;		// Array of "JFAlertButton" objects.


#pragma mark Methods

// User interface management
- (BOOL)	dismiss:(JFBlock)completion;
- (BOOL)	dismissWithClickedButton:(JFAlertButton*)button completion:(JFBlock)completion;
#if TARGET_OS_IPHONE
- (BOOL)	presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(JFBlock)completion;	// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(JFBlock)completion;			// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(JFBlock)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(JFBlock)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetInView:(UIView*)view completion:(JFBlock)completion;								// Fails if there are no buttons.
#else
- (BOOL)	presentAsActionSheetForWindow:(NSWindow*)window completion:(JFBlock)completion;							// Fails if there are no buttons.
#endif
- (BOOL)	presentAsAlertView:(JFBlock)completion;																	// Fails if there is not the cancel button.
- (BOOL)	presentAsAlertViewWithTimeout:(NSTimeInterval)timeout completion:(JFBlock)completion;					// Fails if there is not the cancel button.

@end



#pragma mark



@interface JFAlertButton : NSObject

#pragma mark Properties

// Blocks
@property (copy, nonatomic, readonly)	JFBlock	action;

// Data
@property (copy, nonatomic, readonly)	NSString*	title;


#pragma mark Methods

// Memory management
+ (instancetype)	buttonWithTitle:(NSString*)title;
+ (instancetype)	buttonWithTitle:(NSString*)title action:(JFBlock)action;
- (instancetype)	initWithTitle:(NSString*)title action:(JFBlock)action;

@end

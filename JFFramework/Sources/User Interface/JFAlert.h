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
#pragma mark Optional

- (void)	alertDidPresent:(JFAlert*)alert;
- (void)	alertWillPresent:(JFAlert*)alert;

- (void)	alert:(JFAlert*)alert didDismissWithButton:(JFAlertButton*)button;
- (void)	alert:(JFAlert*)alert willDismissWithButton:(JFAlertButton*)button;

@end



#pragma mark



@interface JFAlert : NSObject

#pragma mark Properties

// Data
@property (copy, nonatomic)	NSString*	message;	// Used only by the alert view.
@property (copy, nonatomic)	NSString*	title;

// Flags
@property (assign, nonatomic, readonly)	BOOL	isVisible;

// Relationships
@property (weak, nonatomic)	id<JFAlertDelegate>	delegate;

// User interface
@property (strong, nonatomic)	JFAlertButton*	cancelButton;
@property (strong, nonatomic)	JFAlertButton*	destructiveButton;	// Used only by the action sheet.
@property (copy, nonatomic)		NSArray*		otherButtons;		// Array of "JFAlertButton" objects.


#pragma mark Methods

// User interface management
- (BOOL)	dismiss:(Block)completion;
- (BOOL)	dismissWithClickedButton:(JFAlertButton*)button completion:(Block)completion;
- (BOOL)	presentAsActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem completion:(Block)completion;	// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromRect:(CGRect)rect inView:(UIView*)view completion:(Block)completion;			// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromTabBar:(UITabBar*)tabBar completion:(Block)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromToolbar:(UIToolbar*)toolbar completion:(Block)completion;						// Fails if there are no buttons.
- (BOOL)	presentAsActionSheetFromView:(UIView*)view completion:(Block)completion;								// Fails if there are no buttons.
- (BOOL)	presentAsAlertView:(Block)completion;																		// Fails if there is not at least the cancel button.

@end



#pragma mark



@interface JFAlertButton : NSObject

#pragma mark Properties

// Blocks
@property (copy, nonatomic, readonly)	Block	action;

// Data
@property (copy, nonatomic, readonly)	NSString*	title;


#pragma mark Methods

// Memory management
+ (instancetype)	buttonWithTitle:(NSString*)title action:(Block)action;
- (instancetype)	initWithTitle:(NSString*)title action:(Block)action;

@end

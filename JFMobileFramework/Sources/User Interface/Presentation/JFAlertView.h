//
//  JFAlertView.h
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



#import <Foundation/Foundation.h>



@class JFAlertView;
@class JFAlertViewButton;



@protocol JFAlertViewDelegate <NSObject>

@optional

- (void)	alertViewDidPresent:(JFAlertView*)alertView;
- (void)	alertViewWillPresent:(JFAlertView*)alertView;

- (void)	alertView:(JFAlertView*)alertView didDismissWithButton:(JFAlertViewButton*)button;
- (void)	alertView:(JFAlertView*)alertView willDismissWithButton:(JFAlertViewButton*)button;

@end



@interface JFAlertView : NSObject

// Data
@property (copy, nonatomic)	NSString*	message;
@property (copy, nonatomic)	NSString*	title;

// Flags
@property (assign, nonatomic, readonly)	BOOL	isVisible;

// Relationships
@property (weak, nonatomic)	id<JFAlertViewDelegate>	delegate;

// User interface
@property (copy, nonatomic)	NSArray*	buttons;	// Array of "JFAlertViewButton" objects; the first object is always the cancel button.

// User interface management
- (BOOL)	dismissWithClickedButton:(JFAlertViewButton*)button completion:(Block)completion;
- (BOOL)	present:(Block)completion;

@end



@interface JFAlertViewButton : NSObject

// Blocks
@property (copy, nonatomic, readonly)	Block	action;

// Data
@property (copy, nonatomic, readonly)	NSString*	title;

// Memory management
- (instancetype)	initWithTitle:(NSString*)title action:(Block)action;

@end

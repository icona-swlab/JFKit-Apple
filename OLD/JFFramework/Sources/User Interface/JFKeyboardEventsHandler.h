//
//  JFKeyboardEventsHandler.h
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



@class JFKeyboardEventsHandler;
@class JFKeyboardInfo;



@protocol JFKeyboardEventsHandlerDelegate <NSObject>

@optional

#pragma mark Events
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didChangeFrame:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didHide:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler didShow:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willChangeFrame:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willHide:(JFKeyboardInfo*)info;
- (void)	keyboardEventsHandler:(JFKeyboardEventsHandler*)handler willShow:(JFKeyboardInfo*)info;

@end



#pragma mark



@interface JFKeyboardEventsHandler : NSObject

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	IBInspectable	CGFloat	constant;

// Constraints
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	resizableViewBottomConstraint;

// Relationships
@property (weak, nonatomic)	IBOutlet	id<JFKeyboardEventsHandlerDelegate>	delegate;

// User interface
@property (strong, nonatomic)	IBOutlet	UIView*	resizableView;

@end



#pragma mark



@interface JFKeyboardInfo : NSObject <NSCopying>

#pragma mark Properties

// Attributes
@property (assign, nonatomic) NSTimeInterval		animationDuration;
@property (assign, nonatomic) UIViewAnimationCurve	animationCurve;
@property (assign, nonatomic) CGRect				beginningFrame;
@property (assign, nonatomic) CGRect				endingFrame;

@end

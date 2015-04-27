//
//  JFViewController.h
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



@class JFLogger;
@class JFViewController;



#pragma mark Constants (Notifications)

// Keys (Navigation)
extern NSString* const	JFViewControllerIsAnimatedKey;	// NSNumber

// Names (Navigation)
extern NSString* const	JFViewControllerHasBeenDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPoppedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPresentedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPushedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBeDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePoppedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePresentedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePushedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.



#pragma mark



@protocol JFViewControllerNavigationDelegate <NSObject>

@optional

- (void)	viewController:(JFViewController*)viewController hasBeenDismissed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPopped:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPresented:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPushed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBeDismissed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePopped:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePresented:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePushed:(BOOL)animated;

@end



#pragma mark



@interface JFViewController : UIViewController

#pragma mark Properties

// Debug
@property (strong, nonatomic)						JFLogger*	logger;
@property (assign, nonatomic, getter = isLogging)	BOOL		logging;

// Relationships
@property (weak, nonatomic)	id<JFViewControllerNavigationDelegate>	navigationDelegate;


#pragma mark Methods

// User interface management (Navigation)
- (void)	hasBeenDismissed:(BOOL)animated;	// The view controller has been modally dismissed.
- (void)	hasBeenPopped:(BOOL)animated;		// The view controller has been popped from a navigation stack.
- (void)	hasBeenPresented:(BOOL)animated;	// The view controller has been modally presented.
- (void)	hasBeenPushed:(BOOL)animated;		// The view controller has been pushed on a navigation stack.
- (void)	willBeDismissed:(BOOL)animated;		// The view controller will be modally dismissed.
- (void)	willBePopped:(BOOL)animated;		// The view controller will be popped from a navigation stack.
- (void)	willBePresented:(BOOL)animated;		// The view controller will be modally presented.
- (void)	willBePushed:(BOOL)animated;		// The view controller will be pushed on a navigation stack.

@end

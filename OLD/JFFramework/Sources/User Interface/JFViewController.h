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
extern NSString* const	JFViewControllerParentKey;		// UIViewController

// Names (Navigation)
extern NSString* const	JFViewControllerDidMoveToParentNotification;	// UserInfo: JFViewControllerParentKey.
extern NSString* const	JFViewControllerHasBeenDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPoppedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPresentedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerHasBeenPushedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBeDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePoppedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePresentedNotification;	// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillBePushedNotification;		// UserInfo: JFViewControllerIsAnimatedKey.
extern NSString* const	JFViewControllerWillMoveToParentNotification;	// UserInfo: JFViewControllerParentKey.



#pragma mark



@protocol JFViewControllerNavigationDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)	viewController:(JFViewController*)viewController didMoveToParent:(UIViewController*)parent;
- (void)	viewController:(JFViewController*)viewController hasBeenDismissed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPopped:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPresented:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController hasBeenPushed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBeDismissed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePopped:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePresented:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willBePushed:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController willMoveToParent:(UIViewController*)parent;

@end



#pragma mark



@protocol JFViewControllerRotationDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)					viewController:(JFViewController*)viewController didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (void)					viewController:(JFViewController*)viewController willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)					viewController:(JFViewController*)viewController willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (UIInterfaceOrientation)	viewControllerPreferredInterfaceOrientationForPresentation:(JFViewController*)viewController;
- (BOOL)					viewControllerShouldAutorotate:(JFViewController*)viewController;
- (NSUInteger)				viewControllerSupportedInterfaceOrientations:(JFViewController*)viewController;

@end



#pragma mark



@protocol JFViewControllerVisibilityDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)	viewController:(JFViewController*)viewController viewDidAppearAnimated:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController viewDidDisappearAnimated:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController viewWillAppearAnimated:(BOOL)animated;
- (void)	viewController:(JFViewController*)viewController viewWillDisappearAnimated:(BOOL)animated;

@end



#pragma mark



@interface JFViewController : UIViewController

#pragma mark Properties

// Relationships
@property (weak, nonatomic)	id<JFViewControllerNavigationDelegate>	navigationDelegate;
@property (weak, nonatomic)	id<JFViewControllerRotationDelegate>	rotationDelegate;
@property (weak, nonatomic)	id<JFViewControllerVisibilityDelegate>	visibilityDelegate;


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

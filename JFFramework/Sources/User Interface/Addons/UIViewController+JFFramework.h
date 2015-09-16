//
//  UIViewController+JFFramework.h
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



#pragma mark - Constants

// Notifications (Navigation)
FOUNDATION_EXPORT NSString* const	JFViewControllerDidMoveToParentNotification;	// UserInfo: JFViewControllerParentViewControllerUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerHasBeenDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerHasBeenPoppedNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerHasBeenPresentedNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerHasBeenPushedNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillBeDismissedNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillBePoppedNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillBePresentedNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillBePushedNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillMoveToParentNotification;	// UserInfo: JFViewControllerParentViewControllerUserInfoKey.

// Notifications (Rotation)
FOUNDATION_EXPORT NSString* const	JFViewControllerDidRotateFromInterfaceOrientationNotification;			// UserInfo: JFViewControllerInterfaceOrientationUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillAnimateRotationToInterfaceOrientationNotification;	// UserInfo: JFViewControllerInterfaceOrientationUserInfoKey, JFViewControllerDurationUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerWillRotateToInterfaceOrientationNotification;			// UserInfo: JFViewControllerInterfaceOrientationUserInfoKey, JFViewControllerDurationUserInfoKey.

// Notifications (Visibility)
FOUNDATION_EXPORT NSString* const	JFViewControllerViewDidAppearNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerViewDidDisappearNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerViewWillAppearNotification;		// UserInfo: JFViewControllerIsAnimatedUserInfoKey.
FOUNDATION_EXPORT NSString* const	JFViewControllerViewWillDisappearNotification;	// UserInfo: JFViewControllerIsAnimatedUserInfoKey.

// User info keys
FOUNDATION_EXPORT NSString* const	JFViewControllerDurationUserInfoKey;				// NSNumber (NSTimeInterval)
FOUNDATION_EXPORT NSString* const	JFViewControllerInterfaceOrientationUserInfoKey;	// NSNumber (UIInterfaceOrientation)
FOUNDATION_EXPORT NSString* const	JFViewControllerIsAnimatedUserInfoKey;				// NSNumber (BOOL)
FOUNDATION_EXPORT NSString* const	JFViewControllerParentViewControllerUserInfoKey;	// UIViewController



#pragma mark



@protocol JFViewControllerNavigationDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)	viewController:(UIViewController*)viewController didMoveToParent:(UIViewController*)parent;
- (void)	viewController:(UIViewController*)viewController hasBeenDismissedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController hasBeenPoppedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController hasBeenPresentedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController hasBeenPushedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController willBeDismissedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController willBePoppedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController willBePresentedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController willBePushedAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController willMoveToParent:(UIViewController*)parent;

@end



#pragma mark



@protocol JFViewControllerRotationDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)					viewController:(UIViewController*)viewController didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (UIInterfaceOrientation)	viewController:(UIViewController*)viewController preferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)proposedInterfaceOrientation;
- (BOOL)					viewController:(UIViewController*)viewController shouldAutorotate:(BOOL)proposedAnswer;
- (NSUInteger)				viewController:(UIViewController*)viewController supportedInterfaceOrientations:(NSUInteger)proposedInterfaceOrientations;
- (void)					viewController:(UIViewController*)viewController willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)					viewController:(UIViewController*)viewController willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end



#pragma mark



@protocol JFViewControllerVisibilityDelegate <NSObject>

@optional
#pragma mark Optional methods

- (void)	viewController:(UIViewController*)viewController viewDidAppearAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController viewDidDisappearAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController viewWillAppearAnimated:(BOOL)animated;
- (void)	viewController:(UIViewController*)viewController viewWillDisappearAnimated:(BOOL)animated;

@end



#pragma mark



@interface UIViewController (JFFramework_Navigation)

#pragma mark Properties

// Relationships
@property (weak, nonatomic)	id<JFViewControllerNavigationDelegate>	navigationDelegate;


#pragma mark Methods

// User interface management
- (void)	hasBeenDismissed:(BOOL)animated;	// The view controller has been modally dismissed.
- (void)	hasBeenPopped:(BOOL)animated;		// The view controller has been popped from a navigation stack.
- (void)	hasBeenPresented:(BOOL)animated;	// The view controller has been modally presented.
- (void)	hasBeenPushed:(BOOL)animated;		// The view controller has been pushed on a navigation stack.
- (void)	willBeDismissed:(BOOL)animated;		// The view controller will be modally dismissed.
- (void)	willBePopped:(BOOL)animated;		// The view controller will be popped from a navigation stack.
- (void)	willBePresented:(BOOL)animated;		// The view controller will be modally presented.
- (void)	willBePushed:(BOOL)animated;		// The view controller will be pushed on a navigation stack.

@end



#pragma mark



@interface UIViewController (JFFramework_Rotation)

#pragma mark Properties

// Relationships
@property (weak, nonatomic)	id<JFViewControllerRotationDelegate>	rotationDelegate;

@end



#pragma mark



@interface UIViewController (JFFramework_Visibility)

#pragma mark Properties

// Relationships
@property (weak, nonatomic)	id<JFViewControllerVisibilityDelegate>	visibilityDelegate;

@end

//
//  JFWindowController.h
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



#import "UIViewController+JFFramework.h"

#import "JFUtilities.h"



@class JFLogger;



@interface JFWindowController : NSObject

#pragma mark Properties

// Flags
@property (assign, nonatomic, readonly, getter = isUserInterfaceLoaded)	BOOL	userInterfaceLoaded;

// User interface
@property (copy, nonatomic, readonly)	NSSet*				observedViewControllers;
@property (weak, nonatomic, readonly)	UIViewController*	rootViewController;
@property (weak, nonatomic, readonly)	UIViewController*	splashViewController;
@property (strong, nonatomic, readonly)	UIWindow*			window;


#pragma mark Methods

// Memory management
- (instancetype)	initWithWindow:(UIWindow*)window;

// User interface management (Creation)
- (UINavigationController*)	createNavigationController;
- (UINavigationController*)	createNavigationControllerWithRootViewController:(UIViewController*)rootViewController;
- (UIViewController*)		createRootViewController;

// User interface management (Navigation)
- (BOOL)	dismissModalViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(JFBlock)completion;
- (BOOL)	popViewControllerFromNavigationController:(UIViewController*)viewController animated:(BOOL)animated completion:(JFBlock)completion;
- (BOOL)	presentModalViewController:(UIViewController*)viewController fromViewController:(UIViewController*)presentingViewController animated:(BOOL)animated completion:(JFBlock)completion;
- (BOOL)	pushViewController:(UIViewController*)viewController onNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated completion:(JFBlock)completion;

// User interface management (Observation)
- (void)	beginObservingViewController:(UIViewController*)viewController;
- (void)	didBeginObservingViewController:(UIViewController*)viewController;
- (void)	didEndObservingViewController:(UIViewController*)viewController;
- (void)	endObservingViewController:(UIViewController*)viewController;
- (void)	observedViewController:(UIViewController*)viewController didMoveToParent:(UIViewController*)parent;
- (void)	observedViewController:(UIViewController*)viewController hasBeenDismissedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController hasBeenPoppedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController hasBeenPresentedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController hasBeenPushedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController willBeDismissedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController willBePoppedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController willBePresentedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController willBePushedAnimated:(BOOL)animated;
- (void)	observedViewController:(UIViewController*)viewController willMoveToParent:(UIViewController*)parent;
- (BOOL)	shouldEndObservingViewController:(UIViewController*)viewController;

// User interface management (Splash screen)
- (UIViewController*)	createSplashViewController;
- (void)				didDismissSplashViewController:(BOOL)animated;
- (void)				didPresentSplashViewController:(BOOL)animated;
- (void)				dismissSplashViewController:(BOOL)animated;
- (void)				willDismissSplashViewController:(BOOL)animated;
- (void)				willPresentSplashViewController:(BOOL)animated;

// User interface management (Window lifecycle)
- (void)	didLoadUserInterface;
- (void)	loadUserInterface;
- (void)	willLoadUserInterface;
- (void)	windowDidBecomeHidden;
- (void)	windowDidBecomeKey;
- (void)	windowDidBecomeVisible;
- (void)	windowDidResignKey;

@end

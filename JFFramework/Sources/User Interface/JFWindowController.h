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
@property (weak, nonatomic, readonly)	UIViewController*	rootViewController;
@property (weak, nonatomic, readonly)	UIViewController*	splashViewController;
@property (copy, nonatomic, readonly)	NSSet*				viewControllers;
@property (strong, nonatomic, readonly)	UIWindow*			window;


#pragma mark Methods

// Memory management
- (void)			didReleaseViewController:(UIViewController*)viewController;
- (void)			didRetainViewController:(UIViewController*)viewController;
- (instancetype)	initWithWindow:(UIWindow*)window;
- (void)			releaseViewController:(UIViewController*)viewController;	// Will silently fail if 'viewControllers' does NOT contain the passed "viewController".
- (void)			retainViewController:(UIViewController*)viewController;		// Will silently fail if 'viewControllers' already contains the passed "viewController".

// User interface management (Navigation)
- (void)	presentModalViewController:(UIViewController*)modalViewController fromViewController:(UIViewController*)presentingViewController;															// Animated with no completion.
- (void)	presentModalViewController:(UIViewController*)modalViewController fromViewController:(UIViewController*)presentingViewController animated:(BOOL)animated completion:(JFBlock)completion;	// Will automatically retain and release the passed "modalViewController".
- (void)	pushViewController:(UIViewController*)viewController onNavigationController:(UINavigationController*)navigationController;															// Animated with no completion.
- (void)	pushViewController:(UIViewController*)viewController onNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated completion:(JFBlock)completion;	// Will automatically retain and release the passed "viewController".
- (void)	pushViewControllers:(NSArray*)viewControllers onNavigationController:(UINavigationController*)navigationController;															// Animated with no completion.
- (void)	pushViewControllers:(NSArray*)viewControllers onNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated completion:(JFBlock)completion;	// Will automatically retain and release the passed "viewControllers".
- (void)	setViewControllers:(NSArray*)viewControllers forNavigationController:(UINavigationController*)navigationController;															// Animated with no completion.
- (void)	setViewControllers:(NSArray*)viewControllers forNavigationController:(UINavigationController*)navigationController animated:(BOOL)animated completion:(JFBlock)completion;	// Will automatically retain and release the passed "viewControllers".

// User interface management (Window lifecycle)
- (void)	didLoadUserInterface;
- (void)	loadUserInterface;
- (void)	willLoadUserInterface;
- (void)	windowDidBecomeHidden;
- (void)	windowDidBecomeKey;
- (void)	windowDidBecomeVisible;
- (void)	windowDidResignKey;

@end

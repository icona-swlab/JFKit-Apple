//
//  JFWindowController.h
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



@class JFLogger;



@interface JFWindowController : NSObject

#pragma mark Properties

// Flags
@property (assign, nonatomic, readonly, getter = isUserInterfaceLoaded)	BOOL	userInterfaceLoaded;

// Debug
@property (strong, nonatomic, readonly)				JFLogger*	logger;
@property (assign, nonatomic, getter = isLogging)	BOOL		logging;

// User interface
@property (strong, nonatomic, readonly)	UIWindow*	window;


#pragma mark Methods

// Memory management
- (instancetype)	initWithWindow:(UIWindow*)window;
- (instancetype)	initWithWindow:(UIWindow*)window logger:(JFLogger*)logger;	// Default initializator.

// User interface management
- (void)	replaceRootViewControllerWithViewController:(UIViewController*)viewController;
- (void)	replaceRootViewControllerWithViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options;

// User interface management (UIWindow lifecycle)
- (void)	didLoadUserInterface;
- (void)	loadUserInterface;
- (void)	willLoadUserInterface;
- (void)	windowDidBecomeHidden;
- (void)	windowDidBecomeKey;
- (void)	windowDidBecomeVisible;
- (void)	windowDidResignKey;

@end

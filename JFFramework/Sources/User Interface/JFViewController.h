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



#pragma mark Notifications

// Navigation
extern NSString* const	JFViewControllerHasBeenDismissedNotification;	// The view controller has been modally dismissed.
extern NSString* const	JFViewControllerHasBeenPoppedNotification;		// The view controller has been popped from a navigation stack.
extern NSString* const	JFViewControllerHasBeenPresentedNotification;	// The view controller has been modally presented.
extern NSString* const	JFViewControllerHasBeenPushedNotification;		// The view controller has been pushed on a navigation stack.
extern NSString* const	JFViewControllerIsBeingDismissedNotification;	// The view controller is being modally dismissed.
extern NSString* const	JFViewControllerIsBeingPoppedNotification;		// The view controller is being popped from a navigation stack.
extern NSString* const	JFViewControllerIsBeingPresentedNotification;	// The view controller is being modally presented.
extern NSString* const	JFViewControllerIsBeingPushedNotification;		// The view controller is being pushed on a navigation stack.



#pragma mark



@interface JFViewController : UIViewController

#pragma mark Properties

// Debug
@property (strong, nonatomic, readonly)				JFLogger*	logger;
@property (assign, nonatomic, getter = isLogging)	BOOL		logging;


#pragma mark Methods

// Memory management
- (instancetype)	initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil logger:(JFLogger*)logger;

@end

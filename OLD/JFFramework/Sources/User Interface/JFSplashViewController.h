//
//  JFSplashViewController.h
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



#import "JFViewController.h"



@class JFSplashViewController;



@protocol JFSplashViewControllerDelegate <NSObject>

@optional

// Events management
- (void)	splashViewControllerTapGestureRecognized:(JFSplashViewController*)viewController;
- (void)	splashViewControllerTimedOut:(JFSplashViewController*)viewController;

@end



#pragma mark



@interface JFSplashViewController : JFViewController

#pragma mark Properties

// Flags
@property (assign, nonatomic, getter = isUserInteractionEnabled)	BOOL	userInteractionEnabled;

// Relationships
@property (weak, nonatomic)	id<JFSplashViewControllerDelegate>	delegate;

// Timings
@property (assign, nonatomic)	NSTimeInterval	timeout;	// Setting '0.0' disables it.

// User interface
@property (strong, nonatomic, readonly)	UIImageView*	imageView;


#pragma mark Methods

// User interface management (Actions)
- (IBAction)	tapGestureRecognized:(UITapGestureRecognizer*)sender;

@end

//
//  JFAppDelegate.h
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



#import "JFUtilities.h"



@class JFAlertsController;
#if TARGET_OS_IPHONE
@class JFWindowController;
#endif



#if TARGET_OS_IPHONE
@interface JFAppDelegate : UIResponder <UIApplicationDelegate>
#else
@interface JFAppDelegate : NSObject <NSApplicationDelegate>
#endif

#pragma mark Properties

// User interface
@property (strong, nonatomic, readonly)				JFAlertsController*	alertsController;
@property (strong, nonatomic)			IBOutlet	JFWindow*			window;


#pragma mark Methods

// User interface management
#if TARGET_OS_IPHONE
- (JFWindowController*)	createControllerForWindow:(UIWindow*)window;
#endif

@end

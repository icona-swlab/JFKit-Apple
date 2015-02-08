//
//  JFAlertsController.h
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



@class JFAlert;
@class JFAlertButton;



@interface JFAlertsController : NSObject

#pragma mark Methods

// User interface management (Action sheets)
- (void)	presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.
- (void)	presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.
- (void)	presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.
- (void)	presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.
- (void)	presentActionSheetFromView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.

// User interface management (Alert views)
- (void)	presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray*)otherButtons;	// Array of "JFAlertViewButton" objects.

@end

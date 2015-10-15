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
#if TARGET_OS_IPHONE
- (void)	presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentActionSheetInView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
#else
- (void)	presentActionSheetForWindow:(NSWindow*)window style:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
#endif

// User interface management (Alert views)
#if TARGET_OS_IPHONE
- (void)	presentAlertViewForError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
#else
- (void)	presentAlertView:(NSAlertStyle)style forError:(NSError*)error cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertView:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons;
- (void)	presentAlertView:(NSAlertStyle)style title:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray<JFAlertButton*>*)otherButtons timeout:(NSTimeInterval)timeout;
#endif

@end

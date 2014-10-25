//
//  JFDrawerController.h
//  Copyright (C) 2014  Jacopo Filié
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



#import <UIKit/UIKit.h>



@class JFDrawerController;
@class JFMenuItem;



@protocol JFDrawerControllerDelegate <NSObject>

@optional

- (void)	drawerController:(JFDrawerController*)drawerController didSelectItem:(JFMenuItem*)item;

@end



@interface JFDrawerController : UIViewController

// Attributes
@property (strong, nonatomic)	UIColor*	menuBackgroundColor;

// Data
@property (weak, nonatomic)	JFMenuItem*	selectedItem;

// Relationships
@property (weak, nonatomic)	id<JFDrawerControllerDelegate>	delegate;

// User interface
@property (strong, nonatomic)	UIViewController*	rootViewController;

// Data management
- (void)	setMenuItems:(NSArray*)items;

// User interface management
- (BOOL)	hideMenu;
- (BOOL)	hideMenu:(BOOL)animated;
- (BOOL)	showMenu;
- (BOOL)	showMenu:(BOOL)animated;

@end

//
//  JFMenuViewController.h
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



@class JFMenuGroup;
@class JFMenuItem;

@protocol JFMenuViewControllerDelegate;



@interface JFMenuViewController : UITableViewController

// Relationships
@property (weak, nonatomic)	id<JFMenuViewControllerDelegate>	delegate;

// Data management
- (void)	setMenuItems:(NSArray*)items;

@end



@protocol JFMenuViewControllerDelegate <NSObject>

@optional

- (void)	menuViewController:(JFMenuViewController*)drawerController didSelectItem:(JFMenuItem*)item;

- (void)	menuViewController:(JFMenuViewController*)drawerController shouldCollapseGroup:(JFMenuGroup*)group;
- (void)	menuViewController:(JFMenuViewController*)drawerController shouldExpandGroup:(JFMenuGroup*)group;

@end

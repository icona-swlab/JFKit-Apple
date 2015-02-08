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



@class JFMenuItem;
@class JFMenuViewController;



@protocol JFMenuViewControllerDelegate <NSObject>

@optional

- (void)	menuViewController:(JFMenuViewController*)menuViewController didDeselectItem:(JFMenuItem*)item;
- (void)	menuViewController:(JFMenuViewController*)menuViewController didSelectItem:(JFMenuItem*)item;
- (BOOL)	menuViewController:(JFMenuViewController*)menuViewController shouldSelectItem:(JFMenuItem*)item;

@end



@interface JFMenuViewController : UITableViewController

// Data
@property (strong, nonatomic)	NSArray*	items;	// Array of "JFMenuItem" objects.
@property (weak, nonatomic)		JFMenuItem*	selectedItem;

// Relationships
@property (weak, nonatomic)	id<JFMenuViewControllerDelegate>	delegate;

// Data management
- (void)	reloadItems;

@end

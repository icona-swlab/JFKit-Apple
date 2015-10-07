//
//  JFMenuController.h
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



#import "JFMenuObjects.h"



@class JFMenuViewController;



@protocol JFMenuViewControllerDelegate <NSObject>

@optional

- (void)	menuViewController:(JFMenuViewController*)menuViewController didSelectItem:(JFMenuItem*)menuItem;

@end



#pragma mark



@interface JFMenuViewController : UIViewController

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	CGFloat	indentationWidth;

// Data
@property (copy, nonatomic)	NSArray<JFMenuSection*>*	sections;

// Relationships
@property (weak, nonatomic)	id<JFMenuViewControllerDelegate>	delegate;


#pragma mark Methods

// Data management
- (void)	reloadItems;

@end

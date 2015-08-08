//
//  JFTableViewCell.h
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



@class JFTableViewCell;



#pragma mark - Typedefs

typedef void	(^JFTableViewCellSetupBlock)	(id cell);	// Used to prepare the cell.



#pragma mark



@interface JFTableViewCell : UITableViewCell

#pragma mark Methods

// Memory management
+ (UINib*)		nib;
+ (NSString*)	reuseIdentifier;
- (void)		initializeProperties;

// User interface management
+ (CGFloat)	defaultHeight;
+ (CGFloat)	dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock;	// The setup block is called before trying to calculate the height.
+ (CGFloat)	dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock;				// The setup block is called before trying to calculate the height.
+ (CGFloat)	maximumHeight;
+ (CGFloat)	minimumHeight;
- (void)	initializeUserInterface;

@end

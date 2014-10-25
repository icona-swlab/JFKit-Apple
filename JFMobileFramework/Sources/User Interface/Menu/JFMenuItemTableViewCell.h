//
//  JFMenuItemCell.h
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



@interface JFMenuItemTableViewCell : UITableViewCell

// Attributes
@property (strong, nonatomic)	UIColor*		bottomSeparatorColor;
@property (assign, nonatomic)	CGFloat			bottomSeparatorHeight;
@property (assign, nonatomic)	UIEdgeInsets	bottomSeparatorInset;
@property (strong, nonatomic)	UIColor*		topSeparatorColor;
@property (assign, nonatomic)	CGFloat			topSeparatorHeight;
@property (assign, nonatomic)	UIEdgeInsets	topSeparatorInset;

// Memory management
+ (UINib*)		nib;
+ (NSString*)	reuseIdentifier;

@end

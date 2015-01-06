//
//  JFTableViewSection.h
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



@interface JFTableViewSection : NSObject

// Attributes
@property (assign, nonatomic)	CGFloat	footerHeight;
@property (assign, nonatomic)	CGFloat	headerHeight;

// Data
@property (strong, nonatomic)	NSString*	footerTitle;
@property (strong, nonatomic)	NSString*	headerTitle;
@property (strong, nonatomic)	NSArray*	items;

// User interface
@property (strong, nonatomic)	UIView*	footerView;
@property (strong, nonatomic)	UIView*	headerView;

@end

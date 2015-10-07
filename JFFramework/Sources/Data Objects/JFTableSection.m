//
//  JFTableSection.m
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



#import "JFTableSection.h"



#pragma mark - Constants

static CGFloat	DefaultFooterHeight = 0.0f;
static CGFloat	DefaultHeaderHeight = 0.0f;



#pragma mark



@implementation JFTableSection

#pragma mark Properties

// Attributes
@synthesize footerHeight	= _footerHeight;
@synthesize headerHeight	= _headerHeight;

// Data
@synthesize footerTitle	= _footerTitle;
@synthesize headerTitle	= _headerTitle;

// Relationships
@synthesize items	= _items;

// User interface
@synthesize	footerView	= _footerView;
@synthesize	headerView	= _headerView;


#pragma mark Memory management

+ (void)initialize
{
	if(self != [JFTableSection class])
		return;
	
	UITableView* tableView = [UITableView new];
	DefaultFooterHeight = tableView.sectionFooterHeight;
	DefaultHeaderHeight = tableView.sectionHeaderHeight;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_footerHeight = DefaultFooterHeight;
		_headerHeight = DefaultHeaderHeight;
	}
	return self;
}

@end

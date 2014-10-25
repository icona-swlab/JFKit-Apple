//
//  JFMenuItemTableViewCellAttributes.m
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



#import "JFMenuItemTableViewCellAttributes.h"



@implementation JFMenuItemTableViewCellAttributes

#pragma mark - Properties

// Separator
@synthesize bottomSeparatorColor	= _bottomSeparatorColor;
@synthesize bottomSeparatorHeight	= _bottomSeparatorHeight;
@synthesize bottomSeparatorInset	= _bottomSeparatorInset;
@synthesize topSeparatorColor		= _topSeparatorColor;
@synthesize topSeparatorHeight		= _topSeparatorHeight;
@synthesize topSeparatorInset		= _topSeparatorInset;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItemTableViewCellAttributes* retVal = [super copyWithZone:zone];
	if(retVal)
	{
		// Separator
		retVal->_bottomSeparatorColor = _bottomSeparatorColor;
		retVal->_bottomSeparatorHeight = _bottomSeparatorHeight;
		retVal->_bottomSeparatorInset = _bottomSeparatorInset;
		retVal->_topSeparatorColor = _topSeparatorColor;
		retVal->_topSeparatorHeight = _topSeparatorHeight;
		retVal->_topSeparatorInset = _topSeparatorInset;
	}
	return retVal;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Separator
		_bottomSeparatorColor = nil;
		_bottomSeparatorHeight = 0.0f;
		_bottomSeparatorInset = UIEdgeInsetsZero;
		_topSeparatorColor = nil;
		_topSeparatorHeight = 0.0f;
		_topSeparatorInset = UIEdgeInsetsZero;
	}
	return self;
}

@end

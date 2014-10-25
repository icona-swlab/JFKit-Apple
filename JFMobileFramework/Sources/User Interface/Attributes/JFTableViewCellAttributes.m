//
//  JFCellAttributes.m
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



#import "JFTableViewCellAttributes.h"



@implementation JFTableViewCellAttributes

#pragma mark - Properties

// Indentation
@synthesize indentationLevel	= _indentationLevel;
@synthesize indentationWidth	= _indentationWidth;

// Selection
@synthesize selectionStyle	= _selectionStyle;

// Separator
@synthesize separatorInset	= _separatorInset;

// Text
@synthesize detailTextColor				= _detailTextColor;
@synthesize detailTextFont				= _detailTextFont;
@synthesize highlightedDetailTextColor	= _highlightedDetailTextColor;
@synthesize highlightedTextColor		= _highlightedTextColor;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFTableViewCellAttributes* retVal = [super copyWithZone:zone];
	if(retVal)
	{
		// Indentation
		retVal->_indentationLevel = _indentationLevel;
		retVal->_indentationWidth = _indentationWidth;
		
		// Selection
		retVal->_selectionStyle = _selectionStyle;
		
		// Separator
		retVal->_separatorInset = _separatorInset;
		
		// Text
		retVal->_detailTextColor = _detailTextColor;
		retVal->_detailTextFont = _detailTextFont;
		retVal->_highlightedDetailTextColor = _highlightedDetailTextColor;
		retVal->_highlightedTextColor = _highlightedTextColor;
	}
	return retVal;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Indentation
		_indentationLevel = 0;
		_indentationWidth = 0.0f;
		
		// Selection
		_selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Separator
		_separatorInset = UIEdgeInsetsZero;
	}
	return self;
}

@end

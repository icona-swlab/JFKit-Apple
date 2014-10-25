//
//  JFAttributes.m
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



#import "JFViewAttributes.h"



@implementation JFViewAttributes

#pragma mark - Properties

// Background
@synthesize backgroundColor	= _backgroundColor;

// Text
@synthesize textColor	= _textColor;
@synthesize textFont	= _textFont;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFViewAttributes* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Background
		retVal->_backgroundColor = _backgroundColor;
		
		// Text
		retVal->_textColor = _textColor;
		retVal->_textFont = _textFont;
	}
	return retVal;
}

@end

//
//  JFMenuItem.m
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



#import "JFMenuItem.h"



@interface JFMenuItem ()

@end



@implementation JFMenuItem

#pragma mark - Properties

// Attributes
@synthesize attributes	= _attributes;

// Data
@synthesize additionalInfo	= _additionalInfo;
@synthesize backgroundImage	= _backgroundImage;
@synthesize detailText		= _detailText;
@synthesize image			= _image;
@synthesize text			= _text;

// Flags
@synthesize selectionEnabled		= _selectionEnabled;
@synthesize userInteractionEnabled	= _userInteractionEnabled;

// Identity
@synthesize tokenID	= _tokenID;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItem* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Attributes
		retVal->_attributes = _attributes;
		
		// Data
		retVal->_additionalInfo = _additionalInfo;
		retVal->_backgroundImage = _backgroundImage;
		retVal->_detailText = _detailText;
		retVal->_image = _image;
		retVal->_text = _text;
		
		// Flags
		retVal->_selectionEnabled = _selectionEnabled;
		retVal->_userInteractionEnabled = _userInteractionEnabled;
		
		// Identity
		retVal->_tokenID = _tokenID;
	}
	return retVal;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Flags
		_selectionEnabled = YES;
		_userInteractionEnabled = YES;
	}
	return self;
}

@end

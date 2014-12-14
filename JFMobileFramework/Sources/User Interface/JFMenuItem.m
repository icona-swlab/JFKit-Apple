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



@implementation JFMenuItem

#pragma mark - Properties

// Attributes
@synthesize attributes			= _attributes;
@synthesize selectedAttributes	= _selectedAttributes;

// Data
@synthesize additionalInfo	= _additionalInfo;
@synthesize backgroundImage	= _backgroundImage;
@synthesize detailText		= _detailText;
@synthesize image			= _image;
@synthesize selectedImage	= _selectedImage;
@synthesize text			= _text;

// Flags
@synthesize selectionEnabled		= _selectionEnabled;
@synthesize userInteractionEnabled	= _userInteractionEnabled;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItem* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Attributes
		retVal->_attributes = _attributes;
		retVal->_selectedAttributes = _selectedAttributes;
		
		// Data
		retVal->_additionalInfo = _additionalInfo;
		retVal->_backgroundImage = _backgroundImage;
		retVal->_detailText = _detailText;
		retVal->_image = _image;
		retVal->_selectedImage = _selectedImage;
		retVal->_text = _text;
		
		// Flags
		retVal->_selectionEnabled = _selectionEnabled;
		retVal->_userInteractionEnabled = _userInteractionEnabled;
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



@implementation JFMenuItemAttributes

// Background
@synthesize backgroundColor	= _backgroundColor;

// Indentation
@synthesize indentationLevel	= _indentationLevel;
@synthesize indentationWidth	= _indentationWidth;

// Separator
@synthesize separatorColor	= _separatorColor;
@synthesize separatorHeight	= _separatorHeight;

// Spacing
@synthesize backgroundPadding	= _backgroundPadding;
@synthesize contentPadding		= _contentPadding;

// Text
@synthesize detailTextColor	= _detailTextColor;
@synthesize detailTextFont	= _detailTextFont;
@synthesize textColor		= _textColor;
@synthesize textFont		= _textFont;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItemAttributes* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Background
		retVal->_backgroundColor = _backgroundColor;
		
		// Indentation
		retVal->_indentationLevel = _indentationLevel;
		retVal->_indentationWidth = _indentationWidth;
		
		// Separator
		retVal->_separatorColor = _separatorColor;
		retVal->_separatorHeight = _separatorHeight;
		
		// Spacing
		retVal->_backgroundPadding = _backgroundPadding;
		retVal->_contentPadding = _contentPadding;
		
		// Text
		retVal->_detailTextColor = _detailTextColor;
		retVal->_detailTextFont = _detailTextFont;
		retVal->_textColor = _textColor;
		retVal->_textFont = _textFont;
	}
	return retVal;
}

@end

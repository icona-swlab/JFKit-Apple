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

#import "JFUtilities.h"



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
@synthesize text			= _text;

// Flags
@synthesize groupCollapsed								= _groupCollapsed;
@synthesize selectionEnabled							= _selectionEnabled;
@synthesize shouldDisplayAsSelectedIfSubitemIsSelected	= _shouldDisplayAsSelectedIfSubitemIsSelected;
@synthesize userInteractionEnabled						= _userInteractionEnabled;

// Relationships
@synthesize subitems	= _subitems;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItem* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Attributes
		retVal->_attributes			= _attributes;
		retVal->_selectedAttributes	= _selectedAttributes;
		
		// Data
		retVal->_additionalInfo		= _additionalInfo;
		retVal->_backgroundImage	= _backgroundImage;
		retVal->_detailText			= [_detailText copy];
		retVal->_image				= _image;
		retVal->_text				= [_text copy];
		
		// Flags
		retVal->_groupCollapsed								= _groupCollapsed;
		retVal->_selectionEnabled							= _selectionEnabled;
		retVal->_shouldDisplayAsSelectedIfSubitemIsSelected	= _shouldDisplayAsSelectedIfSubitemIsSelected;
		retVal->_userInteractionEnabled						= _userInteractionEnabled;
		
		// Relationships
		retVal->_subitems	= [_subitems copy];
	}
	return retVal;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Flags
		_groupCollapsed = NO;
		_selectionEnabled = YES;
		_shouldDisplayAsSelectedIfSubitemIsSelected = NO;
		_userInteractionEnabled = YES;
	}
	return self;
}


#pragma mark - Flags management

- (BOOL)isGroup
{
	return (self.subitems != nil);
}

@end



@implementation JFMenuItemAttributes

#pragma mark - Properties

// Colors
@synthesize backgroundColor	= _backgroundColor;
@synthesize detailTextColor	= _detailTextColor;
@synthesize textColor		= _textColor;

// Fonts
@synthesize detailTextFont	= _detailTextFont;
@synthesize textFont		= _textFont;

// Indentation
@synthesize indentationLevel	= _indentationLevel;
@synthesize indentationWidth	= _indentationWidth;

// Selection
@synthesize selectionStyle	= _selectionStyle;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFMenuItemAttributes* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Colors
		retVal->_backgroundColor	= _backgroundColor;
		retVal->_detailTextColor	= _detailTextColor;
		retVal->_textColor			= _textColor;
		
		// Fonts
		retVal->_detailTextFont	= _detailTextFont;
		retVal->_textFont		= _textFont;
		
		// Indentation
		retVal->_indentationLevel	= _indentationLevel;
		retVal->_indentationWidth	= _indentationWidth;
		
		// Selection
		retVal->_selectionStyle	= _selectionStyle;
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
		_indentationWidth = 10.0f;
		
		// Selection
		_selectionStyle = (iOS7Plus ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleBlue);
	}
	return self;
}

@end

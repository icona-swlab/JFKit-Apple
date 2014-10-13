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
@synthesize detailTextColor	= _detailTextColor;
@synthesize detailTextFont	= _detailTextFont;
@synthesize textColor		= _textColor;
@synthesize textFont		= _textFont;

// Data
@synthesize backgroundImage	= _backgroundImage;
@synthesize detailText		= _detailText;
@synthesize image			= _image;
@synthesize text			= _text;

@end

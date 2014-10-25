//
//  JFCellAttributes.h
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



@interface JFTableViewCellAttributes : JFViewAttributes

// Indentation
@property (assign, nonatomic)	NSInteger	indentationLevel;
@property (assign, nonatomic)	CGFloat		indentationWidth;

// Selection
@property (assign, nonatomic)	UITableViewCellSelectionStyle	selectionStyle;

// Separator
@property (assign, nonatomic)	UIEdgeInsets	separatorInset;

// Text
@property (strong, nonatomic)	UIColor*	detailTextColor;
@property (strong, nonatomic)	UIFont*		detailTextFont;
@property (strong, nonatomic)	UIColor*	highlightedDetailTextColor;
@property (strong, nonatomic)	UIColor*	highlightedTextColor;


@end

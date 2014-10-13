//
//  JFMenuItem.h
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



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface JFMenuItem : NSObject

// Attributes
@property (strong, nonatomic)	UIColor*	detailTextColor;
@property (strong, nonatomic)	UIFont*		detailTextFont;
@property (strong, nonatomic)	UIColor*	textColor;
@property (strong, nonatomic)	UIFont*		textFont;

// Data
@property (strong, nonatomic)	UIImage*	backgroundImage;
@property (copy, nonatomic)		NSString*	detailText;
@property (strong, nonatomic)	UIImage*	image;
@property (copy, nonatomic)		NSString*	text;

@end

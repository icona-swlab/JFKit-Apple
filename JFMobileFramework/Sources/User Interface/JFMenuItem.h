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



@class JFMenuItemAttributes;



@interface JFMenuItem : NSObject <NSCopying>

// Attributes
@property (strong, nonatomic)	JFMenuItemAttributes*	attributes;
@property (strong, nonatomic)	JFMenuItemAttributes*	selectedAttributes;

// Data
@property (strong, nonatomic)	NSDictionary*	additionalInfo;
@property (strong, nonatomic)	UIImage*		backgroundImage;
@property (copy, nonatomic)		NSString*		detailText;
@property (strong, nonatomic)	UIImage*		image;
@property (strong, nonatomic)	UIImage*		selectedImage;
@property (copy, nonatomic)		NSString*		text;

// Flags
@property (assign, nonatomic)	BOOL selectionEnabled;
@property (assign, nonatomic)	BOOL userInteractionEnabled;

@end



@interface JFMenuItemAttributes : NSObject <NSCopying>

// Background
@property (strong, nonatomic)	UIColor*	backgroundColor;

// Indentation
@property (assign, nonatomic)	NSInteger	indentationLevel;
@property (assign, nonatomic)	CGFloat		indentationWidth;

// Separator
@property (strong, nonatomic)	UIColor*	separatorColor;
@property (assign, nonatomic)	CGFloat		separatorHeight;

// Spacing
@property (assign, nonatomic)	UIEdgeInsets	backgroundPadding;
@property (assign, nonatomic)	UIEdgeInsets	contentPadding;

// Text
@property (strong, nonatomic)	UIColor*	detailTextColor;
@property (strong, nonatomic)	UIFont*		detailTextFont;
@property (strong, nonatomic)	UIColor*	textColor;
@property (strong, nonatomic)	UIFont*		textFont;

@end
//
//  JFSimpleFormViewController.h
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



#import <UIKit/UIKit.h>



// Form cell styles
typedef NS_ENUM(NSUInteger, JFSimpleFormViewCellStyle) {
	JFSimpleFormViewCellStyleField,
	JFSimpleFormViewCellStyleGallery,
	JFSimpleFormViewCellStyleLabel,
	JFSimpleFormViewCellStyleImage,
	JFSimpleFormViewCellStyleText,
};

// Default insets
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsField;
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsGallery;
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsLabel;
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsImage;
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsText;



@interface JFSimpleFormViewController : UITableViewController

// Data
@property (copy, nonatomic)	NSArray*	tableDataInfo;

@end



@interface JFSimpleFormViewCellInfo : NSObject

// Attributes
@property (strong, nonatomic)	UIFont*						font;
@property (assign, nonatomic)	UIEdgeInsets				insets;
@property (assign, nonatomic)	JFSimpleFormViewCellStyle	style;

// Data
@property (strong, nonatomic)	UIImage*	image;
@property (copy, nonatomic)		NSString*	placeholder;
@property (copy, nonatomic)		NSString*	text;
@property (copy, nonatomic)		NSString*	title;

// Memory management
- (instancetype)	initWithStyle:(JFSimpleFormViewCellStyle)style;

@end

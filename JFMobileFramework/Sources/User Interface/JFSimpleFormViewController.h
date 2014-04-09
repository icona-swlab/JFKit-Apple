//
//  JFSimpleFormViewController.h
//  JFMobileFramework
//
//  Created by Jacopo Filié on 07/04/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import <UIKit/UIKit.h>



// Form cell styles
typedef NS_ENUM(NSUInteger, JFSimpleFormViewCellStyle) {
	JFSimpleFormViewCellStyleField,
	JFSimpleFormViewCellStyleLabel,
	JFSimpleFormViewCellStyleImage,
	JFSimpleFormViewCellStyleText,
};

// Default insets
extern UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsField;
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

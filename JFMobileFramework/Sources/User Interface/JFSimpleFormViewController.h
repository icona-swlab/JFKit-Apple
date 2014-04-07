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
extern UIEdgeInsets const fieldInsets;
extern UIEdgeInsets const labelInsets;
extern UIEdgeInsets const imageInsets;
extern UIEdgeInsets const textInsets;



@interface JFSimpleFormViewController : UITableViewController

@end



@interface JFSimpleFormViewCellInfo : NSObject

// Attributes
@property (assign, nonatomic)	UIEdgeInsets				insets;
@property (assign, nonatomic)	JFSimpleFormViewCellStyle	style;

// Data
@property (copy, nonatomic)		NSString*	text;
@property (copy, nonatomic)		NSString*	title;

// Memory management
- (instancetype)	initWithStyle:(JFSimpleFormViewCellStyle)style;

@end

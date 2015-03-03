//
//  JFTableViewCell.h
//  JFFramework
//
//  Created by Jacopo Filié on 03/03/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



@class JFTableViewCell;



#pragma mark - Typedefs

typedef void	(^JFTableViewCellSetupBlock)	(id cell);	// Used to prepare the cell.



#pragma mark



@interface JFTableViewCell : UITableViewCell

#pragma mark Methods

// Memory management
+ (UINib*)		nib;
+ (NSString*)	reuseIdentifier;

// User interface management
+ (CGFloat)	defaultHeight;
+ (CGFloat)	dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock;	// The setup block is called before trying to calculate the height.

@end

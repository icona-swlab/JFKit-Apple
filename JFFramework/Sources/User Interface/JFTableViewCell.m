//
//  JFTableViewCell.m
//  JFFramework
//
//  Created by Jacopo Filié on 03/03/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFTableViewCell.h"

#import "JFUtilities.h"



@interface JFTableViewCell ()

// User interface management
+ (JFTableViewCell*)	sizingCell;

@end



#pragma mark



@implementation JFTableViewCell

#pragma mark Memory management

+ (UINib*)nib
{
	return [UINib nibWithNibName:ClassName bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return ClassName;
}


#pragma mark User interface management

+ (CGFloat)defaultHeight
{
	return 44.0f;
}

+ (CGFloat)dynamicHeightForWidth:(CGFloat)width setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	JFTableViewCell* cell = [self sizingCell];
	if(!cell)
		return [self defaultHeight];
	
	if(setupBlock)
		setupBlock(cell);
	
	CGRect frame = cell.frame;
	frame.size.width = width;
	cell.frame = frame;
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	CGFloat calculatedHeight = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	CGFloat defaultHeight = [self defaultHeight];
	
	return MAX(calculatedHeight, defaultHeight);
}

+ (JFTableViewCell*)sizingCell
{
	static NSMutableDictionary* sizingCells = nil;
	static dispatch_once_t token = 0;
	
	dispatch_once(&token, ^{
		sizingCells = [NSMutableDictionary new];
	});
	
	NSString* key = ClassName;
	
	JFTableViewCell* retVal = [sizingCells objectForKey:key];
	if(!retVal)
	{
		retVal = [[[self nib] instantiateWithOwner:self options:nil] firstObject];
		if(retVal)
			[sizingCells setObject:retVal forKey:key];
	}
	
	return retVal;
}

@end

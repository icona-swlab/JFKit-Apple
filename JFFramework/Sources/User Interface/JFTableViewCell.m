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

#pragma mark Properties

// Flags
@property (assign, nonatomic, getter = isUserInterfaceInitialized)	BOOL	userInterfaceInitialized;

// User interface management
+ (JFTableViewCell*)	sizingCell;

@end



#pragma mark



@implementation JFTableViewCell

#pragma mark Properties

// Flags
@synthesize userInterfaceInitialized	= _userInterfaceInitialized;


#pragma mark Memory management

+ (UINib*)nib
{
	return [UINib nibWithNibName:ClassName bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return ClassName;
}

- (void)initializeProperties
{
	// Flags
	_userInterfaceInitialized = NO;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}


#pragma mark User interface management

+ (CGFloat)defaultHeight
{
	return [self minimumHeight];
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
	
	UIView* view = (iOS8Plus ? cell : cell.contentView);
	CGSize calculatedSize = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	
	CGFloat retVal = MAX(calculatedSize.height, [self minimumHeight]);
	retVal = MIN(retVal, [self maximumHeight]);
	
	return retVal;
}

+ (CGFloat)maximumHeight
{
	return CGFLOAT_MAX;
}

+ (CGFloat)minimumHeight
{
	return 44.0f;
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

- (void)initializeUserInterface
{}


#pragma mark User interface management (View lifecycle)

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	if(![self isUserInterfaceInitialized])
	{
		[self initializeUserInterface];
		self.userInterfaceInitialized = YES;
	}
}

@end

//
//  JFTableViewCell.m
//  Copyright (C) 2015  Jacopo Filié
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

+ (CGFloat)dynamicHeightForTableView:(UITableView*)tableView setupBlock:(JFTableViewCellSetupBlock)setupBlock
{
	CGFloat width = CGRectGetWidth(tableView.bounds);
	
	if((tableView.style == UITableViewStyleGrouped) && !iOS7Plus)
	{
		CGFloat margin = 0.0f;
		
		if(iPhone)				margin = 10.0f;
		else if(width <= 20.0f)	margin = width - 10.0f;
		else if(width < 400.0f)	margin = 10.0f;
		else					margin = MAX(31.0f, MIN(45.0f, width * 0.06f));
		
		width -= MAX(margin, 0.0f) * 2.0f;
	}
	
	CGFloat retVal = [self dynamicHeightForWidth:width setupBlock:setupBlock];
	
	if(tableView.separatorStyle != UITableViewCellSeparatorStyleNone)
		retVal++;
	
	return retVal;
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

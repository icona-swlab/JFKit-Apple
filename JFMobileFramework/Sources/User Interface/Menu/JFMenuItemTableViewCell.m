//
//  JFMenuItemCell.m
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



#import "JFMenuItemTableViewCell.h"



@interface JFMenuItemTableViewCell ()

// Attributes
@property (assign, nonatomic)	NSInteger	indentationLevel;
@property (assign, nonatomic)	CGFloat		indentationWidth;

// Constraints
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	bottomSeparatorBottomConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	bottomSeparatorHeightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	bottomSeparatorLeftConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	bottomSeparatorRightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	bottomSeparatorTopConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	indentationConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	topSeparatorBottomConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	topSeparatorHeightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	topSeparatorLeftConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	topSeparatorRightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	topSeparatorTopConstraint;

// User interface
@property (strong, nonatomic)	IBOutlet	UIView*			cellBottomSeparator;
@property (strong, nonatomic)	IBOutlet	UIImageView*	cellImageView;
@property (strong, nonatomic)	IBOutlet	UILabel*		cellTextLabel;
@property (strong, nonatomic)	IBOutlet	UIView*			cellTopSeparator;

// Memory management
- (void)	commonInit;

// Constraints management
- (void)	updateBottomSeparatorContraints;
- (void)	updateIndentationContraint;
- (void)	updateTopSeparatorContraints;

@end



@implementation JFMenuItemTableViewCell

#pragma mark - Properties

// Attributes
@synthesize bottomSeparatorColor	= _bottomSeparatorColor;
@synthesize bottomSeparatorHeight	= _bottomSeparatorHeight;
@synthesize bottomSeparatorInset	= _bottomSeparatorInset;
@synthesize indentationLevel		= _indentationLevel;
@synthesize indentationWidth		= _indentationWidth;
@synthesize topSeparatorColor		= _topSeparatorColor;
@synthesize topSeparatorHeight		= _topSeparatorHeight;
@synthesize topSeparatorInset		= _topSeparatorInset;

// Constraints
@synthesize bottomSeparatorBottomConstraint	= _bottomSeparatorBottomConstraint;
@synthesize bottomSeparatorHeightConstraint	= _bottomSeparatorHeightConstraint;
@synthesize bottomSeparatorLeftConstraint	= _bottomSeparatorLeftConstraint;
@synthesize bottomSeparatorRightConstraint	= _bottomSeparatorRightConstraint;
@synthesize bottomSeparatorTopConstraint	= _bottomSeparatorTopConstraint;
@synthesize indentationConstraint			= _indentationConstraint;
@synthesize topSeparatorBottomConstraint	= _topSeparatorBottomConstraint;
@synthesize topSeparatorHeightConstraint	= _topSeparatorHeightConstraint;
@synthesize topSeparatorLeftConstraint		= _topSeparatorLeftConstraint;
@synthesize topSeparatorRightConstraint		= _topSeparatorRightConstraint;
@synthesize topSeparatorTopConstraint		= _topSeparatorTopConstraint;

// User interface
@synthesize cellBottomSeparator	= _cellBottomSeparator;
@synthesize cellImageView		= _cellImageView;
@synthesize cellTextLabel		= _cellTextLabel;
@synthesize cellTopSeparator	= _cellTopSeparator;


#pragma mark - Properties accessors (Inherited)

- (UIImageView*)imageView
{
	return self.cellImageView;
}

- (void)setIndentationLevel:(NSInteger)indentationLevel
{
	if(_indentationLevel == indentationLevel)
		return;
	
	_indentationLevel = indentationLevel;
	
	[self updateIndentationContraint];
}

- (void)setIndentationWidth:(CGFloat)indentationWidth
{
	if(_indentationWidth == indentationWidth)
		return;
	
	_indentationWidth = indentationWidth;
	
	[self updateIndentationContraint];
}

- (UILabel*)textLabel
{
	return self.cellTextLabel;
}


#pragma mark - Properties accessors (Attributes)

- (void)setBottomSeparatorColor:(UIColor*)bottomSeparatorColor
{
	if(_bottomSeparatorColor == bottomSeparatorColor)
		return;
	
	_bottomSeparatorColor = bottomSeparatorColor;
	
	self.cellBottomSeparator.backgroundColor = _bottomSeparatorColor;
}

- (void)setBottomSeparatorHeight:(CGFloat)bottomSeparatorHeight
{
	if(_bottomSeparatorHeight == bottomSeparatorHeight)
		return;
	
	_bottomSeparatorHeight = bottomSeparatorHeight;
	
	[self updateBottomSeparatorContraints];
}

- (void)setBottomSeparatorInset:(UIEdgeInsets)bottomSeparatorInset
{
	if(UIEdgeInsetsEqualToEdgeInsets(_bottomSeparatorInset, bottomSeparatorInset))
		return;
	
	_bottomSeparatorInset = bottomSeparatorInset;
	
	[self updateBottomSeparatorContraints];
}

- (void)setTopSeparatorColor:(UIColor*)topSeparatorColor
{
	if(_topSeparatorColor == topSeparatorColor)
		return;
	
	_topSeparatorColor = topSeparatorColor;
	
	self.cellTopSeparator.backgroundColor = _topSeparatorColor;
}

- (void)setTopSeparatorHeight:(CGFloat)topSeparatorHeight
{
	if(_topSeparatorHeight == topSeparatorHeight)
		return;
	
	_topSeparatorHeight = topSeparatorHeight;
	
	[self updateTopSeparatorContraints];
}

- (void)setTopSeparatorInset:(UIEdgeInsets)topSeparatorInset
{
	if(UIEdgeInsetsEqualToEdgeInsets(_topSeparatorInset, topSeparatorInset))
		return;
	
	topSeparatorInset = topSeparatorInset;
	
	[self updateTopSeparatorContraints];
}


#pragma mark - Memory management

+ (UINib*)nib
{
	return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (NSString*)reuseIdentifier
{
	return NSStringFromClass(self);
}

- (void)commonInit
{
	// Attributes
	_bottomSeparatorColor	= [UIColor lightGrayColor];
	_bottomSeparatorHeight	= 1.0f;
	_bottomSeparatorInset	= UIEdgeInsetsZero;
	_indentationLevel		= 0;
	_indentationWidth		= 10.0f;
	_topSeparatorColor		= nil;
	_topSeparatorHeight		= 0.0f;
	_topSeparatorInset		= UIEdgeInsetsZero;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self)
	{
		[self commonInit];
	}
	return self;
}


#pragma mark - User interface management

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.cellBottomSeparator.backgroundColor = self.bottomSeparatorColor;
	self.cellTopSeparator.backgroundColor = self.topSeparatorColor;
	
	[self updateBottomSeparatorContraints];
	[self updateIndentationContraint];
	[self updateTopSeparatorContraints];
}


#pragma mark - Constraints management

- (void)updateBottomSeparatorContraints
{
	self.bottomSeparatorHeightConstraint.constant = self.bottomSeparatorHeight;
	
	UIEdgeInsets separatorInset = self.bottomSeparatorInset;
	self.bottomSeparatorBottomConstraint.constant = separatorInset.bottom;
	self.bottomSeparatorLeftConstraint.constant = separatorInset.left;
	self.bottomSeparatorRightConstraint.constant = separatorInset.right;
	self.bottomSeparatorTopConstraint.constant = separatorInset.top;
}

- (void)updateIndentationContraint
{
	self.indentationConstraint.constant = self.indentationLevel * self.indentationWidth;
}

- (void)updateTopSeparatorContraints
{
	self.topSeparatorHeightConstraint.constant = self.topSeparatorHeight;
	
	UIEdgeInsets separatorInset = self.topSeparatorInset;
	self.topSeparatorBottomConstraint.constant = separatorInset.bottom;
	self.topSeparatorLeftConstraint.constant = separatorInset.left;
	self.topSeparatorRightConstraint.constant = separatorInset.right;
	self.topSeparatorTopConstraint.constant = separatorInset.top;
}

@end

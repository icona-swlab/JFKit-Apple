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

#import "JFUtilities.h"



@interface JFMenuItemTableViewCell ()

// Constraints
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	backgroundPaddingBottomConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	backgroundPaddingLeftConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	backgroundPaddingRightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	backgroundPaddingTopConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	contentPaddingBottomConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	contentPaddingLeftConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	contentPaddingRightConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	contentPaddingTopConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	indentationConstraint;
@property (strong, nonatomic)	IBOutlet	NSLayoutConstraint*	separatorHeightConstraint;

// User interface
@property (strong, nonatomic)	IBOutlet	UIImageView*	cellBackgroundImageView;
@property (strong, nonatomic)	IBOutlet	UILabel*		cellDetailTextLabel;
@property (strong, nonatomic)	IBOutlet	UIImageView*	cellImageView;
@property (strong, nonatomic)	IBOutlet	UIView*			cellSeparator;
@property (strong, nonatomic)	IBOutlet	UILabel*		cellTextLabel;

// Memory management
- (void)	commonInit;

// Constraints management
- (void)	updateBackgroundPaddingConstraints;
- (void)	updateContentPaddingConstraints;
- (void)	updateIndentationConstraints;
- (void)	updateSeparatorConstraints;

@end



@implementation JFMenuItemTableViewCell

#pragma mark - Properties

// Attributes
@synthesize backgroundPadding	= _backgroundPadding;
@synthesize contentPadding		= _contentPadding;
@synthesize separatorColor		= _separatorColor;
@synthesize separatorHeight		= _separatorHeight;

// Constraints
@synthesize backgroundPaddingBottomConstraint	= _backgroundPaddingBottomConstraint;
@synthesize backgroundPaddingLeftConstraint		= _backgroundPaddingLeftConstraint;
@synthesize backgroundPaddingRightConstraint	= _backgroundPaddingRightConstraint;
@synthesize backgroundPaddingTopConstraint		= _backgroundPaddingTopConstraint;
@synthesize contentPaddingBottomConstraint		= _contentPaddingBottomConstraint;
@synthesize contentPaddingLeftConstraint		= _contentPaddingLeftConstraint;
@synthesize contentPaddingRightConstraint		= _contentPaddingRightConstraint;
@synthesize contentPaddingTopConstraint			= _contentPaddingTopConstraint;
@synthesize indentationConstraint				= _indentationConstraint;
@synthesize separatorHeightConstraint			= _separatorHeightConstraint;

// Data
@synthesize backgroundImage	= _backgroundImage;

// User interface
@synthesize cellBackgroundImageView	= _cellBackgroundImageView;
@synthesize cellDetailTextLabel		= _cellDetailTextLabel;
@synthesize cellImageView			= _cellImageView;
@synthesize cellSeparator			= _cellSeparator;
@synthesize cellTextLabel			= _cellTextLabel;


#pragma mark - Properties accessors (Attributes)

- (void)setBackgroundPadding:(UIEdgeInsets)backgroundInsets
{
	if(UIEdgeInsetsEqualToEdgeInsets(_backgroundPadding, backgroundInsets))
		return;
	
	_backgroundPadding = backgroundInsets;
	
	[self setNeedsUpdateConstraints];
}

- (void)setContentPadding:(UIEdgeInsets)contentInsets
{
	if(UIEdgeInsetsEqualToEdgeInsets(_contentPadding, contentInsets))
		return;
	
	_contentPadding = contentInsets;
	
	[self setNeedsUpdateConstraints];
}

- (void)setSeparatorColor:(UIColor*)separatorColor
{
	if(AreColorsEqual(_separatorColor, separatorColor))
		return;
	
	_separatorColor = separatorColor;
	
	self.cellSeparator.backgroundColor = _separatorColor;
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight
{
	if(_separatorHeight == separatorHeight)
		return;
	
	_separatorHeight = separatorHeight;
	
	[self setNeedsUpdateConstraints];
}


#pragma mark - Properties accessors (Data)

- (void)setBackgroundImage:(UIImage*)backgroundImage
{
	if(_backgroundImage == backgroundImage)
		return;
	
	_backgroundImage = backgroundImage;
	
	self.cellBackgroundImageView.hidden = (_backgroundImage == nil);
	self.cellBackgroundImageView.image = _backgroundImage;
}


#pragma mark - Properties accessors (Inherited)

- (UILabel*)detailTextLabel
{
	return self.cellDetailTextLabel;
}

- (UIImageView*)imageView
{
	return self.cellImageView;
}

- (void)setIndentationLevel:(NSInteger)indentationLevel
{
	[super setIndentationLevel:indentationLevel];
	[self setNeedsUpdateConstraints];
}

- (void)setIndentationWidth:(CGFloat)indentationWidth
{
	[super setIndentationWidth:indentationWidth];
	[self setNeedsUpdateConstraints];
}

- (UILabel*)textLabel
{
	return self.cellTextLabel;
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
	_backgroundPadding = UIEdgeInsetsZero;
	_contentPadding = UIEdgeInsetsMake(5.0f, 15.0f, 4.0f, 15.0f);
	_separatorColor = [UIColor lightGrayColor];
	_separatorHeight = 1.0f;
	
	// Inherited
	self.selectionStyle = UITableViewCellSelectionStyleNone;
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

+ (CGFloat)height
{
	return 44.0f;
}

- (void)updateConstraints
{
	[super updateConstraints];
	[self updateBackgroundPaddingConstraints];
	[self updateContentPaddingConstraints];
	[self updateIndentationConstraints];
	[self updateSeparatorConstraints];
}


#pragma mark - Constraints management

- (void)updateBackgroundPaddingConstraints
{
	UIEdgeInsets insets = self.backgroundPadding;
	self.backgroundPaddingBottomConstraint.constant = insets.bottom;
	self.backgroundPaddingLeftConstraint.constant = insets.left;
	self.backgroundPaddingRightConstraint.constant = insets.right;
	self.backgroundPaddingTopConstraint.constant = insets.top;
}

- (void)updateContentPaddingConstraints
{
	UIEdgeInsets insets = self.contentPadding;
	self.contentPaddingBottomConstraint.constant = insets.bottom;
	self.contentPaddingLeftConstraint.constant = insets.left;
	self.contentPaddingRightConstraint.constant = insets.right;
	self.contentPaddingTopConstraint.constant = insets.top;
}

- (void)updateIndentationConstraints
{
	self.indentationConstraint.constant = self.indentationLevel * self.indentationWidth;
}

- (void)updateSeparatorConstraints
{
	self.separatorHeightConstraint.constant = self.separatorHeight;
}

@end

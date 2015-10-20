//
//  JFRatingView.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFRatingView.h"

#import "JFUtilities.h"



@interface JFRatingView ()

#pragma mark Properties

// Constraints
@property (strong, nonatomic, readonly)	NSMutableArray<NSLayoutConstraint*>*	addedConstraints;
@property (strong, nonatomic, readonly)	NSMutableArray<NSLayoutConstraint*>*	containerViewAddedConstraints;

// Flags
@property (assign, nonatomic, getter = isUserInterfaceInitialized)	BOOL	userInterfaceInitialized;

// User interface
@property (strong, nonatomic)			UIView*							containerView;
@property (strong, nonatomic, readonly)	NSMutableArray<UIImageView*>*	imageViews;


#pragma mark Methods

// User interface management
- (UIImage*)	imageForViewAtIndex:(NSUInteger)index;
- (void)		reloadRatingImages;
- (void)		updateComponentsVisibility;

@end



#pragma mark



@implementation JFRatingView

#pragma mark Properties

// Attributes
@synthesize maximumValue	= _maximumValue;
@synthesize minimumValue	= _minimumValue;

// Attributes (Images)
@synthesize contentInsets		= _contentInsets;
@synthesize imageContentMode	= _imageContentMode;
@synthesize imageMaximumSize	= _imageMaximumSize;
@synthesize imageMinimumSize	= _imageMinimumSize;
@synthesize imagesDistance		= _imagesDistance;
@synthesize numberOfImages		= _numberOfImages;

// Constraints
@synthesize addedConstraints				= _addedConstraints;
@synthesize containerViewAddedConstraints	= _containerViewAddedConstraints;

// Data
@synthesize value	= _value;

// Data (Images)
@synthesize emptyImage	= _emptyImage;
@synthesize fullImage	= _fullImage;
@synthesize halfImage	= _halfImage;

// Flags
@synthesize editable					= _editable;
@synthesize userInterfaceInitialized	= _userInterfaceInitialized;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize containerView	= _containerView;
@synthesize imageViews		= _imageViews;


#pragma mark Properties accessors (Attributes)

- (void)setMaximumValue:(CGFloat)maximumValue
{
	if(_maximumValue == maximumValue)
		return;
	
	_maximumValue = maximumValue;
	
	if(self.value > maximumValue)
		self.value = maximumValue;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
	if(_minimumValue == minimumValue)
		return;
	
	_minimumValue = minimumValue;
	
	if(self.value < minimumValue)
		self.value = minimumValue;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}


#pragma mark Properties accessors (Attributes - Images)

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
	if(UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets))
		return;
	
	_contentInsets = contentInsets;
	
	if([self isUserInterfaceInitialized])
		[self setNeedsUpdateConstraints];
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
	if(_imageContentMode == imageContentMode)
		return;
	
	_imageContentMode = imageContentMode;
	
	if([self isUserInterfaceInitialized])
	{
		for(UIImageView* imageView in self.imageViews)
			imageView.contentMode = imageContentMode;
	}
}

- (void)setImageMaximumSize:(CGSize)imageMaximumSize
{
	if(CGSizeEqualToSize(_imageMaximumSize, imageMaximumSize))
		return;
	
	_imageMaximumSize = imageMaximumSize;
	
	if([self isUserInterfaceInitialized])
		[self setNeedsUpdateConstraints];
}

- (void)setImageMinimumSize:(CGSize)imageMinimumSize
{
	if(CGSizeEqualToSize(_imageMinimumSize, imageMinimumSize))
		return;
	
	_imageMinimumSize = imageMinimumSize;
	
	if([self isUserInterfaceInitialized])
		[self setNeedsUpdateConstraints];
}

- (void)setImagesDistance:(CGFloat)imagesDistance
{
	if(_imagesDistance == imagesDistance)
		return;
	
	_imagesDistance = imagesDistance;
	
	if([self isUserInterfaceInitialized])
		[self setNeedsUpdateConstraints];
}

- (void)setNumberOfImages:(NSUInteger)numberOfImages
{
	if(_numberOfImages == numberOfImages)
		return;
	
	_numberOfImages = numberOfImages;
	
	if([self isUserInterfaceInitialized])
		[self updateComponentsVisibility];
}


#pragma mark Properties accessors (Data)

- (void)setValue:(CGFloat)value
{
	value = MAX(value, self.minimumValue);
	value = MIN(value, self.maximumValue);
	
	if(_value == value)
		return;
	
	_value = value;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}


#pragma mark Properties accessors (Data - Images)

- (void)setEmptyImage:(UIImage*)emptyImage
{
	if(JFAreObjectsEqual(_emptyImage, emptyImage))
		return;
	
	_emptyImage = emptyImage;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}

- (void)setFullImage:(UIImage*)fullImage
{
	if(JFAreObjectsEqual(_fullImage, fullImage))
		return;
	
	_fullImage = fullImage;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}

- (void)setHalfImage:(UIImage*)halfImage
{
	if(JFAreObjectsEqual(_halfImage, halfImage))
		return;
	
	_halfImage = halfImage;
	
	if([self isUserInterfaceInitialized])
		[self reloadRatingImages];
}


#pragma mark Properties accessors (Flags)

- (BOOL)allowsHalfRatings
{
	return (self.halfImage != nil);
}


#pragma mark Memory management

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		// Attributes
		_maximumValue	= 5.0;
		_minimumValue	= 0.0;
		
		// Attributes (Images)
		_contentInsets		= UIEdgeInsetsZero;
		_imageContentMode	= UIViewContentModeScaleAspectFit;
		_imageMaximumSize	= CGSizeZero;
		_imageMinimumSize	= CGSizeZero;
		_imagesDistance		= 0.0;
		_numberOfImages		= 5;
		
		// Constraints
		_addedConstraints				= [NSMutableArray<NSLayoutConstraint*> new];
		_containerViewAddedConstraints	= [NSMutableArray<NSLayoutConstraint*> new];
		
		// Data
		_value	= 0.0;
		
		// Flags
		_editable					= YES;
		_userInterfaceInitialized	= NO;
		
		// User interface
		_imageViews	= [NSMutableArray<UIImageView*> new];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		// Attributes
		_maximumValue	= 5.0;
		_minimumValue	= 0.0;
		
		// Attributes (Images)
		_contentInsets		= UIEdgeInsetsZero;
		_imageContentMode	= UIViewContentModeScaleAspectFit;
		_imageMaximumSize	= CGSizeZero;
		_imageMinimumSize	= CGSizeZero;
		_imagesDistance		= 0.0;
		_numberOfImages		= 5;
		
		// Constraints
		_addedConstraints				= [NSMutableArray<NSLayoutConstraint*> new];
		_containerViewAddedConstraints	= [NSMutableArray<NSLayoutConstraint*> new];
		
		// Data
		_value	= 0.0;
		
		// Flags
		_editable					= YES;
		_userInterfaceInitialized	= NO;
		
		// User interface
		_imageViews	= [NSMutableArray<UIImageView*> new];
	}
	return self;
}


#pragma mark User interface management

- (UIImage*)imageForViewAtIndex:(NSUInteger)index
{
	//CGFloat value = self.value;
	//CGFloat step = (self.maximumValue / (CGFloat)self.numberOfImages);
	//CGFloat indexValue = ((CGFloat)index * step);
	
	return self.fullImage;
}

- (void)initializeUserInterface
{
	//self.contentInsets	= UIEdgeInsetsMake(10, 10, 10, 10);
	//self.imagesDistance	= 10.0f;
	
	// Prepares the container view.
	UIView* containerView = [UIView new];
	containerView.backgroundColor = [UIColor magentaColor];
	containerView.opaque = NO;
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:containerView];
	self.containerView = containerView;
	
	[self updateComponentsVisibility];
}

- (void)reloadRatingImages
{
	for(NSUInteger i = 0; i < [self.imageViews count]; i++)
	{
		UIImageView* imageView = [self.imageViews objectAtIndex:i];
		imageView.image = [self imageForViewAtIndex:i];
	}
}

- (void)updateComponentsVisibility
{
	NSMutableArray<UIImageView*>* imageViews = self.imageViews;
	NSUInteger numberOfImages = self.numberOfImages;
	UIView* containerView = self.containerView;
	UIViewContentMode contentMode = self.imageContentMode;
	
	if(numberOfImages != [imageViews count])
	{
		for(UIView* view in imageViews)
			[view removeFromSuperview];
		
		[imageViews removeAllObjects];
		
		for(NSUInteger i = 0; i < numberOfImages; i++)
		{
			UIImageView* imageView = [UIImageView new];
			imageView.contentMode = contentMode;
			imageView.translatesAutoresizingMaskIntoConstraints = NO;
			[containerView addSubview:imageView];
			[imageViews addObject:imageView];
		}
		
		[self reloadRatingImages];
	}
	
	[self setNeedsUpdateConstraints];
}


#pragma mark User interface management (Constraints)

- (void)updateConstraints
{
	if([self isUserInterfaceInitialized])
	{
		UIView* containerView = self.containerView;
		NSArray<UIImageView*>* imageViews = self.imageViews;
		NSUInteger numberOfImages = self.numberOfImages;
		CGFloat imagesDistance = self.imagesDistance;
		
		// Removes the old constraints.
		[self removeConstraints:self.addedConstraints];
		[containerView removeConstraints:self.containerViewAddedConstraints];
		
		// Prepares some constraint shortcuts.
		__unused NSLayoutAttribute ab = NSLayoutAttributeBottom;
		__unused NSLayoutAttribute al = NSLayoutAttributeLeft;
		__unused NSLayoutAttribute ar = NSLayoutAttributeRight;
		__unused NSLayoutAttribute at = NSLayoutAttributeTop;
		__unused NSLayoutAttribute ah = NSLayoutAttributeHeight;
		__unused NSLayoutAttribute aw = NSLayoutAttributeWidth;
		__unused NSLayoutAttribute an = NSLayoutAttributeNotAnAttribute;
		__unused NSLayoutAttribute ax = NSLayoutAttributeCenterX;
		__unused NSLayoutAttribute ay = NSLayoutAttributeCenterY;
		__unused NSLayoutRelation re = NSLayoutRelationEqual;
		__unused NSLayoutRelation rg = NSLayoutRelationGreaterThanOrEqual;
		__unused NSLayoutRelation rl = NSLayoutRelationLessThanOrEqual;
		
		UIEdgeInsets insets = self.contentInsets;
		
		// Creates the container view constraints.
		UIView* v1 = containerView;
		UIView* v2 = self;
		
		NSMutableArray* constraints = [NSMutableArray array];
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:at multiplier:1.0f constant:insets.top]];		// Top
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:-insets.bottom]];	// Bottom
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:re toItem:v2 attribute:al multiplier:1.0f constant:insets.left]];		// Left
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v2 attribute:ar multiplier:1.0f constant:-insets.right]];	// Right
		for(NSLayoutConstraint* constraint in constraints)
			constraint.priority = UILayoutPriorityDefaultHigh;
		[self addConstraints:constraints];
		[self.addedConstraints setArray:constraints];
		[constraints removeAllObjects];
		
		// Creates the indicator view constraints.
		v2 = containerView;
		for(NSUInteger i = 0; i < numberOfImages; i++)
		{
			v1 = [imageViews objectAtIndex:i];
			
			BOOL isFirstImageView = (i == 0);
			BOOL isLastImageView = (i == (numberOfImages - 1));
			
			if(isFirstImageView)
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:re toItem:v2 attribute:al multiplier:1.0f constant:0.0f]];	// Left
			
			if(isLastImageView)
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v2 attribute:ar multiplier:1.0f constant:0.0f]];	// Right
			else
			{
				UIView* v3 = [imageViews objectAtIndex:(i + 1)];
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v3 attribute:al multiplier:1.0f constant:-imagesDistance]];	// Between
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:re toItem:v3 attribute:aw multiplier:1.0f constant:0.0f]];				// Equal Width
			}
			
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:at multiplier:1.0f constant:0.0f]];		// Top
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:0.0f]];		// Bottom
			
			[containerView addConstraints:constraints];
			[self.containerViewAddedConstraints setArray:constraints];
			[constraints removeAllObjects];
		}
	}
	
	[super updateConstraints];
}


#pragma mark User interface management (Lifecycle)

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

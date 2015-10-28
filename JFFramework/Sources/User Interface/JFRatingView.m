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

// Attributes
@property (assign, nonatomic, readonly)	CGFloat	valueUnit;

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

- (CGFloat)valueUnit
{
	return (self.maximumValue / (CGFloat)self.numberOfImages);
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
		_value	= 2.5;
		
		// Flags
		_editable					= YES;
		_userInterfaceInitialized	= NO;
		
		// User interface
		_imageViews	= [NSMutableArray<UIImageView*> new];
	}
	return self;
}


#pragma mark Responder management

- (void)handleTouch:(UITouch*)touch
{
	UIView* view = self.containerView;
	
	CGFloat location = [touch locationInView:view].x;
	
	CGFloat width = CGRectGetWidth(view.bounds);
	
	BOOL allowsHalfRatings = [self allowsHalfRatings];
	CGFloat multiplier = (allowsHalfRatings ? 2 : 1);
	
	NSUInteger numberOfSlices = self.numberOfImages * multiplier;
	CGFloat slice = width / (CGFloat)numberOfSlices;
	CGFloat marginSlice = slice / 2.0;
	
	CGFloat value = 0.0f;
	if(location <= marginSlice)
		value = 0.0f;
	else if(location > (width - marginSlice))
		value = self.maximumValue;
	else
	{
		CGFloat valueUnit = (self.valueUnit / multiplier);
		
		for(NSUInteger i = 0; i < numberOfSlices; i++)
		{
			CGFloat currentSlice = (i * slice);
			CGFloat nextSlice = currentSlice + slice;
			
			BOOL isGreaterThanCurrentSlice = (location > currentSlice);
			BOOL isSmallerThanOrEqualToNextSlice = (location <= nextSlice);
			
			if(isGreaterThanCurrentSlice && isSmallerThanOrEqualToNextSlice)
			{
				value = (valueUnit * (CGFloat)(i + 1));
				break;
			}
		}
	}
	
	self.value = MAX(self.minimumValue, value);
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(nullable UIEvent*)event
{
	if([self isEditable])
		[self handleTouch:[touches anyObject]];
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(nullable UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
	
	[self.delegate ratingView:self didChangeValue:self.value];
}

- (void)touchesMoved:(NSSet<UITouch*>*)touches withEvent:(nullable UIEvent*)event
{
	if([self isEditable])
		[self handleTouch:[touches anyObject]];
	
	[super touchesMoved:touches withEvent:event];
}


#pragma mark User interface management

- (UIImage*)imageForViewAtIndex:(NSUInteger)index
{
	CGFloat value = self.value;
	CGFloat valueUnit = self.valueUnit;
	
	CGFloat indexValue = valueUnit * index;
	
	UIImage* retObj = nil;
	
	if(value >= indexValue + valueUnit)	retObj = self.fullImage;
	else if(value > indexValue)			retObj = self.halfImage;
	else								retObj = self.emptyImage;
	
	return retObj;
}

- (void)initializeUserInterface
{
	// Prepares the container view.
	UIView* containerView = [UIView new];
	containerView.backgroundColor = [UIColor cyanColor];
	containerView.opaque = NO;
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:containerView];
	self.containerView = containerView;
	
	[self updateComponentsVisibility];
}

- (void)reloadRatingImages
{
	NSArray* imageViews = self.imageViews;
	for(NSUInteger i = 0; i < [imageViews count]; i++)
	{
		UIImageView* imageView = [imageViews objectAtIndex:i];
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
		NSMutableArray* constraints = [NSMutableArray array];
		UIView* containerView = self.containerView;
		NSArray<UIImageView*>* imageViews = self.imageViews;
		NSUInteger numberOfImages = self.numberOfImages;
		CGFloat imagesDistance = self.imagesDistance;
		CGSize maxSize = self.imageMaximumSize;
		CGSize minSize = self.imageMinimumSize;
		UIEdgeInsets insets = self.contentInsets;
		
		BOOL shouldApplyMaxSizeConstraints = !CGSizeEqualToSize(maxSize, CGSizeZero);
		BOOL shouldApplyMinSizeConstraints = !CGSizeEqualToSize(minSize, CGSizeZero);
		
		// Removes the old constraints.
		[self removeConstraints:self.addedConstraints];
		[containerView removeConstraints:self.containerViewAddedConstraints];
		[self.addedConstraints removeAllObjects];
		[self.containerViewAddedConstraints removeAllObjects];
		
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
		
		// Prepares the views.
		UIView* v1 = containerView;
		UIView* v2 = self;
		
		// Adds the constraints that try to keep the insets with the desired dimensions.
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:at multiplier:1.0f constant:insets.top]];		// Top
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:-insets.bottom]];	// Bottom
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:re toItem:v2 attribute:al multiplier:1.0f constant:insets.left]];		// Left
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v2 attribute:ar multiplier:1.0f constant:-insets.right]];		// Right
		for(NSLayoutConstraint* constraint in constraints)
			constraint.priority = UILayoutPriorityDefaultLow;
		[self addConstraints:constraints];
		[self.addedConstraints addObjectsFromArray:constraints];
		[constraints removeAllObjects];
		
		// Adds the constraints the forces the container view to stay at least at the desired distances from the bounds of the superview.
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:rg toItem:v2 attribute:at multiplier:1.0f constant:insets.top]];		// Top
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:rl toItem:v2 attribute:ab multiplier:1.0f constant:-insets.bottom]];	// Bottom
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:rg toItem:v2 attribute:al multiplier:1.0f constant:insets.left]];		// Left
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:rl toItem:v2 attribute:ar multiplier:1.0f constant:-insets.right]];		// Right
		for(NSLayoutConstraint* constraint in constraints)
			constraint.priority = UILayoutPriorityDefaultHigh;
		[self addConstraints:constraints];
		[self.addedConstraints addObjectsFromArray:constraints];
		[constraints removeAllObjects];
		
		// Forces the container view to mantain its height in a range.
		if(shouldApplyMaxSizeConstraints)
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ah relatedBy:rl toItem:nil attribute:an multiplier:1.0f constant:maxSize.height]];	// Max height
		if(shouldApplyMinSizeConstraints)
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ah relatedBy:rg toItem:nil attribute:an multiplier:1.0f constant:minSize.height]];	// Min height
		
		// Forces the container view to stay in the center of the superview.
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]];	// Center X
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]];	// Center Y
		[self addConstraints:constraints];
		[self.addedConstraints addObjectsFromArray:constraints];
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
			
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:at multiplier:1.0f constant:0.0f]];		// Top
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:0.0f]];		// Bottom
			
			if(isLastImageView)
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v2 attribute:ar multiplier:1.0f constant:0.0f]];	// Right
			else
			{
				UIView* v3 = [imageViews objectAtIndex:(i + 1)];
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v3 attribute:al multiplier:1.0f constant:-imagesDistance]];	// Space
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:re toItem:v3 attribute:aw multiplier:1.0f constant:0.0f]];				// Equal width
			}
			
			if(shouldApplyMaxSizeConstraints)
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:rl toItem:nil attribute:an multiplier:1.0f constant:maxSize.width]];	// Max width
			
			if(shouldApplyMinSizeConstraints)
				[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:aw relatedBy:rg toItem:nil attribute:an multiplier:1.0f constant:minSize.width]];	// Min width
			
			[containerView addConstraints:constraints];
			[self.containerViewAddedConstraints addObjectsFromArray:constraints];
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

//
//  JFRatingView.m
//  JFFramework
//
//  Created by Jacopo Filié on 17/10/15.
//
//



#import "JFRatingView.h"



@interface JFRatingView ()

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

// Data
@synthesize value	= _value;

// Data (Images)
@synthesize emptyImage	= _emptyImage;
@synthesize fullImage	= _fullImage;
@synthesize halfImage	= _halfImage;

// Flags
@synthesize allowsHalfRatings	= _allowsHalfRatings;
@synthesize editable			= _editable;

// Relationships
@synthesize delegate	 = _delegate;


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
		
		// Data
		_value	= 0.0;
		
		// Flags
		_allowsHalfRatings	= YES;
		_editable			= YES;
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
		
		// Data
		_value	= 0.0;
		
		// Flags
		_allowsHalfRatings	= YES;
		_editable			= YES;
	}
	return self;
}

@end

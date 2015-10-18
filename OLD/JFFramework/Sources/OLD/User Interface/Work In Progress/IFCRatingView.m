//
//  IFCRatingView.m
//  Rockol
//
//  Created by Jacopo Filié on 20/11/12.
//  Copyright (c) 2012 Icona s.r.l. All rights reserved.
//



#import "IFCRatingView.h"



static NSString* const	IFCResourceRateViewFullSelectedDefault	= @"IFCRateViewFullSelected-Default.png";
static NSString* const	IFCResourceRateViewHalfSelectedDefault	= @"IFCRateViewHalfSelected-Default.png";
static NSString* const	IFCResourceRateViewNotSelectedDefault	= @"IFCRateViewNotSelected-Default.png";


@interface IFCRatingView ()

// Data
@property (retain, nonatomic, readonly)	NSMutableArray*	ratingImages;

// Memory management
- (void)	baseInit;

// View management
- (void)	setupView;

// Data management
- (void)	reloadImages;

// Responder management
- (void)	handleTouchAtLocation:(CGPoint)touchLocation;

@end



@implementation IFCRatingView

#pragma mark - Properties

// Attributes
@synthesize	allowsHalfVotes	= _allowsHalfVotes;
@synthesize	editable		= _editable;
@synthesize	minRating		= _minRating;
@synthesize	maxRating		= _maxRating;
@synthesize	style			= _style;

// Data
@synthesize	rating			= _rating;
@synthesize	ratingImages	= _ratingImages;

// Layout
@synthesize	imageContentMode	= _imageContentMode;
@synthesize	imageFullSelected	= _imageFullSelected;
@synthesize	imageHalfSelected	= _imageHalfSelected;
@synthesize	imageNotSelected	= _imageNotSelected;
@synthesize	imagesMaxSize		= _imagesMaxSize;
@synthesize	imagesMiddleMargins	= _imagesMiddleMargins;
@synthesize	imagesMinSize		= _imagesMinSize;
@synthesize	imagesSideMargins	= _imagesSideMargins;

// Targets
@synthesize	delegate	= _delegate;


#pragma mark - Properties accessors

// Attributes

- (void)setMaxRating:(NSUInteger)maxRating
{
	if(_maxRating == maxRating)
		return;
	
	_maxRating = maxRating;
	
	[self setupView];
}

- (void)setStyle:(IFCRateViewStyle)style
{
	if(_style == style)
		return;
	
	_style = style;
	
	[self reloadImages];
}

// Data

- (void)setRating:(float)rating
{
	if(_rating == rating)
		return;
	
	_rating = rating;
	
	[self reloadImages];
}


// Layout

- (void)setImageContentMode:(NSInteger)imageContentMode
{
	if(_imageContentMode == imageContentMode)
		return;
	
	_imageContentMode = imageContentMode;
	
	[self setupView];
}

- (UIImage*)imageFullSelected
{
	if(!_imageFullSelected || (self.style != IFCRateViewStyleCustom))
		return [UIImage imageNamed:IFCResourceRateViewFullSelectedDefault];
	
	return _imageFullSelected;
}

- (void)setImageFullSelected:(UIImage*)imageFullSelected
{
	if(_imageFullSelected == imageFullSelected)
		return;
	
	[_imageFullSelected release];
	_imageFullSelected = [imageFullSelected retain];
	
	[self reloadImages];
}

- (UIImage*)imageHalfSelected
{
	if(!_imageHalfSelected || (self.style != IFCRateViewStyleCustom))
		return [UIImage imageNamed:IFCResourceRateViewHalfSelectedDefault];
	
	return _imageHalfSelected;
}

- (void)setImageHalfSelected:(UIImage*)imageHalfSelected
{
	if(_imageHalfSelected == imageHalfSelected)
		return;
	
	[_imageHalfSelected release];
	_imageHalfSelected = [imageHalfSelected retain];
	
	[self reloadImages];
}

- (UIImage*)imageNotSelected
{
	if(!_imageNotSelected || (self.style != IFCRateViewStyleCustom))
		return [UIImage imageNamed:IFCResourceRateViewNotSelectedDefault];
	
	return _imageNotSelected;
}

- (void)setImageNotSelected:(UIImage*)imageNotSelected
{
	if(_imageNotSelected == imageNotSelected)
		return;
	
	[_imageNotSelected release];
	_imageNotSelected = [imageNotSelected retain];
	
	[self reloadImages];
}


#pragma mark - Memory management

- (void)baseInit
{
	// Attributes
	_allowsHalfVotes = YES;
	_editable = NO;
	_minRating = 0.0f;
	_maxRating = 5;
	_style = IFCRateViewStyleDefault;
	
	// Data
	_rating = 0.0f;
	_ratingImages = [[NSMutableArray alloc] init];
	
	// Layout
	_imageContentMode = UIViewContentModeScaleAspectFit;
	_imageFullSelected = nil;
	_imageHalfSelected = nil;
	_imageNotSelected = nil;
	_imagesMaxSize = CGSizeZero;
	_imagesMiddleMargins = 0.0f;
	_imagesMinSize = CGSizeZero;
	_imagesSideMargins = 0.0f;
	
	// Targets
	_delegate = nil;
	
	[self setupView];
}

- (void)dealloc
{
	// Data
	[_ratingImages release];
	
	// Layout
	[_imageFullSelected release];
	[_imageHalfSelected release];
	[_imageNotSelected release];
	
	[super dealloc];
}

- (id)init
{
	return [self initWithFrame:CGRectZero];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self baseInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self baseInit];
	}
	return self;
}


#pragma mark - View management

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	NSUInteger imageCount = [self.ratingImages count];
	CGFloat margins = (2 * self.imagesSideMargins) + ((imageCount - 1) * self.imagesMiddleMargins);
	
	CGSize size = CGSizeMake((self.bounds.size.width - margins) / imageCount, self.bounds.size.height);
	
	if(!CGSizeEqualToSize(self.imagesMinSize, CGSizeZero))
	{
		size.height = MAX(self.imagesMinSize.height, size.height);
		size.width = MAX(self.imagesMinSize.width, size.width);
	}
	
	if(!CGSizeEqualToSize(self.imagesMaxSize, CGSizeZero))
	{
		size.height = MIN(self.imagesMaxSize.height, size.height);
		size.width = MIN(self.imagesMaxSize.width, size.width);
	}
	
	for (int i = 0; i < imageCount; i++)
	{
		CGPoint origin = CGPointMake(self.imagesSideMargins + (i * (self.imagesMiddleMargins + size.width)), 0.0f);
		
		UIImageView* imageView = [self.ratingImages objectAtIndex:i];
		
		CGRect frame = CGRectZero;
		frame.origin = origin;
		frame.size = size;
		imageView.frame = frame;
	}
}

- (void)setupView
{
    for(NSUInteger i = 0; i < [self.ratingImages count]; i++)
	{
        UIImageView* imageView = [self.ratingImages objectAtIndex:i];
        [imageView removeFromSuperview];
    }
	
    [self.ratingImages removeAllObjects];
	
    for(NSUInteger i = 0; i < self.maxRating; i++)
	{
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.contentMode = self.imageContentMode;
        [self.ratingImages addObject:imageView];
        [self addSubview:imageView];
		[imageView release];
    }
	
	[self reloadImages];
}


#pragma mark - Data management

- (void)reloadImages
{
	for(NSUInteger i = 0; i < [self.ratingImages count]; i++)
	{
		UIImageView* imageView = [self.ratingImages objectAtIndex:i];
		
		if(self.rating >= (i + 1))
			imageView.image = self.imageFullSelected;
		else if(self.rating > i)
			imageView.image = self.imageHalfSelected;
		else
			imageView.image = self.imageNotSelected;
	}
}


#pragma mark - Responder delegate

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	if(!self.editable)
		return;
	
	[self handleTouchAtLocation:[[touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.editable)
		return;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(rateView:ratingDidChange:)])
		[self.delegate rateView:self ratingDidChange:self.rating];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.editable)
		return;
	
    [self handleTouchAtLocation:[[touches anyObject] locationInView:self]];
}


#pragma mark - Responder management

- (void)handleTouchAtLocation:(CGPoint)touchLocation
{
	CGFloat location = touchLocation.x;
	
	CGFloat newRating = 0.0f;
	if(location <= 0.0f)
		newRating = 0.0f;
	else if(location > self.bounds.size.width)
		newRating = self.maxRating;
	else
	{
		NSUInteger count = [self.ratingImages count] * (self.allowsHalfVotes ? 2 : 1);
		CGFloat slice = self.bounds.size.width / count;
		
		for(NSUInteger index = 0; index < count; index++)
		{
			if((location > (slice * index)) && (location <= (slice * (index + 1))))
			{
				newRating = ((float)self.maxRating / (float)count) * (float)(index + 1);
				break;
			}
		}
	}
	
	self.rating = MAX(self.minRating, newRating);
}

@end

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



@interface JFRatingView ()

#pragma mark Properties

// Flags
@property (assign, nonatomic, getter = isUserInterfaceInitialized)	BOOL	userInterfaceInitialized;


#pragma mark Methods

// User interface management
- (void)	updateComponentsVisibility;

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

// Data
@synthesize value	= _value;

// Data (Images)
@synthesize emptyImage	= _emptyImage;
@synthesize fullImage	= _fullImage;
@synthesize halfImage	= _halfImage;

// Flags
@synthesize allowsHalfRatings			= _allowsHalfRatings;
@synthesize editable					= _editable;
@synthesize userInterfaceInitialized	= _userInterfaceInitialized;

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
		_numberOfImages		= 5;
		
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
		_numberOfImages		= 5;
		
		// Data
		_value	= 0.0;
		
		// Flags
		_allowsHalfRatings	= YES;
		_editable			= YES;
	}
	return self;
}


#pragma mark User interface management

- (void)initializeUserInterface
{
	[self updateComponentsVisibility];
}

- (void)updateComponentsVisibility
{
	[self setNeedsUpdateConstraints];
}


#pragma mark User interface management (Constraints)

- (void)updateConstraints
{
	if([self isUserInterfaceInitialized])
	{}
	
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

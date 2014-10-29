//
//  JFActivityIndicatorView.m
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



#import "JFActivityIndicatorView.h"

#import "JFUtilities.h"



@interface JFActivityIndicatorView ()

// Flags
@property (assign, nonatomic)	BOOL	shouldUseIndicatorView;

// User interface
@property (strong, nonatomic, readonly)	UIImageView*				imageView;
@property (strong, nonatomic, readonly)	UIActivityIndicatorView*	indicatorView;

// User interface management
- (void)	updateIndicators;

@end



@implementation JFActivityIndicatorView

#pragma mark - Properties

// Attributes
@synthesize animationDuration	= _animationDuration;
@synthesize animationSize		= _animationSize;

// Data
@synthesize animationImages	= _animationImages;

// Flags
@synthesize shouldUseIndicatorView	= _shouldUseIndicatorView;

// User interface
@synthesize imageView		= _imageView;
@synthesize indicatorView	= _indicatorView;


#pragma mark - Properties accessors (Attributes)

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
	if(_animationDuration == animationDuration)
		return;
	
	_animationDuration = animationDuration;
	
	self.imageView.animationDuration = _animationDuration;
}

- (void)setAnimationSize:(CGSize)animationSize
{
	if(CGSizeEqualToSize(_animationSize, animationSize))
		return;
	
	_animationSize = animationSize;
	
	[self updateIndicators];
}


#pragma mark - Properties accessors (Data)

- (void)setAnimationImages:(NSArray*)animationImages
{
	if(_animationImages == animationImages)
		return;
	
	_animationImages = animationImages;
	
	self.imageView.animationImages = _animationImages;
	self.shouldUseIndicatorView = (_animationImages == nil);
}


#pragma mark - Properties accessors (Flags)

- (void)setShouldUseIndicatorView:(BOOL)shouldUseIndicatorView
{
	if(_shouldUseIndicatorView == shouldUseIndicatorView)
		return;
	
	_shouldUseIndicatorView = shouldUseIndicatorView;
	[self updateIndicators];
}


#pragma mark - Properties accessors (Inherited)

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	[self updateIndicators];
}


#pragma mark - Memory management

- (void)commonInit
{
	// Flags
	_shouldUseIndicatorView = YES;
	
	// Inherited
	self.backgroundColor = ColorAlpha(80.0f);
	self.opaque = NO;
	self.userInteractionEnabled = YES;
	
	_imageView = [UIImageView new];
	_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin);
	self.imageView.autoresizingMask = autoresizingMask;
	self.indicatorView.autoresizingMask = autoresizingMask;
	
	[self addSubview:self.imageView];
	[self addSubview:self.indicatorView];
	
	self.imageView.animationDuration = self.animationDuration;
	self.imageView.animationImages = self.animationImages;
	
	[self updateIndicators];
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


#pragma mark - User interface management

- (void)updateIndicators
{
	self.imageView.hidden = self.shouldUseIndicatorView;
	self.indicatorView.hidden = !self.shouldUseIndicatorView;
	
	if(self.hidden)
	{
		if(self.shouldUseIndicatorView)
			[self.indicatorView stopAnimating];
		else
			[self.imageView stopAnimating];
	}
	else
	{
		if(self.shouldUseIndicatorView)
		{
			[self.imageView stopAnimating];
			[self.indicatorView startAnimating];
		}
		else
		{
			[self.indicatorView stopAnimating];
			[self.imageView startAnimating];
		}
	}
	
	if(!self.imageView.hidden)
	{
		CGRect frame = self.imageView.frame;
		frame.size = self.animationSize;
		frame.origin.x = (float)(self.bounds.size.width - frame.size.width) / 2.0f;
		frame.origin.y = (float)(self.bounds.size.height - frame.size.height) / 2.0f;
		self.imageView.frame = frame;
	}
	
	if(!self.indicatorView.hidden)
	{
		CGRect frame = self.indicatorView.frame;
		frame.origin.x = (float)(self.bounds.size.width - frame.size.width) / 2.0f;
		frame.origin.y = (float)(self.bounds.size.height - frame.size.height) / 2.0f;
		self.indicatorView.frame = frame;
	}
}

@end

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

// User interface
@property (strong, nonatomic, readonly)	UIActivityIndicatorView*	indicatorView;

// Memory management
- (void)	commonInit;

@end



@implementation JFActivityIndicatorView

#pragma mark - Properties

// User interface
@synthesize indicatorView	= _indicatorView;


#pragma mark - Memory management

- (void)commonInit
{
	self.backgroundColor = ColorWithHexA(0x00000080);
	self.opaque = NO;
	self.userInteractionEnabled = YES;
	
	_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	[self addSubview:self.indicatorView];
	
	CGRect frame = self.indicatorView.frame;
	frame.origin.x = (float)(self.bounds.size.width - frame.size.width) / 2.0f;
	frame.origin.y = (float)(self.bounds.size.height - frame.size.height) / 2.0f;
	self.indicatorView.frame = frame;
	
	[self.indicatorView startAnimating];
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

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	
	if(hidden)
		[self.indicatorView stopAnimating];
	else
		[self.indicatorView startAnimating];
}

@end

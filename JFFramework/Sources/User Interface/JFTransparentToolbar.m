//
//  JFTransparentToolbar.m
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



#import "JFTransparentToolbar.h"



@interface JFTransparentToolbar ()

// Memory management
- (void)	commonInit;

@end



@implementation JFTransparentToolbar

#pragma mark - Properties

// User interface
@synthesize underneathView	= _underneathView;


#pragma mark - Memory management

- (void)commonInit
{
	UIImage* clearImage = [UIImage new];
	
	self.backgroundColor = [UIColor clearColor];
	[self setBackgroundImage:clearImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	[self setShadowImage:clearImage forToolbarPosition:UIToolbarPositionAny];
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


#pragma mark - Gesture recognizers management

- (id)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
	id retVal = [super hitTest:point withEvent:event];
	return ((retVal == self) ? self.underneathView : retVal);
}

@end

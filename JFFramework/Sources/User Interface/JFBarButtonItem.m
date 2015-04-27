//
//  JFBarButtonItem.m
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



#import "JFBarButtonItem.h"



@interface JFBarButtonItem ()

#pragma mark Properties

// Data
@property (copy, nonatomic)	JFBarButtonItemBlock	block;


#pragma mark Methods

// User interface management (Actions)
- (void)	buttonTapped:(UIBarButtonItem*)sender;

@end



#pragma mark



@implementation JFBarButtonItem

#pragma mark Properties

// Data
@synthesize block	= _block;


#pragma mark Memory management

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(JFBarButtonItemBlock)block
{
	self = [self initWithBarButtonSystemItem:systemItem target:self action:@selector(buttonTapped:)];
	if(self)
	{
		// Data
		_block = [block copy];
	}
	return self;
}

- (instancetype)initWithImage:(UIImage*)image landscapeImagePhone:(UIImage*)landscapeImagePhone style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block
{
	self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:self action:@selector(buttonTapped:)];
	if(self)
	{
		// Data
		_block = [block copy];
	}
	return self;
}

- (instancetype)initWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block
{
	self = [self initWithImage:image style:style target:self action:@selector(buttonTapped:)];
	if(self)
	{
		// Data
		_block = [block copy];
	}
	return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block
{
	self = [self initWithTitle:title style:style target:self action:@selector(buttonTapped:)];
	if(self)
	{
		// Data
		_block = [block copy];
	}
	return self;
}


#pragma mark User interface management (Actions)

- (void)buttonTapped:(UIBarButtonItem*)sender
{
	if(self.block)
		self.block(self);
}

@end

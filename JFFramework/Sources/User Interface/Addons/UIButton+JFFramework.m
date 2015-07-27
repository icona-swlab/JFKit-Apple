//
//  UIButton+JFFramework.m
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



#import "UIButton+JFFramework.h"

#import <objc/runtime.h>



@interface UIButton (JFFramework_Private)

#pragma mark Methods

// User interface management (Actions)
- (void)	buttonTapped:(UIButton*)button;

@end



#pragma mark



@implementation UIButton (JFFramework_Private)

#pragma mark User interface management (Actions)

- (void)buttonTapped:(UIButton*)button
{
	JFButtonBlock block = self.actionBlock;
	if(block)
		block(self);
}

@end



#pragma mark



@implementation UIButton (JFFramework)

#pragma mark Properties accessors (User interface)

- (JFButtonBlock)actionBlock
{
	return objc_getAssociatedObject(self, @selector(actionBlock));
}

- (void)setActionBlock:(JFButtonBlock)block
{
	[self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	objc_setAssociatedObject(self, @selector(actionBlock), block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

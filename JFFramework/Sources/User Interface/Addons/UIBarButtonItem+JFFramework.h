//
//  UIBarButtonItem+JFFramework.h
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



@class JFBarButtonItem;



#pragma mark - Typedefs

typedef void (^JFBarButtonItemBlock) (id sender);



#pragma mark



@interface UIBarButtonItem (JFFramework)

#pragma mark Properties

// User interface
@property (strong, nonatomic)	JFBarButtonItemBlock	actionBlock;


#pragma mark Methods

// Memory management
- (instancetype)	initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem block:(JFBarButtonItemBlock)block;
- (instancetype)	initWithImage:(UIImage*)image landscapeImagePhone:(UIImage*)landscapeImagePhone style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block;
- (instancetype)	initWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block;
- (instancetype)	initWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style block:(JFBarButtonItemBlock)block;

@end

//
//  JFMenuController.m
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



#import "JFMenuController.h"



@interface JFMenuController ()

@end



#pragma mark



@interface JFMenuItem ()

#pragma mark Properties

// Relationships
@property (strong, nonatomic, readonly)	NSMutableArray*	privateSubitems;
@property (weak, nonatomic, readwrite)	JFMenuItem*		superitem;

@end



#pragma mark



@implementation JFMenuController

@end



#pragma mark



@implementation JFMenuItem

#pragma mark Properties

// Data
@synthesize actionBlock		= _actionBlock;
@synthesize additionalInfo	= _additionalInfo;
@synthesize detailText		= _detailText;
@synthesize imageURL		= _imageURL;
@synthesize title			= _title;

// Relationships
@synthesize privateSubitems	= _privateSubitems;
@synthesize subitems		= _subitems;
@synthesize superitem		= _superitem;


#pragma mark Properties accessors (Relationships)

- (NSArray<JFMenuItem*>*)subitems
{
	if(!_subitems)
		_subitems = [self.privateSubitems copy];
	
	return _subitems;
}


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Relationships
		_privateSubitems = [NSMutableArray new];
	}
	return self;
}


#pragma mark Relationships management

- (void)addSubitem:(JFMenuItem*)item
{
	if(!item)
		return;
	
	[self addSubitems:@[item]];
}

- (void)addSubitems:(NSArray<JFMenuItem*>*)items
{
	[self insertSubitems:items atIndex:[self.privateSubitems count]];
}

- (void)insertSubitem:(JFMenuItem*)item atIndex:(NSUInteger)index
{
	if(!item)
		return;
	
	[self insertSubitems:@[item] atIndex:index];
}

- (void)insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index
{
	if(!items)
		return;
	
	NSUInteger lastIndex = [self.privateSubitems count] - 1;
	if(index > (lastIndex + 1))
		return;
	
	NSRange range = NSMakeRange(index, [items count]);
	NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
	[self.privateSubitems insertObjects:items atIndexes:indexSet];
	_subitems = nil;
	
	for(JFMenuItem* item in items)
	{
		[item.superitem removeSubitem:item];
		item.superitem = self;
	}
}

- (void)removeSubitem:(JFMenuItem*)item
{
	if(!item)
		return;
	
	[self removeSubitems:@[item]];
}

- (void)removeSubitems:(NSArray<JFMenuItem*>*)items
{
	if(!items)
		return;
	
	NSMutableArray* subitems = self.privateSubitems;
	for(JFMenuItem* item in items)
	{
		if(![subitems containsObject:item])
			continue;
		
		[subitems removeObject:item];
		
		if(item.superitem == self)
			item.superitem = nil;
	}
	
	_subitems = nil;
}

@end

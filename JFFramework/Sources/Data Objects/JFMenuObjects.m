//
//  JFMenuObjects.m
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



#import "JFMenuObjects.h"



@interface JFMenuNode ()

#pragma mark Properties

// Relationships
@property (strong, nonatomic, readonly)	NSMutableArray<JFMenuItem*>*	privateSubitems;

@end



#pragma mark



@interface JFMenuItem ()

#pragma mark Properties

// Relationships
@property (weak, nonatomic, readwrite)	JFMenuSection*	section;
@property (weak, nonatomic, readwrite)	JFMenuItem*		superitem;

@end



#pragma mark



@implementation JFMenuNode

#pragma mark Properties

// Data
@synthesize additionalInfo	= _additionalInfo;
@synthesize detailText		= _detailText;
@synthesize title			= _title;

// Relationships
@synthesize privateSubitems	= _privateSubitems;
@synthesize subitems		= _subitems;


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
		if([self isMemberOfClass:[JFMenuNode class]])
		{
			self = nil;
			return nil;
		}
		
		// Relationships
		_privateSubitems = [NSMutableArray new];
	}
	return self;
}


#pragma mark Relationships management

- (JFMenuItem*)addSubitem:(JFMenuItem*)item
{
	if(!item)
		return nil;
	
	return [[self addSubitems:@[item]] firstObject];
}

- (NSArray<JFMenuItem*>*)addSubitems:(NSArray<JFMenuItem*>*)items
{
	return [self insertSubitems:items atIndex:[self.privateSubitems count]];
}

- (JFMenuItem*)insertSubitem:(JFMenuItem*)item atIndex:(NSUInteger)index
{
	if(!item)
		return nil;
	
	return [[self insertSubitems:@[item] atIndex:index] firstObject];
}

- (NSArray<JFMenuItem*>*)insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index
{
	if(!items)
		return nil;
	
	NSMutableArray* subitems = self.privateSubitems;
	
	if(index > [subitems count])
		return nil;
	
	NSMutableArray* retObj = [items mutableCopy];
	[retObj removeObjectsInArray:subitems];
	
	NSRange range = NSMakeRange(index, [retObj count]);
	NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
	[subitems insertObjects:retObj atIndexes:indexSet];
	
	_subitems = nil;
	
	return [retObj copy];
}

- (JFMenuItem*)removeSubitem:(JFMenuItem*)item
{
	if(!item)
		return nil;
	
	return [[self removeSubitems:@[item]] firstObject];
}

- (NSArray<JFMenuItem*>*)removeSubitems:(NSArray<JFMenuItem*>*)items
{
	if(!items)
		return nil;
	
	NSMutableArray* retObj = [NSMutableArray arrayWithCapacity:[items count]];
	
	NSMutableArray* subitems = self.privateSubitems;
	for(JFMenuItem* item in items)
	{
		if(![subitems containsObject:item])
			continue;
		
		[retObj addObject:item];
		[subitems removeObject:item];
		
		if(item.superitem == self)
			item.superitem = nil;
	}
	
	_subitems = nil;
	
	return [retObj copy];
}


#pragma mark Protocol implementation (NSCopying)

- (instancetype)copyWithZone:(nullable NSZone*)zone
{
	typeof(self) retObj = [[[self class] alloc] init];
	
	// Data
	retObj->_additionalInfo	= _additionalInfo;
	retObj->_detailText		= _detailText;
	retObj->_title			= _title;
	
	return retObj;
}

@end



#pragma mark



@implementation JFMenuItem

#pragma mark Properties

// Data
@synthesize actionBlock		= _actionBlock;
@synthesize imageURL		= _imageURL;

// Relationships
@synthesize section		= _section;
@synthesize superitem	= _superitem;


#pragma mark Properties accessors (Relationships)

- (void)setSection:(JFMenuSection*)section
{
	if(_section == section)
		return;
	
	_section = section;
	
	for(JFMenuItem* item in self.subitems)
		item.section = section;
}


#pragma mark Relationships management

- (NSArray<JFMenuItem*>*)insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index
{
	NSArray* retObj = [super insertSubitems:items atIndex:index];
	if(retObj)
	{
		for(JFMenuItem* item in retObj)
		{
			[item.superitem removeSubitem:item];
			item.section = self.section;
			item.superitem = self;
		}
	}
	return retObj;
}

- (NSArray<JFMenuItem*>*)removeSubitems:(NSArray<JFMenuItem*>*)items
{
	NSArray* retObj = [super removeSubitems:items];
	if(retObj)
	{
		for(JFMenuItem* item in retObj)
		{
			if(item.superitem == self)
			{
				item.section = nil;
				item.superitem = nil;
			}
		}
	}
	return retObj;
}


#pragma mark Protocol implementation (NSCopying)

- (instancetype)copyWithZone:(nullable NSZone*)zone
{
	typeof(self) retObj = [super copyWithZone:zone];
	if(retObj)
	{
		// Data
		retObj->_actionBlock	= _actionBlock;
		retObj->_imageURL		= _imageURL;
	}
	return retObj;
}

@end



#pragma mark



@implementation JFMenuSection

#pragma mark Relationships management

- (NSArray<JFMenuItem*>*)insertSubitems:(NSArray<JFMenuItem*>*)items atIndex:(NSUInteger)index
{
	NSArray* retObj = [super insertSubitems:items atIndex:index];
	if(retObj)
	{
		for(JFMenuItem* item in retObj)
		{
			[item.superitem removeSubitem:item];
			item.section = self;
		}
	}
	return retObj;
}

- (NSArray<JFMenuItem*>*)removeSubitems:(NSArray<JFMenuItem*>*)items
{
	NSArray* retObj = [super removeSubitems:items];
	if(retObj)
	{
		for(JFMenuItem* item in retObj)
		{
			if(item.section == self)
				item.section = nil;
		}
	}
	return retObj;
}

@end

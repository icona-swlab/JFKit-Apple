//
//  JFKVObject.m
//  Copyright (C) 2015  Jacopo Filié
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



#import "JFKVObject.h"

#import "JFUtilities.h"



@implementation JFKVObject

#pragma mark Properties

// Data
@synthesize key		= _key;
@synthesize value	= _value;


#pragma mark Comparison management

- (BOOL)isEqual:(id)object
{
	if(![super isEqual:object])
		return NO;
	
	if(![object isKindOfClass:[self class]])
		return NO;
	
	return [self isEqualToKVObject:object];
}

- (BOOL)isEqualToKVObject:(JFKVObject*)object
{
	if(!object)
		return NO;
	
	id<NSObject> key1 = self.key;
	id<NSObject> key2 = object.key;
	
	if(!JFAreObjectsEqual(key1, key2))
		return NO;
	
	id<NSObject> value1 = self.value;
	id<NSObject> value2 = object.value;
	
	if(!JFAreObjectsEqual(value1, value2))
		return NO;
	
	return YES;
}


#pragma mark Protocol Implementation (NSCopying)

- (instancetype)copyWithZone:(nullable NSZone*)zone
{
	typeof(self) retObj = [[[self class] allocWithZone:zone] init];
	
	// Data
	retObj->_key	= _key;
	retObj->_value	= _value;
	
	return retObj;
}

@end

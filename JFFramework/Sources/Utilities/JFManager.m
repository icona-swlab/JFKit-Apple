//
//  JFManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 09/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFManager.h"

#import "JFUtilities.h"



@implementation JFManager

#pragma mark Memory management

+ (instancetype)defaultManager
{
	static NSMutableDictionary* defaultManagers = nil;
	
	id retObj = nil;
	
	@synchronized(self)
	{
		if(!defaultManagers)
			defaultManagers = [NSMutableDictionary new];
		
		NSString* key = ClassName;
		
		retObj = [defaultManagers objectForKey:key];
		if(!retObj)
		{
			retObj = [[self alloc] init];
			if(retObj)
				[defaultManagers setObject:retObj forKey:key];
		}
	}
	
	return retObj;
}

@end

//
//  JFImageObserver.m
//  JFFramework
//
//  Created by Jacopo Filié on 02/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFImageObserver.h"



@implementation JFImageObserver

#pragma mark Properties

// Data
@synthesize block		= _block;
@synthesize observer	= _observer;


#pragma mark Memory management

- (instancetype)initWithObserver:(id)observer block:(JFBlock)block
{
	self = ((observer && block) ? [self init] : nil);
	if(self)
	{
		// Data
		_observer = observer;
		_block = block;
	}
	return self;
}

@end

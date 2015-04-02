//
//  JFImageObserver.h
//  JFFramework
//
//  Created by Jacopo Filié on 02/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFUtilities.h"



@interface JFImageObserver : NSObject

#pragma mark Properties

// Data
@property (strong, nonatomic, readonly)	JFBlock	block;
@property (weak, nonatomic, readonly)	id		observer;

// Memory management
- (instancetype)	initWithObserver:(id)observer block:(JFBlock)block;

@end

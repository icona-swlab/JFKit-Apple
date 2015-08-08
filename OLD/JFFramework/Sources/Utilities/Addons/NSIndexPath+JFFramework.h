//
//  NSIndexPath+JFFramework.h
//  JFFramework
//
//  Created by Jacopo Filié on 01/07/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



@interface NSIndexPath (JFFramework)

#pragma mark Methods

// Memory management
+ (instancetype)	indexPathWithSymbolSeparatedValues:(NSString*)symbolSeparatedValues symbol:(NSString*)symbol;
- (instancetype)	initWithSymbolSeparatedValues:(NSString*)symbolSeparatedValues symbol:(NSString*)symbol;

@end

//
//  JFImageManager.h
//  JFFramework
//
//  Created by Jacopo Filié on 02/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFUtilities.h"



@interface JFImageManager : NSObject

#pragma mark Methods

// Memory management
+ (instancetype)	defaultManager;

// Notifications management
- (void)	addObserver:(id)observer forImageForURL:(NSURL*)url usingBlock:(JFBlock)block;
- (void)	removeObserver:(id)observer forImageForURL:(NSURL*)url;

// Services management
- (UIImage*)	imageWithContentsOfURL:(NSURL*)url placeholder:(UIImage*)placeholder;

@end

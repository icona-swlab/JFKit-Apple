//
//  JFImageManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 02/04/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFImageManager.h"

#import "JFFileManager.h"
#import "JFImageObserver.h"



@interface JFImageManager ()

#pragma mark Properties

// Data
@property (strong, nonatomic, readonly)	NSMutableDictionary*	cache;	// Dictionary of "UIImage" objects.

// Notifications
@property (strong, nonatomic, readonly)	NSMutableDictionary*	observers;	// Dictionary of "NSMutableSet" objects where each is a set of "JFImageObserver" objects.


#pragma mark Methods

// Network management
- (void)	downloadContentsOfURL:(NSURL*)url;

// Notifications management
- (void)			notifyDidDownloadImageForURL:(NSURL*)url;
- (NSMutableSet*)	observersForImageForURL:(NSURL*)url;
- (NSMutableSet*)	observersForImageForURL:(NSURL*)url shouldCreate:(BOOL)shouldCreate;

// Utilities management
- (NSURL*)	localURLForImageForURL:(NSURL*)url;

@end



#pragma mark



@implementation JFImageManager

#pragma mark Properties

// Data
@synthesize cache	= _cache;

// Notifications
@synthesize observers	= _observers;


#pragma mark Memory management

+ (instancetype)defaultManager
{
	static id defaultManager = nil;
	static dispatch_once_t token = 0;
	
	dispatch_once(&token, ^{
		defaultManager = [[[self class] alloc] init];
		if(!defaultManager)
			token = 0;
	});
	
	return defaultManager;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Data
		_cache = [NSMutableDictionary new];
		
		// Notifications
		_observers = [NSMutableDictionary new];
	}
	return self;
}


#pragma mark Network management

- (void)downloadContentsOfURL:(NSURL*)url
{
	if(!url)
		return;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		
		ShowNetworkActivityIndicator;
		NSData* data = [NSData dataWithContentsOfURL:url];
		HideNetworkActivityIndicator;
		
		if(!data)
			return;
		
		NSURL* localURL = [self localURLForImageForURL:url];
		
		if(![[JFFileManager defaultManager] createFileAtURL:localURL contents:data attributes:nil])
			return;
		
		[self notifyDidDownloadImageForURL:url];
	});
}


#pragma mark Notifications management

- (void)addObserver:(id)observer forImageForURL:(NSURL*)url usingBlock:(JFBlock)block
{
	if(!observer || !url || !block)
		return;
	
	JFImageObserver* imageObserver = [[JFImageObserver alloc] initWithObserver:observer block:block];
	if(!imageObserver)
		return;
	
	NSMutableSet* mSet = [self observersForImageForURL:url shouldCreate:YES];
	
	@synchronized(mSet)
	{
		[mSet addObject:imageObserver];
	}
}

- (void)notifyDidDownloadImageForURL:(NSURL*)url
{
	if(!url)
		return;
	
	NSMutableSet* mSet = [self observersForImageForURL:url];
	if(!mSet)
		return;
	
	NSSet* imageObservers = nil;
	@synchronized(mSet)
	{
		imageObservers = [mSet copy];
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		for(JFImageObserver* imageObserver in imageObservers)
		{
			if(imageObserver.observer)
				imageObserver.block();
		}
	});
}

- (NSMutableSet*)observersForImageForURL:(NSURL*)url
{
	return [self observersForImageForURL:url shouldCreate:NO];
}

- (NSMutableSet*)observersForImageForURL:(NSURL*)url shouldCreate:(BOOL)shouldCreate
{
	NSMutableDictionary* observers = self.observers;
	
	NSMutableSet* retObj = nil;
	@synchronized(observers)
	{
		retObj = [observers objectForKey:url];
		if(!retObj && shouldCreate)
		{
			retObj = [NSMutableSet set];
			[observers setObject:retObj forKey:url];
		}
	}
	return retObj;
}

- (void)removeObserver:(id)observer forImageForURL:(NSURL*)url
{
	if(!observer || !url)
		return;
	
	NSMutableSet* mSet = [self observersForImageForURL:url];
	if(!mSet)
		return;
	
	@synchronized(mSet)
	{
		NSSet* imageObservers = [mSet copy];
		for(JFImageObserver* imageObserver in imageObservers)
		{
			if(!imageObserver.observer || (imageObserver.observer == observer))
				[mSet removeObject:imageObserver];
		}
	}
}


#pragma mark Services management

- (UIImage*)imageWithContentsOfURL:(NSURL*)url placeholder:(UIImage*)placeholder
{
	if(!url)
		return nil;
	
	NSURL* localURL = [self localURLForImageForURL:url];
	
	UIImage* retObj = nil;
	if([[JFFileManager defaultManager] itemExistsAtURL:localURL isDirectory:NULL])
		retObj = [UIImage imageWithContentsOfFile:localURL.path];
	
	if(!retObj)
	{
		[self downloadContentsOfURL:url];
		retObj = placeholder;
	}
	
	return retObj;
}


#pragma mark Utilities management

- (NSURL*)localURLForImageForURL:(NSURL*)url
{
	if(!url)
		return nil;
	
	NSURL* retObj = [[[JFFileManager defaultManager] URLForSystemDirectoryCaches] URLByAppendingPathComponent:@"Images"];
	return [retObj URLByAppendingPathComponent:[url lastPathComponent]];
}

@end

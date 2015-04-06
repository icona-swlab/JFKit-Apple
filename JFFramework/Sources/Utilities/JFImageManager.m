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

// Cache
@property (strong, nonatomic, readonly)	NSCache*	cache;

// Notifications
@property (strong, nonatomic, readonly)	NSMutableDictionary*	observers;	// Dictionary of "NSMutableSet" objects where each is a set of "JFImageObserver" objects.

// Operations
@property (strong, nonatomic, readonly)	NSOperationQueue*	downloadOperations;


#pragma mark Methods

// Cache management
- (UIImage*)	cachedImageForURL:(NSURL*)url;
- (void)		cacheImage:(UIImage*)image forURL:(NSURL*)url;

// Network management
- (void)	downloadContentsOfURL:(NSURL*)url;

// Notifications management
- (void)			notifyDidDownloadImageForURL:(NSURL*)url;
- (NSMutableSet*)	observersForImageForURL:(NSURL*)url;
- (NSMutableSet*)	observersForImageForURL:(NSURL*)url shouldCreate:(BOOL)shouldCreate;

@end



#pragma mark



@implementation JFImageManager

#pragma mark Properties

// Cache
@synthesize cache	= _cache;

// Notifications
@synthesize observers	= _observers;

// Operations
@synthesize downloadOperations	= _downloadOperations;


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

- (void)dealloc
{
	[self.downloadOperations cancelAllOperations];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Prepares the cache.
		NSCache* cache = [NSCache new];
		cache.name = @"Images";
		
		// Prepares the operation queue.
		NSOperationQueue* queue = [NSOperationQueue new];
		queue.maxConcurrentOperationCount = 1;
		queue.name = @"Downloads";
		
		// Cache
		_cache = cache;
		
		// Notifications
		_observers = [NSMutableDictionary new];
		
		// Operations
		_downloadOperations = queue;
	}
	return self;
}


#pragma mark Cache management

- (UIImage*)cachedImageForURL:(NSURL*)url
{
	if(!url)
		return nil;
	
	return [self.cache objectForKey:url];
}

- (void)cacheImage:(UIImage*)image forURL:(NSURL*)url
{
	if(!image || !url)
		return;
	
	[self.cache setObject:image forKey:url];
}


#pragma mark Network management

- (void)downloadContentsOfURL:(NSURL*)url
{
	if(!url)
		return;
	
	JFBlock block = ^(void)
	{
		ShowNetworkActivityIndicator;
		NSData* data = [NSData dataWithContentsOfURL:url];
		HideNetworkActivityIndicator;
		
		if(!data)
			return;
		
		UIImage* image = [UIImage imageWithData:data];
		if(image)
			[self cacheImage:image forURL:url];
		
		[self notifyDidDownloadImageForURL:url];
	};
	
	[self.downloadOperations addOperationWithBlock:block];
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
	
	[NSMainOperationQueue addOperationWithBlock:^{
		for(JFImageObserver* imageObserver in imageObservers)
		{
			if(imageObserver.observer)
				imageObserver.block();
		}
	}];
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
	
	UIImage* retObj = [self cachedImageForURL:url];
	if(!retObj)
	{
		[self downloadContentsOfURL:url];
		retObj = placeholder;
	}
	
	return retObj;
}

@end

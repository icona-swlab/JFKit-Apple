//
//  JFUpdatableFile.m
//  Copyright (C) 2014  Jacopo Filié
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



#import "JFUpdatableFile.h"



@interface JFUpdatableFile ()

// Flags
@property (assign, readwrite)	BOOL isUpdatingContent;

// Data management
- (id)	readContentFromURL:(NSURL*)url;

// Notifications management
- (void)	notifyDidFailToReadContentFromURL:(NSURL*)url;
- (void)	notifyDidFailToUpdateContent;
- (void)	notifyDidReadContentFromURL:(NSURL*)url usingClass:(Class)class;
- (void)	notifyDidUpdateContent;

@end



@implementation JFUpdatableFile

#pragma mark - Properties

// Data
@synthesize bundleURL	= _bundleURL;
@synthesize localURL	= _localURL;
@synthesize remoteURL	= _remoteURL;

// Flags
@synthesize isUpdatingContent	= _isUpdatingContent;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark - Memory management

- (instancetype)initWithRemoteURL:(NSURL*)remoteURL localURL:(NSURL*)localURL bundleURL:(NSURL*)bundleURL
{
	self = ((remoteURL && localURL && bundleURL) ? [self init] : nil);
	if(self)
	{
		// Data
		_bundleURL = bundleURL;
		_localURL = localURL;
		_remoteURL = remoteURL;
		
		// Flags
		_isUpdatingContent = NO;
	}
	return self;
}


#pragma mark - Data management

- (id)getContent
{
	id retVal = nil;
	
	NSArray* urls = @[self.localURL, self.bundleURL];
	for(NSURL* url in urls)
	{
		retVal = [self readContentFromURL:url];
		if(retVal)
			break;
	}
	
	return retVal;
}

- (BOOL)getUpdatedContent:(BlockWithObject)completion
{
	if(!completion)
		return NO;
	
	Block block = ^(void)
	{
		id content = [self getContent];
		dispatch_async(dispatch_get_main_queue(), ^{
			completion(content);
		});
	};
	
	return [self updateContent:block];
}

- (id)readContentFromURL:(NSURL*)url
{
	if(!url)
		return nil;
	
	Class class = [NSData class];
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFile:classForContentReadingFromURL:)])
	{
		Class testedClass = [self.delegate updatableFile:self classForContentReadingFromURL:url];
		if([testedClass instancesRespondToSelector:@selector(initWithContentsOfURL:)])
			class = testedClass;
	}
	
	BOOL shouldSave = (url != self.localURL);
	
	// Reads the content from the specified url.
	id retVal = [[class alloc] initWithContentsOfURL:url];
	if(retVal)
	{
		[self notifyDidReadContentFromURL:url usingClass:class];
		
		if(shouldSave && self.delegate && [self.delegate respondsToSelector:@selector(updatableFile:saveContent:toURL:)])
		{
			// Saves the read file.
			[self.delegate updatableFile:self saveContent:retVal toURL:self.localURL];
		}
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFile:shouldProcessContentAtURL:)])
		{
			if([self.delegate updatableFile:self shouldProcessContentAtURL:url])
			{
				if([self.delegate respondsToSelector:@selector(updatableFile:processContent:)])
				{
					// Processes the file content.
					retVal = [self.delegate updatableFile:self processContent:retVal];
					
					if(retVal && shouldSave && [self.delegate respondsToSelector:@selector(updatableFile:saveProcessedContent:toURL:)])
					{
						// Saves the processed file content.
						[self.delegate updatableFile:self saveProcessedContent:retVal toURL:self.localURL];
					}
				}
			}
		}
	}
	else
		[self notifyDidFailToReadContentFromURL:url];
	
	return retVal;
}

- (BOOL)updateContent:(Block)completion
{
	if(self.isUpdatingContent)
		return NO;
	
	self.isUpdatingContent = YES;
	
	Block block = ^(void)
	{
		// Reads the content from the specified url.
		NSData* content = [self readContentFromURL:self.remoteURL];
		
		self.isUpdatingContent = NO;
		
		if(content)
			[self notifyDidUpdateContent];
		else
			[self notifyDidFailToUpdateContent];
		
		if(completion)
			completion();
	};
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
	
	return YES;
}


#pragma mark - Notifications management

- (void)notifyDidFailToReadContentFromURL:(NSURL*)url
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFile:didFailToReadContentFromURL:)])
		[self.delegate updatableFile:self didFailToReadContentFromURL:url];
}

- (void)notifyDidFailToUpdateContent
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFileDidFailToUpdateContent:)])
		[self.delegate updatableFileDidFailToUpdateContent:self];
}

- (void)notifyDidReadContentFromURL:(NSURL*)url usingClass:(Class)class
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFile:didReadContentFromURL:usingClass:)])
		[self.delegate updatableFile:self didReadContentFromURL:url usingClass:class];
}

- (void)notifyDidUpdateContent
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatableFileDidUpdateContent:)])
		[self.delegate updatableFileDidUpdateContent:self];
}

@end

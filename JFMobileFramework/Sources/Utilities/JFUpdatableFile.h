//
//  JFUpdatableFile.h
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



#import <Foundation/Foundation.h>

#import "JFUtilities.h"



@class JFUpdatableFile;



@protocol JFUpdatableFileDelegate <NSObject>

@optional

- (id)		updatableFile:(JFUpdatableFile*)file processContent:(id)content;							// Called after the file has been successfully read.
- (void)	updatableFile:(JFUpdatableFile*)file saveContent:(id)content toURL:(NSURL*)url;				// Called after the file has been successfully downloaded.
- (void)	updatableFile:(JFUpdatableFile*)file saveProcessedContent:(id)content toURL:(NSURL*)url;	// Called after the file has been successfully processed and only if the implementation of the method 'updatableFile:shouldProcessContentAtURL:' returned 'YES'.
- (BOOL)	updatableFile:(JFUpdatableFile*)file shouldProcessContentAtURL:(NSURL*)url;					// Called after the file has been successfully read but not processed yet (Default: 'NO').

- (Class)	updatableFile:(JFUpdatableFile*)file classForContentReadingFromURL:(NSURL*)url;					// Called before any read attempt. The returned value is used only if its instances respond to selector 'initWithContentsOfURL:'. (Default: 'NSData')
- (void)	updatableFile:(JFUpdatableFile*)file didFailToReadContentFromURL:(NSURL*)url;					// Called at the end of a failed content read.
- (void)	updatableFile:(JFUpdatableFile*)file didReadContentFromURL:(NSURL*)url usingClass:(Class)class;	// Called after any read attempt.

- (void)	updatableFileDidFailToUpdateContent:(JFUpdatableFile*)file;	// Called at the end of a failed update request.
- (void)	updatableFileDidUpdateContent:(JFUpdatableFile*)file;		// Called at the end of a successful update request.

@end



@interface JFUpdatableFile : NSObject

// Data
@property (strong, nonatomic, readonly)	NSURL*	bundleURL;	// File URL inside the bundle.
@property (strong, nonatomic, readonly)	NSURL*	localURL;	// File URL inside the local folders structure.
@property (strong, nonatomic, readonly)	NSURL*	remoteURL;	// File URL on the internet.

// Flags
@property (assign, readonly)	BOOL isUpdatingContent;

// Relationships
@property (weak, nonatomic)	id<JFUpdatableFileDelegate>	delegate;

// Memory management
- (instancetype)	initWithRemoteURL:(NSURL*)remoteURL localURL:(NSURL*)localURL bundleURL:(NSURL*)bundleURL;

// Data management
- (id)		getContent;
- (BOOL)	getUpdatedContent:(BlockWithObject)completion;
- (BOOL)	updateContent:(Block)completion;

@end

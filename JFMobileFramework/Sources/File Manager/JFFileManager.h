//
//  JFFileManager.h
//  JFMobileFramework
//
//  Created by Jacopo Filié on 26/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>



@interface JFFileManager : NSObject

// Memory management
+ (instancetype)	defaultManager;

// File system management
- (BOOL)	createFileAtURL:(NSURL*)fileURL contents:(NSData*)data attributes:(NSDictionary*)attributes;
- (BOOL)	createFolderAtURL:(NSURL*)folderURL attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error;
- (BOOL)	itemExistsAtURL:(NSURL*)itemURL isDirectory:(BOOL*)isDirectory;

// System directories management
- (NSURL*)	createTemporaryDirectoryAppropriateForURL:(NSURL*)url;	// A temporary folder created specifically for the given URL.
- (NSURL*)	URLForSystemDirectoryApplicationSupport;				// Contains application support files, like plug-ins. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryCaches;							// Contains cache files and downloadable content. It may be purged by the system.
- (NSURL*)	URLForSystemDirectoryDocuments;							// Contains critical documents that can not be recreated by the app. Backup up by iTunes.
- (NSURL*)	URLForSystemDirectoryInbox;								// Contains files that your app was asked to open by outside entities. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryLibrary;							// Contains critical files that are not user-related. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryTemp;								// Contains temporary files that should be deleted as soon as possible. It may be purged by the system.

@end

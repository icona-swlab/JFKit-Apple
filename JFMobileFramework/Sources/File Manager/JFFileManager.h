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
- (NSURL*)	createTemporaryDirectoryAppropriateForURL:(NSURL*)url;
- (NSURL*)	URLForSystemDirectoryApplicationSupport;
- (NSURL*)	URLForSystemDirectoryCaches;
- (NSURL*)	URLForSystemDirectoryDocuments;
- (NSURL*)	URLForSystemDirectoryInbox;
- (NSURL*)	URLForSystemDirectoryLibrary;
- (NSURL*)	URLForSystemDirectoryTemp;

@end

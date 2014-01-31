//
//  JFFileManager.m
//  JFMobileFramework
//
//  Created by Jacopo Filié on 26/01/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFFileManager.h"

#import "JFUtilities.h"



@interface JFFileManager ()

// Managers
@property (strong, nonatomic, readonly)	NSFileManager*	fileManager;

@end



@implementation JFFileManager

#pragma mark - Properties

// Managers
@synthesize fileManager	= _fileManager;


#pragma mark - Properties accessors (Managers)

- (NSFileManager*)fileManager
{
	@synchronized(self)
	{
		if(!_fileManager)
			_fileManager = [NSFileManager new];
	}
	return _fileManager;
}


#pragma mark - Memory management

+ (instancetype)defaultManager
{
    static dispatch_once_t token;
    static id defaultManager;
	
    dispatch_once(&token, ^{
        defaultManager = [[self alloc] init];
    });
	
    return defaultManager;
}


#pragma mark - File system management

- (BOOL)createFileAtURL:(NSURL*)fileURL contents:(NSData*)data attributes:(NSDictionary*)attributes
{
	if(!fileURL || ![fileURL isFileURL])
		return NO;
	
	// Checks if the parent folder exists and creates it if necessary.
	NSURL* parentFolder = [fileURL URLByDeletingLastPathComponent];
	if(![self itemExistsAtURL:parentFolder isDirectory:NULL])
	{
		NSError* error;
		if(![self createFolderAtURL:parentFolder attributes:nil error:&error])
		{
			NSLog(@"%@: failed to create the parent folder of the file at URL '%@' for error '%@'.", ClassName, fileURL, error);
			return NO;
		}
	}
	
	return [self.fileManager createFileAtPath:[fileURL path] contents:data attributes:attributes];
}

- (BOOL)createFolderAtURL:(NSURL*)folderURL attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error
{
	if(!folderURL || ![folderURL isFileURL])
		return NO;
	
	return [self.fileManager createDirectoryAtURL:folderURL withIntermediateDirectories:YES attributes:attributes error:error];
}

- (BOOL)itemExistsAtURL:(NSURL*)itemURL isDirectory:(BOOL*)isDirectory;
{
	if(![itemURL isFileURL])
		return NO;
	
	return [self.fileManager fileExistsAtPath:[[itemURL path] stringByExpandingTildeInPath] isDirectory:isDirectory];
}


#pragma mark - System directories management

- (NSURL*)createTemporaryDirectoryAppropriateForURL:(NSURL*)url
{
	NSError* error;
	NSURL* retVal = [self.fileManager URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:url create:YES error:&error]; // The temporary directory is created despite the 'create' parameter value.
	
	if(!retVal)
		NSLog(@"%@: failed to create a temporary directory appropriate for URL '%@' for error '%@'.", ClassName, url, error);
	
	return retVal;
}

- (NSURL*)systemDirectory:(NSSearchPathDirectory)directory error:(NSError*__autoreleasing*)error
{
	return [self.fileManager URLForDirectory:directory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:error];
}

- (NSURL*)URLForSystemDirectoryApplicationSupport
{
	NSError* error;
	NSURL* retVal = [self systemDirectory:NSApplicationSupportDirectory error:&error];
	
	if(!retVal)
		NSLog(@"%@: unable to locate system directory 'Application Support' for error '%@'.", ClassName, error);
	
	return retVal;
}

- (NSURL*)URLForSystemDirectoryCaches
{
	NSError* error;
	NSURL* retVal = [self systemDirectory:NSCachesDirectory error:&error];
	
	if(!retVal)
		NSLog(@"%@: unable to locate system directory 'Caches' for error '%@'.", ClassName, error);
	
	return retVal;
}

- (NSURL*)URLForSystemDirectoryDocuments
{
	NSError* error;
	NSURL* retVal = [self systemDirectory:NSDocumentDirectory error:&error];
	
	if(!retVal)
		NSLog(@"%@: unable to locate system directory 'Documents' for error '%@'.", ClassName, error);
	
	return retVal;
}

- (NSURL*)URLForSystemDirectoryInbox
{
	NSError* error;
	NSURL* retVal = [self systemDirectory:NSDocumentDirectory error:&error];
	
	if(retVal)
		retVal = [retVal URLByAppendingPathComponent:@"Inbox"];
	
	if(!retVal)
		NSLog(@"%@: unable to locate system directory 'Inbox' for error '%@'.", ClassName, error);
	
	return retVal;
}

- (NSURL*)URLForSystemDirectoryLibrary
{
	NSError* error;
	NSURL* retVal = [self systemDirectory:NSLibraryDirectory error:&error];
	
	if(!retVal)
		NSLog(@"%@: unable to locate system directory 'Library' for error '%@'.", ClassName, error);
	
	return retVal;
}

- (NSURL*)URLForSystemDirectoryTemp
{
	NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
	return (path ? [NSURL fileURLWithPath:path] : nil);
}

@end

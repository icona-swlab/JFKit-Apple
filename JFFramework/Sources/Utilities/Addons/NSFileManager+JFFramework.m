//
//  NSFileManager+JFFramework.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "NSFileManager+JFFramework.h"

#import "JFLogger.h"
#import "JFUtilities.h"



@implementation NSFileManager (JFFramework)

#pragma mark Item accessibility management

- (BOOL)isDeletableItemAtURL:(NSURL*)itemURL
{
	if(!itemURL || ![itemURL isFileURL])
		return NO;
	
	NSString* path = [[itemURL path] stringByExpandingTildeInPath];
	return [self isDeletableFileAtPath:path];
}

- (BOOL)isExecutableItemAtURL:(NSURL*)itemURL
{
	if(!itemURL || ![itemURL isFileURL])
		return NO;
	
	NSString* path = [[itemURL path] stringByExpandingTildeInPath];
	return [self isExecutableFileAtPath:path];
}

- (BOOL)isReadableItemAtURL:(NSURL*)itemURL
{
	if(!itemURL || ![itemURL isFileURL])
		return NO;
	
	NSString* path = [[itemURL path] stringByExpandingTildeInPath];
	return [self isReadableFileAtPath:path];
}

- (BOOL)isWritableItemAtURL:(NSURL*)itemURL
{
	if(!itemURL || ![itemURL isFileURL])
		return NO;
	
	NSString* path = [[itemURL path] stringByExpandingTildeInPath];
	return [self isWritableFileAtPath:path];
}

- (BOOL)itemExistsAtPath:(NSString*)itemPath
{
	return [self itemExistsAtPath:itemPath isDirectory:NULL];
}

- (BOOL)itemExistsAtPath:(NSString*)itemPath isDirectory:(BOOL*)isDirectory
{
	if(!itemPath)
		return NO;
	
	NSString* path = [itemPath stringByExpandingTildeInPath];
	return [self fileExistsAtPath:path isDirectory:isDirectory];
}

- (BOOL)itemExistsAtURL:(NSURL*)itemURL
{
	return [self itemExistsAtURL:itemURL isDirectory:NULL];
}

- (BOOL)itemExistsAtURL:(NSURL*)itemURL isDirectory:(BOOL*)isDirectory
{
	if(!itemURL || ![itemURL isFileURL])
		return NO;
	
	return [self itemExistsAtPath:[itemURL path] isDirectory:isDirectory];
}


#pragma mark Item creation management

- (BOOL)createFileAtPath:(NSString*)filePath withIntermediateDirectories:(BOOL)createIntermediates contents:(NSData*)contents attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error
{
	if(!filePath)
		return NO;
	
	NSString* path = [filePath stringByExpandingTildeInPath];
	
	if(createIntermediates)
	{
		// Checks if the parent folder exists and creates it if necessary.
		NSString* parentFolder = [path stringByDeletingLastPathComponent];
		if(![self itemExistsAtPath:parentFolder])
		{
			if(![self createDirectoryAtPath:parentFolder withIntermediateDirectories:YES attributes:attributes error:error])
				return NO;
		}
	}
	
	return [self createFileAtPath:path contents:contents attributes:attributes];
}

- (BOOL)createFileAtURL:(NSURL*)fileURL contents:(NSData*)contents attributes:(NSDictionary*)attributes
{
	if(!fileURL || ![fileURL isFileURL])
		return NO;
	
	return [self createFileAtPath:[fileURL path] withIntermediateDirectories:NO contents:contents attributes:attributes error:nil];
}

- (BOOL)createFileAtURL:(NSURL*)fileURL withIntermediateDirectories:(BOOL)createIntermediates contents:(NSData*)contents attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error
{
	if(!fileURL || ![fileURL isFileURL])
		return NO;
	
	return [self createFileAtPath:[fileURL path] withIntermediateDirectories:createIntermediates contents:contents attributes:attributes error:error];
}


#pragma mark System directories management

- (NSURL*)createTemporaryDirectoryAppropriateForURL:(NSURL*)url
{
	NSError* error;
	NSURL* retObj = [self URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:url create:YES error:&error]; // The temporary directory is created despite the 'create' parameter value.
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: failed to create a temporary directory appropriate for URL '%@'%@.", ClassName, url, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForApplicationSupportDirectory
{
	NSError* error;
	NSURL* retObj = [self URLForSystemDirectory:NSApplicationSupportDirectory error:&error];
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: unable to locate the 'Application Support' system directory%@.", ClassName, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForCachesDirectory
{
	NSError* error;
	NSURL* retObj = [self URLForSystemDirectory:NSCachesDirectory error:&error];
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: unable to locate the 'Caches' system directory%@.", ClassName, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForDocumentsDirectory
{
	NSError* error;
	NSURL* retObj = [self URLForSystemDirectory:NSDocumentDirectory error:&error];
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: unable to locate the 'Documents' system directory%@.", ClassName, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForInboxDirectory
{
	NSError* error;
	NSURL* retObj = [self URLForSystemDirectory:NSDocumentDirectory error:&error];
	
	if(retObj)
		retObj = [retObj URLByAppendingPathComponent:@"Inbox"];
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: unable to locate the 'Inbox' system directory%@.", ClassName, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForLibraryDirectory
{
	NSError* error;
	NSURL* retObj = [self URLForSystemDirectory:NSLibraryDirectory error:&error];
	
	if(!retObj)
	{
		NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"%@: unable to locate the 'Library' system directory%@.", ClassName, errorString];
		[self.logger logMessage:logMessage level:JFLogLevel3Error hashtags:(JFLogHashtagError | JFLogHashtagFilesystem)];
	}
	
	return retObj;
}

- (NSURL*)URLForSystemDirectory:(NSSearchPathDirectory)directory error:(NSError*__autoreleasing*)error
{
	return [self URLForDirectory:directory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:error];
}

- (NSURL*)URLForTempDirectory
{
	NSString* home = NSHomeDirectory();
	if(!home)
		return nil;
	
	NSString* path = [[home stringByExpandingTildeInPath] stringByAppendingPathComponent:@"tmp"];
	return (path ? [NSURL fileURLWithPath:path] : nil);
}

@end

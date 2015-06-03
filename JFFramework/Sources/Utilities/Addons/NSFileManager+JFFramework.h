//
//  NSFileManager+JFFramework.h
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



@interface NSFileManager (JFFramework)

#pragma mark Methods

// Item accessibility management
- (BOOL)	isDeletableItemAtURL:(NSURL*)itemURL;
- (BOOL)	isExecutableItemAtURL:(NSURL*)itemURL;
- (BOOL)	isReadableItemAtURL:(NSURL*)itemURL;
- (BOOL)	isWritableItemAtURL:(NSURL*)itemURL;
- (BOOL)	itemExistsAtPath:(NSString*)itemPath;
- (BOOL)	itemExistsAtPath:(NSString*)itemPath isDirectory:(BOOL*)isDirectory;
- (BOOL)	itemExistsAtURL:(NSURL*)itemURL;
- (BOOL)	itemExistsAtURL:(NSURL*)itemURL isDirectory:(BOOL*)isDirectory;

// Item creation management
- (BOOL)	createFileAtPath:(NSString*)filePath withIntermediateDirectories:(BOOL)createIntermediates contents:(NSData*)contents attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error;
- (BOOL)	createFileAtURL:(NSURL*)fileURL contents:(NSData*)contents attributes:(NSDictionary*)attributes;
- (BOOL)	createFileAtURL:(NSURL*)fileURL withIntermediateDirectories:(BOOL)createIntermediates contents:(NSData*)contents attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error;

// System directories management
- (NSURL*)	createTemporaryDirectoryAppropriateForURL:(NSURL*)url;	// A temporary folder created specifically for the given URL.
- (NSURL*)	URLForApplicationSupportDirectory;	// Contains application support files, like plug-ins. Backed up by iTunes.
- (NSURL*)	URLForCachesDirectory;				// Contains cache files and downloadable content. It may be purged by the system.
- (NSURL*)	URLForDocumentsDirectory;			// Contains critical documents that can not be recreated by the app. Backed up by iTunes.
- (NSURL*)	URLForInboxDirectory;				// Contains files that your app was asked to open by outside entities. Backed up by iTunes.
- (NSURL*)	URLForLibraryDirectory;				// Contains critical files that are not user-related. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectory:(NSSearchPathDirectory)directory error:(NSError*__autoreleasing*)error;	// Convenience method to get the URL for any system directory.
- (NSURL*)	URLForTempDirectory;				// Contains temporary files that should be deleted as soon as possible. It may be purged by the system.

@end

//
//  JFFileManager.h
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



@interface JFFileManager : NSObject

// Memory management
+ (instancetype)	defaultManager;

// File system management
- (BOOL)	createFileAtURL:(NSURL*)fileURL contents:(NSData*)data attributes:(NSDictionary*)attributes;
- (BOOL)	createFolderAtURL:(NSURL*)folderURL attributes:(NSDictionary*)attributes error:(NSError*__autoreleasing*)error;
- (BOOL)	itemExistsAtURL:(NSURL*)itemURL;
- (BOOL)	itemExistsAtURL:(NSURL*)itemURL isDirectory:(BOOL*)isDirectory;
- (BOOL)	setSkipBackupAttributeToItemAtURL:(NSURL*)itemURL;

// System directories management
- (NSURL*)	createTemporaryDirectoryAppropriateForURL:(NSURL*)url;	// A temporary folder created specifically for the given URL.
- (NSURL*)	URLForSystemDirectoryApplicationSupport;				// Contains application support files, like plug-ins. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryCaches;							// Contains cache files and downloadable content. It may be purged by the system.
- (NSURL*)	URLForSystemDirectoryDocuments;							// Contains critical documents that can not be recreated by the app. Backup up by iTunes.
- (NSURL*)	URLForSystemDirectoryInbox;								// Contains files that your app was asked to open by outside entities. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryLibrary;							// Contains critical files that are not user-related. Backed up by iTunes.
- (NSURL*)	URLForSystemDirectoryTemp;								// Contains temporary files that should be deleted as soon as possible. It may be purged by the system.

@end

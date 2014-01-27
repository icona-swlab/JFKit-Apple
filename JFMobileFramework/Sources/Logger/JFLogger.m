//
//  AppLogger.m
//
//  Created by Jacopo Filié on 12/09/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import "JFLogger.h"

#import <pthread.h>

#import "JFConstants.h"
#import "JFFileManager.h"
#import "JFUtilities.h"



@interface JFLogger ()

// Logging management
- (void)	logMessage:(NSString*)message toFile:(NSString*)filePath;

// Utilities
- (NSString*)	hashtagsToString:(LogHashtags)hashtags;
- (BOOL)		shouldClearLogFileAtPath:(NSString*)filePath;

@end



@implementation JFLogger

#pragma mark - Properties

// Data
@synthesize filePath	= _filePath;


#pragma mark - Memory management

+ (instancetype)logger
{
	return [[self alloc] init];
}


#pragma mark - Logging management

- (void)logTo:(LogDestinations)destinations message:(NSString*)message
{
	[self logTo:destinations message:message hashtags:LogHashtagNone];
}

- (void)logTo:(LogDestinations)destinations message:(NSString*)message hashtags:(LogHashtags)hashtags
{
	if(!message)
		return;
	
	// Copies the path to file to be thread safe.
	NSString* filePath = self.filePath;
	
	BOOL logToConsole = (destinations & LogDestinationConsole);
	BOOL logToFile = (filePath && (destinations & LogDestinationFile));
	
	if(!logToConsole && !logToFile)
		return;
	
	NSString* hashtagsString = [self hashtagsToString:hashtags];
	
	if(!IsNullOrEmptyString(hashtagsString))
		message = [message stringByAppendingFormat:@" %@", hashtagsString];
	
	if(logToConsole)
		NSLog(@"%@", message);
	
	if(logToFile)
		[self logMessage:message toFile:filePath];
}

- (void)logMessage:(NSString*)message toFile:(NSString*)filePath
{
	static NSDateFormatter* dateFormatter = nil;
	
	if(!message || !filePath)
		return;
	
	// Prepares the hashtags string in case of error.
	NSString* hashtagsString = [self hashtagsToString:(LogHashtagAttention|LogHashtagFilesystem)];
	
	// Creates an owned instance of a file manager for thread safety.
	JFFileManager* fm = [JFFileManager defaultManager];
	
	// Checks if the file exists and creates it if not.
	BOOL fileExists = [fm itemExistsAtURL:[NSURL fileURLWithPath:filePath] isDirectory:NULL];
	if(!fileExists)
	{
		// Creates an empty file at filepath location.
		fileExists = [fm createFileAtURL:[NSURL fileURLWithPath:filePath] contents:nil attributes:nil];
		if(!fileExists)
		{
			NSLog(@"%@: could not create log file at path '%@'. %@", SelfClassString, filePath, hashtagsString);
			return;
		}
	}
	
	// Prepares the date formatter (NSDateFormatter is NOT thread safe).
	@synchronized(self)
	{
		// Creates the date formatter if not already done.
		if(!dateFormatter)
		{
			dateFormatter = [NSDateFormatter new];
			dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
			dateFormatter.locale = [NSLocale currentLocale];
			dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
		}
	}
	
	// Creates the date string in a thread safe scope.
	NSString* dateString = nil;
	@synchronized(dateFormatter)
	{
		dateString = [dateFormatter stringFromDate:[NSDate date]];
	}
	
	// Gets the current thread ID.
	mach_port_t threadID = pthread_mach_thread_np(pthread_self());
	
	// Incapsulate the message.
	message = [NSString stringWithFormat:@"%@ [%x] %@\n", dateString, threadID, message];
	
	// Prepares the data to be written.
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	if(!data)
	{
		NSLog(@"%@: failed to create data from log message '%@'. %@", SelfClassString, message, hashtagsString);
		return;
	}
	
	// Checks if the file should be cleared before appending the new log.
	BOOL clearLog = NO; //[self shouldClearLogFileAtPath:filePath]; // TODO: implement new logic.
	
	// Tries to append the data to the log file (NSFileHandle is NOT thread safe).
	@synchronized(self)
	{
		// Opens the file.
		NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:filePath];
		if(!fh)
		{
			NSLog(@"%@: could not open the log file at path '%@'. %@", SelfClassString, filePath, hashtagsString);
			return;
		}
		
		// Checks if the file should be cleared before appending the new log.
		if(clearLog)
			[fh truncateFileAtOffset:0];
		
		// Goes to the end of the file to append new messages.
		[fh seekToEndOfFile];
		
		// Writes the data.
		[fh writeData:data];
		
		// Closes the file.
		[fh closeFile];
	}
}


#pragma mark - Utilities

- (NSString*)hashtagsToString:(LogHashtags)hashtags
{
	// Prepares the temporary buffer.
	NSMutableArray* hashtagStrings = [NSMutableArray array];
	
	// Inserts each requested string.
	if(hashtags & LogHashtagAttention)	[hashtagStrings addObject:@"#Attention"];
	if(hashtags & LogHashtagClue)		[hashtagStrings addObject:@"#Clue"];
	if(hashtags & LogHashtagComment)	[hashtagStrings addObject:@"#Comment"];
	if(hashtags & LogHashtagCritical)	[hashtagStrings addObject:@"#Critical"];
	if(hashtags & LogHashtagDeveloper)	[hashtagStrings addObject:@"#Developer"];
	if(hashtags & LogHashtagError)		[hashtagStrings addObject:@"#Error"];
	if(hashtags & LogHashtagFilesystem)	[hashtagStrings addObject:@"#Filesystem"];
	if(hashtags & LogHashtagHardware)	[hashtagStrings addObject:@"#Hardware"];
	if(hashtags & LogHashtagMarker)		[hashtagStrings addObject:@"#Marker"];
	if(hashtags & LogHashtagNetwork)	[hashtagStrings addObject:@"#Network"];
	if(hashtags & LogHashtagSecurity)	[hashtagStrings addObject:@"#Security"];
	if(hashtags & LogHashtagSystem)		[hashtagStrings addObject:@"#System"];
	if(hashtags & LogHashtagUser)		[hashtagStrings addObject:@"#User"];
	
	return [hashtagStrings componentsJoinedByString:@" "];
}

- (BOOL)shouldClearLogFileAtPath:(NSString*)filePath
{
	static NSCalendar* calendar = nil;
	
	if(!filePath)
		return NO;
	
	// Creates an owned instance of a file manager for thread safety.
	NSFileManager* fm = [NSFileManager new];
	
	// Retrieves the last modification date attribute of the file.
	NSError* error = nil;
	NSDictionary* attributes = [fm attributesOfItemAtPath:filePath error:&error];
	NSDate* lastModifiedDate = [attributes fileModificationDate];
	if(error || !lastModifiedDate)
	{
		NSString* hashtagsString = [self hashtagsToString:(LogHashtagAttention|LogHashtagFilesystem)];
		NSLog(@"%@: could not read the 'last modification date' attribute of log file at path '%@' for error '%@'. %@", SelfClassString, filePath, error, hashtagsString);
		return NO;
	}
	
	// Prepares the calendar (NSCalendar is NOT thread safe).
	@synchronized(self)
	{
		// Creates the date formatter if not already done.
		if(!calendar)
			calendar = [NSCalendar currentCalendar];
	}
	
	// Prepares the date objects for comparison in a thread safe scope.
	NSDate* date1 = nil;
	NSDate* date2 = nil;
	@synchronized(calendar)
	{
		NSUInteger components = (NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit);
		NSDateComponents* dc1 = [calendar components:components fromDate:lastModifiedDate];
		NSDateComponents* dc2 = [calendar components:components fromDate:[NSDate date]];
		date1 = [calendar dateFromComponents:dc1];
		date2 = [calendar dateFromComponents:dc2];
	}
	
	// Returns YES if not the same day.
	return ![date1 isEqualToDate:date2];
}

@end

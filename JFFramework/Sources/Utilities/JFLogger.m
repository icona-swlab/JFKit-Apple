//
//  JFLogger.m
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



#import "JFLogger.h"

#import <pthread.h>

#import "NSFileManager+JFFramework.h"

#import "JFUtilities.h"



@interface JFLogger ()

#pragma mark Properties

// Formatting
@property (strong, nonatomic, readonly)	NSDateFormatter*	dateFormatter;


#pragma mark Methods

// Memory management
- (void)	commonInitialization;

// Logging management
- (void)	logMessageToConsole:(NSString*)message;
- (void)	logMessageToFile:(NSString*)message;
- (void)	replaceLogFile;
- (BOOL)	shouldReplaceLogFile;

// Utilities management
- (NSString*)	hashtagsToString:(JFLogHashtags)hashtags;

@end



#pragma mark



@implementation JFLogger

#pragma mark Properties

// Formatting
@synthesize dateFormatter	= _dateFormatter;

// Settings
@synthesize destinations			= _destinations;
@synthesize expirationTimeInterval	= _expirationTimeInterval;
@synthesize fileURL					= _fileURL;
@synthesize level					= _level;


#pragma mark Properties accessors (Settings)

- (JFLogDestinations)destinations
{
	@synchronized(self)
	{
		return _destinations;
	}
}

- (void)setDestinations:(JFLogDestinations)destinations
{
	if((destinations & JFLogDestinationFile) && !self.fileURL)
		destinations = destinations & ~JFLogDestinationFile;
	
	if(destinations == 0)
		return;
	
	@synchronized(self)
	{
		_destinations = destinations;
	}
}


#pragma mark Memory management

+ (instancetype)defaultLogger
{
	static dispatch_once_t onceToken;
	static id defaultLogger;
	
	dispatch_once(&onceToken, ^{
		NSString* fileName = [AppName stringByAppendingPathExtension:@"log"];
		NSURL* url = [[[NSFileManager defaultManager] URLForApplicationSupportDirectory] URLByAppendingPathComponent:fileName];
		defaultLogger = (url ? [[self alloc] initWithFileURL:url] : [[self alloc] init]);
	});
	
	return defaultLogger;
}

- (void)commonInitialization
{
	NSDateFormatter* dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss.SSS";
	dateFormatter.locale = [NSLocale currentLocale];
	dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
	
	// Formatting
	_dateFormatter = dateFormatter;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		[self commonInitialization];
		
		// Settings
		_destinations = JFLogDestinationConsole;
	}
	return self;
}

- (instancetype)initWithFileURL:(NSURL*)fileURL
{
	BOOL abort = (!fileURL || ![fileURL isFileURL]);
	self = (abort ? nil : [super init]);
	if(self)
	{
		[self commonInitialization];
		
		// Settings
		_destinations = (JFLogDestinationConsole | JFLogDestinationFile);
		_fileURL = fileURL;
	}
	return self;
}


#pragma mark Logging management

- (void)logMessage:(NSString*)message level:(JFLogLevel)level
{
	[self logMessage:message toDestinations:self.destinations level:level];
}

- (void)logMessage:(NSString*)message level:(JFLogLevel)level hashtags:(JFLogHashtags)hashtags
{
	[self logMessage:message toDestinations:self.destinations level:level hashtags:hashtags];
}

- (void)logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations level:(JFLogLevel)level
{
	[self logMessage:message toDestinations:destinations level:level hashtags:JFLogHashtagsNone];
}

- (void)logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations level:(JFLogLevel)level hashtags:(JFLogHashtags)hashtags
{
	if(!message || (level > self.level))
		return;
	
	BOOL logToConsole = (destinations & JFLogDestinationConsole);
	BOOL logToFile = (self.fileURL && (destinations & JFLogDestinationFile));
	
	if(!logToConsole && !logToFile)
		return;
	
	NSString* hashtagsString = [self hashtagsToString:hashtags];
	
	if(!IsNullOrEmptyString(hashtagsString))
		message = [message stringByAppendingFormat:@" %@", hashtagsString];
	
	if(logToConsole)	[self logMessageToConsole:message];
	if(logToFile)		[self logMessageToFile:message];
}

- (void)logMessageToConsole:(NSString*)message
{
	NSLog(@"%@", message);
}

- (void)logMessageToFile:(NSString*)message
{
	if(!message)
		return;
	
	// Prepares the hashtags string in case of error.
	NSString* hashtagsString = [self hashtagsToString:(JFLogHashtagError | JFLogHashtagFilesystem)];
	
	// Checks if the file exists and creates it if not.
	NSFileManager* fm = [NSFileManager defaultManager];
	BOOL fileExists = [fm itemExistsAtURL:self.fileURL isDirectory:NULL];
	if(!fileExists)
	{
		// Creates an empty file at 'fileURL' location.
		NSError* error = nil;
		fileExists = [fm createFileAtURL:self.fileURL withIntermediateDirectories:YES contents:nil attributes:nil error:&error];
		if(!fileExists)
		{
			NSString* errorString = (error ? [NSString stringWithFormat:@" for error '%@'", [error description]] : EmptyString);
			NSString* logMessage = [NSString stringWithFormat:@"%@: could not create log file at URL '%@'%@. %@", ClassName, [self.fileURL absoluteString], errorString, hashtagsString];
			[self logMessageToConsole:logMessage];
			return;
		}
	}
	
	// Creates the date string in a thread safe scope.
	NSString* dateString = nil;
	@synchronized(self.dateFormatter)
	{
		dateString = [self.dateFormatter stringFromDate:[NSDate date]];
	}
	
	// Gets the current thread ID.
	mach_port_t threadID = pthread_mach_thread_np(pthread_self());
	
	// Encapsulate the message.
	message = [NSString stringWithFormat:@"%@ [%x] %@\n", dateString, threadID, message];
	
	// Prepares the data to be written.
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	if(!data)
	{
		NSLog(@"%@: failed to create data from log message '%@'. %@", ClassName, message, hashtagsString);
		return;
	}
	
	// Tries to append the data to the log file (NSFileHandle is NOT thread safe).
	@synchronized(self)
	{
		// Opens the file.
		NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:[self.fileURL path]];
		if(!fh)
		{
			NSLog(@"%@: could not open the log file at path '%@'. %@", ClassName, [self.fileURL path], hashtagsString);
			return;
		}
		
		// Goes to the end of the file, appends the new message and closes the file.
		[fh seekToEndOfFile];
		[fh writeData:data];
		[fh closeFile];
	}
}

- (void)replaceLogFile
{}

- (BOOL)shouldReplaceLogFile
{
	return NO;
	
//	static NSCalendar* calendar = nil;
//	
//	if(!filePath)
//		return NO;
//	
//	// Creates an owned instance of a file manager for thread safety.
//	NSFileManager* fm = [[NSFileManager alloc] init];
//	
//	// Retrieves the last modification date attribute of the file.
//	NSError* error = nil;
//	NSDictionary* attributes = [fm attributesOfItemAtPath:filePath error:&error];
//	NSDate* lastModifiedDate = [attributes fileModificationDate];
//	if(error || !lastModifiedDate)
//	{
//		NSString* hashtagsString = [self hashtagsToString:(LogHashtagAttention|LogHashtagFilesystem)];
//		NSLog(@"%@: could not read the 'last modification date' attribute of log file at path '%@' for error '%@'. %@", SelfClassString, filePath, error, hashtagsString);
//		return NO;
//	}
//	
//	// Prepares the calendar (NSCalendar is NOT thread safe).
//	@synchronized(self)
//	{
//		// Creates the date formatter if not already done.
//		if(!calendar)
//			calendar = [NSCalendar currentCalendar];
//	}
//	
//	// Prepares the date objects for comparison in a thread safe scope.
//	NSDate* date1 = nil;
//	NSDate* date2 = nil;
//	@synchronized(calendar)
//	{
//		NSUInteger components = (NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit);
//		NSDateComponents* dc1 = [calendar components:components fromDate:lastModifiedDate];
//		NSDateComponents* dc2 = [calendar components:components fromDate:[NSDate date]];
//		date1 = [calendar dateFromComponents:dc1];
//		date2 = [calendar dateFromComponents:dc2];
//	}
//	
//	// Returns YES if not the same day.
//	return ![date1 isEqualToDate:date2];
}


#pragma mark Utilities management

- (NSString*)hashtagsToString:(JFLogHashtags)hashtags
{
	// Prepares the temporary buffer.
	NSMutableArray* hashtagStrings = [NSMutableArray array];
	
	// Inserts each requested string.
	if(hashtags & JFLogHashtagAttention)	[hashtagStrings addObject:@"#Attention"];
	if(hashtags & JFLogHashtagClue)			[hashtagStrings addObject:@"#Clue"];
	if(hashtags & JFLogHashtagComment)		[hashtagStrings addObject:@"#Comment"];
	if(hashtags & JFLogHashtagCritical)		[hashtagStrings addObject:@"#Critical"];
	if(hashtags & JFLogHashtagDeveloper)	[hashtagStrings addObject:@"#Developer"];
	if(hashtags & JFLogHashtagError)		[hashtagStrings addObject:@"#Error"];
	if(hashtags & JFLogHashtagFilesystem)	[hashtagStrings addObject:@"#Filesystem"];
	if(hashtags & JFLogHashtagHardware)		[hashtagStrings addObject:@"#Hardware"];
	if(hashtags & JFLogHashtagMarker)		[hashtagStrings addObject:@"#Marker"];
	if(hashtags & JFLogHashtagNetwork)		[hashtagStrings addObject:@"#Network"];
	if(hashtags & JFLogHashtagSecurity)		[hashtagStrings addObject:@"#Security"];
	if(hashtags & JFLogHashtagSystem)		[hashtagStrings addObject:@"#System"];
	if(hashtags & JFLogHashtagUser)			[hashtagStrings addObject:@"#User"];
	
	return [hashtagStrings componentsJoinedByString:@" "];
}

@end

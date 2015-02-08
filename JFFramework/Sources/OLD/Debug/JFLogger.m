//
//  JFLogger.m
//  Copyright (C) 2013  Jacopo Filié
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

#import "JFFileManager.h"
#import "JFUtilities.h"



@interface JFLogger ()

// Formatting
@property (strong, nonatomic, readonly)	NSDateFormatter*	dateFormatter;

// Memory management
- (void)	commonInitialization;

// Logging management
- (void)	logMessageToConsole:(NSString*)message;
- (void)	logMessageToFile:(NSString*)message;

// Utilities
- (NSString*)	hashtagsToString:(LogHashtags)hashtags;

@end



@implementation JFLogger

#pragma mark - Properties

// Formatting
@synthesize dateFormatter	= _dateFormatter;

// Settings
@synthesize destinations	= _destinations;
@synthesize fileURL			= _fileURL;


#pragma mark - Properties accessors (Settings)

- (LogDestinations)destinations
{
	@synchronized(self)
	{
		return _destinations;
	}
}

- (void)setDestinations:(LogDestinations)destinations
{
	if((destinations & LogDestinationFile) && !self.fileURL)
		destinations = destinations & ~LogDestinationFile;
	
	if(destinations == 0)
		return;
	
	@synchronized(self)
	{
		_destinations = destinations;
	}
}


#pragma mark - Memory management

+ (instancetype)defaultLogger
{
	static dispatch_once_t onceToken;
	static id defaultLogger;
	
	dispatch_once(&onceToken, ^{
		NSString* fileName = [AppName stringByAppendingPathExtension:@"log"];
		NSURL* url = [[[JFFileManager defaultManager] URLForSystemDirectoryApplicationSupport] URLByAppendingPathComponent:fileName];
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
		_destinations = LogDestinationConsole;
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
		_destinations = (LogDestinationConsole | LogDestinationFile);
		_fileURL = fileURL;
	}
	return self;
}


#pragma mark - Logging management

- (void)logMessage:(NSString*)message
{
	[self logMessage:message toDestinations:self.destinations];
}

- (void)logMessage:(NSString*)message hashtags:(LogHashtags)hashtags
{
	[self logMessage:message toDestinations:self.destinations hashtags:hashtags];
}

- (void)logMessage:(NSString*)message toDestinations:(LogDestinations)destinations
{
	[self logMessage:message toDestinations:destinations hashtags:LogHashtagsNone];
}

- (void)logMessage:(NSString*)message toDestinations:(LogDestinations)destinations hashtags:(LogHashtags)hashtags
{
	if(!message)
		return;
	
	BOOL logToConsole = (destinations & LogDestinationConsole);
	BOOL logToFile = (self.fileURL && (destinations & LogDestinationFile));
	
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
	NSString* hashtagsString = [self hashtagsToString:(LogHashtagAttention|LogHashtagFilesystem)];
	
	// Checks if the file exists and creates it if not.
	JFFileManager* fm = [JFFileManager defaultManager];
	BOOL fileExists = [fm itemExistsAtURL:self.fileURL isDirectory:NULL];
	if(!fileExists)
	{
		// Creates an empty file at 'fileURL' location.
		fileExists = [fm createFileAtURL:self.fileURL contents:nil attributes:nil];
		if(!fileExists)
		{
			NSLog(@"%@: could not create log file at path '%@'. %@", ClassName, [self.fileURL path], hashtagsString);
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
	
	// Incapsulate the message.
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

@end

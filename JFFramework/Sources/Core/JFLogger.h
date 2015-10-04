//
//  JFLogger.h
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



#import "NSObject+JFLogger.h"



#pragma mark - Notes

/*
 It should be added a way to refresh the log file (while doing a backup of the old one) after a chosen time has passed of after a chosen file size has been reached.
 */



#pragma mark - Typedefs

typedef NS_OPTIONS(UInt8, JFLogDestinations)
{
	JFLogDestinationConsole	= 1 << 0,	// Logs the message into the console.
	JFLogDestinationFile	= 1 << 1,	// Logs the message into the file if 'fileURL' is set.
};

typedef NS_OPTIONS(UInt16, JFLogHashtags)
{
	JFLogHashtagsNone		= 0,		// Message is not associated to any hashtag.
	
	JFLogHashtagAttention	= 1 << 0,	// Message that should be investigated by a system administrator, because it may be a sign of a larger issue. For example, errors from a hard drive controller that typically occur when the drive is about to fail.
	JFLogHashtagClue		= 1 << 1,	// Message containing extra key/value pairs with additional information to help reconstruct the context.
	JFLogHashtagComment		= 1 << 2,	// Message that is a comment.
	JFLogHashtagCritical	= 1 << 3,	// Message in the context of a critical event or critical failure.
	JFLogHashtagDeveloper	= 1 << 4,	// Message in the context of software development. For example, deprecated APIs and debugging messages.
	JFLogHashtagError		= 1 << 5,	// Message that is a noncritical error.
	JFLogHashtagFilesystem	= 1 << 6,	// Message describing a file system related event.
	JFLogHashtagHardware	= 1 << 7,	// Message describing a hardware-related event.
	JFLogHashtagMarker		= 1 << 8,	// Message that marks a change to divide the messages around it into those before and those after the change.
	JFLogHashtagNetwork		= 1 << 9,	// Message describing a network-related event.
	JFLogHashtagSecurity	= 1 << 10,	// Message related to security concerns.
	JFLogHashtagSystem		= 1 << 11,	// Message in the context of a system process.
	JFLogHashtagUser		= 1 << 12,	// Message in the context of a user process.
};

typedef NS_OPTIONS(UInt8, JFLogLevel)
{
	JFLogLevel0Emergency,	// The highest priority, usually reserved for catastrophic failures and reboot notices.
	JFLogLevel1Alert,		// A serious failure in a key system.
	JFLogLevel2Critical,	// A failure in a key system.
	JFLogLevel3Error,		// Something has failed.
	JFLogLevel4Warning,		// Something is amiss and might fail if not corrected.
	JFLogLevel5Notice,		// Things of moderate interest to the user or administrator.
	JFLogLevel6Info,		// The lowest priority that you would normally log, and purely informational in nature.
	JFLogLevel7Debug,		// The lowest priority, and normally not logged except for messages from the kernel.
};



#pragma mark



@interface JFLogger : NSObject

#pragma mark Properties

// Settings
@property (assign)						JFLogDestinations	destinations;
@property (strong, nonatomic, readonly)	NSURL*				fileURL;
@property (assign)						JFLogLevel			level;	// Only messages that have a lower (or equal) level value will be logged.


#pragma mark Methods

// Memory management
+ (instancetype)	defaultLogger;	// It can log to the default log file called "<Application name>.log" inside the Application Support folder.
- (instancetype)	initWithFileURL:(NSURL*)fileURL;

// Logging management
- (void)	logMessage:(NSString*)message level:(JFLogLevel)level;
- (void)	logMessage:(NSString*)message level:(JFLogLevel)level hashtags:(JFLogHashtags)hashtags;
- (void)	logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations level:(JFLogLevel)level;
- (void)	logMessage:(NSString*)message toDestinations:(JFLogDestinations)destinations level:(JFLogLevel)level hashtags:(JFLogHashtags)hashtags;

@end
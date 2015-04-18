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



#pragma mark Typedefs

typedef NS_OPTIONS(UInt8, JFLogDestinations)
{
	JFLogDestinationConsole	= 1 << 0,	// Logs the message into the console.
	JFLogDestinationFile	= 1 << 1,	// Logs the message into the file if 'fileURL' is set.
};

typedef NS_OPTIONS(UInt8, JFLogExpirationTimeInterval)	// NOT YET IMPLEMENTED
{
	JFLogExpirationTimeIntervalNone,		// The log file has no expiration time.
	JFLogExpirationTimeIntervalOneDay,		// The log file will be changed every day.
	JFLogExpirationTimeIntervalOneWeek,		// The log file will be changed each monday.
	JFLogExpirationTimeIntervalOneMonth,	// The log file will be changed the 1st day of each month.
	
	JFLogExpirationTimeIntervalDefault = JFLogExpirationTimeIntervalNone
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
	JFLogLevelEmergency,	// The highest priority, usually reserved for catastrophic failures and reboot notices.
	JFLogLevelAlert,		// A serious failure in a key system.
	JFLogLevelCritical,		// A failure in a key system.
	JFLogLevelError,		// Something has failed.
	JFLogLevelWarning,		// Something is amiss and might fail if not corrected.
	JFLogLevelNotice,		// Things of moderate interest to the user or administrator.
	JFLogLevelInfo,			// The lowest priority that you would normally log, and purely informational in nature.
	JFLogLevelDebug,		// The lowest priority, and normally not logged except for messages from the kernel.
	
	JFLogLevelDefault = JFLogLevelNotice
};



#pragma mark



@interface JFLogger : NSObject

#pragma mark Properties

// Settings
@property (assign)						JFLogDestinations			destinations;
@property (assign)						JFLogExpirationTimeInterval	expirationTimeInterval;	// TODO: not yet implemented.
@property (strong, nonatomic, readonly)	NSURL*						fileURL;
@property (assign)						JFLogLevel					level;	// Only messages that have a lower (or equal) level value will be logged.


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

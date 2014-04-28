//
//  JFLogger.h
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



#import <Foundation/Foundation.h>



typedef NS_OPTIONS(UInt8, LogDestinations)
{
	LogDestinationConsole	= 1 << 0,	// Logs the message into the console.
	LogDestinationFile		= 1 << 1,	// Logs the message into the file if 'fileURL' is set.
};

typedef NS_OPTIONS(UInt16, LogHashtags)
{
	LogHashtagsNone			= 0,		// Message is not associated to any hashtag.
	
	LogHashtagAttention		= 1 << 0,	// Message that should be investigated by a system administrator, because it may be a sign of a larger issue. For example, errors from a hard drive controller that typically occur when the drive is about to fail.
	LogHashtagClue			= 1 << 1,	// Message containing extra key/value pairs with additional information to help reconstruct the context.
	LogHashtagComment		= 1 << 2,	// Message that is a comment.
	LogHashtagCritical		= 1 << 3,	// Message in the context of a critical event or critical failure.
	LogHashtagDeveloper		= 1 << 4,	// Message in the context of software development. For example, deprecated APIs and debugging messages.
	LogHashtagError			= 1 << 5,	// Message that is a noncritical error.
	LogHashtagFilesystem	= 1 << 6,	// Message describing a file system related event.
	LogHashtagHardware		= 1 << 7,	// Message describing a hardware-related event.
	LogHashtagMarker		= 1 << 8,	// Message that marks a change to divide the messages around it into those before and those after the change.
	LogHashtagNetwork		= 1 << 9,	// Message describing a network-related event.
	LogHashtagSecurity		= 1 << 10,	// Message related to security concerns.
	LogHashtagSystem		= 1 << 11,	// Message in the context of a system process.
	LogHashtagUser			= 1 << 12,	// Message in the context of a user process.
};



@interface JFLogger : NSObject

// Settings
@property (assign)						LogDestinations	destinations;
@property (strong, nonatomic, readonly)	NSURL*			fileURL;

// Memory management
+ (instancetype)	defaultLogger;	// It can log to the default log file called <Application name>.log inside the Application Support folder.
- (instancetype)	initWithFileURL:(NSURL*)fileURL;

// Logging management
- (void)	logMessage:(NSString*)message;
- (void)	logMessage:(NSString*)message hashtags:(LogHashtags)hashtags;
- (void)	logMessage:(NSString*)message toDestinations:(LogDestinations)destinations;
- (void)	logMessage:(NSString*)message toDestinations:(LogDestinations)destinations hashtags:(LogHashtags)hashtags;

@end

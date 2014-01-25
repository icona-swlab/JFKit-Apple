//
//  AppLogger.h
//
//  Created by Jacopo Filié on 12/09/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>



typedef NS_OPTIONS(UInt8, LogDestinations)
{
	LogDestinationConsole	= 1 << 0,
	LogDestinationFile		= 1 << 1,
};

typedef NS_OPTIONS(UInt16, LogHashtags)
{
	LogHashtagNone			= 0,
	
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

// Data
@property (copy)	NSString*	filePath;

// Memory management
+ (instancetype)	logger;

// Logging management
- (void)	logTo:(LogDestinations)destinations message:(NSString*)message;
- (void)	logTo:(LogDestinations)destinations message:(NSString*)message hashtags:(LogHashtags)hashtags;

@end

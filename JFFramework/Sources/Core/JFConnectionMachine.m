//
//  JFConnectionMachine.m
//  Livelet-iOS
//
//  Created by Jacopo Filié on 15/10/15.
//  Copyright © 2015 Jacopo Filié. All rights reserved.
//



#import "JFConnectionMachine.h"

#import "JFLogger.h"
#import "JFString.h"



#pragma mark - Typedefs

typedef NS_ENUM(UInt8, JFConnectionMachineCommand)
{
	JFConnectionMachineCommandConnect,
	JFConnectionMachineCommandDisconnect,
	JFConnectionMachineCommandReconnect,
	JFConnectionMachineCommandReset,
};



#pragma mark



@interface JFConnectionMachine ()

#pragma mark Properties

// Connection
@property (strong, nonatomic)	JFBlockWithBOOL	connectCompletion;
@property (strong, nonatomic)	JFBlockWithBOOL	disconnectCompletion;
@property (strong, nonatomic)	JFBlockWithBOOL	reconnectCompletion;
@property (strong, nonatomic)	JFBlockWithBOOL	resetCompletion;

// Flags
@property (assign, readwrite)	JFConnectionState	state;


#pragma mark Methods

// Connection management
- (BOOL)	canPerformCommand:(JFConnectionMachineCommand)command;

@end



#pragma mark



@implementation JFConnectionMachine

#pragma mark Properties

// Connection
@synthesize connectCompletion		= _connectCompletion;
@synthesize disconnectCompletion	= _disconnectCompletion;
@synthesize reconnectCompletion		= _reconnectCompletion;
@synthesize resetCompletion			= _resetCompletion;

// Flags
@synthesize state	= _state;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Properties accessors (Flags)

- (JFConnectionState)state
{
	@synchronized(self)
	{
		return _state;
	}
}

- (void)setState:(JFConnectionState)state
{
	JFConnectionState oldState;
	
	@synchronized(self)
	{
		if(_state == state)
			return;
		
		oldState = _state;
		_state = state;
	}
	
	if([self shouldDebugLog])
	{
		NSString* oldString = JFDebugStringFromConnectionState(oldState);
		NSString* newString = JFDebugStringFromConnectionState(_state);
		
		NSString* logMessage = [NSString stringWithFormat:@"Connection machine '%@' state changed from '%@' to '%@'.", JFStringFromObject(self), oldString, newString];
		[self.logger logMessage:logMessage level:JFLogLevel7Debug hashtags:(JFLogHashtagDeveloper | JFLogHashtagNetwork)];
	}
	
	id<JFConnectionMachineDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(connectionMachine:didChangeState:oldState:)])
		[delegate connectionMachine:self didChangeState:state oldState:oldState];
}


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<JFConnectionMachineDelegate>)delegate
{
	self = (delegate ? [super init] : nil);
	if(self)
	{
		// Flags
		_state = JFConnectionStateReady;
		
		// Relationships
		_delegate = delegate;
	}
	return self;
}


#pragma mark Connection management

- (BOOL)canPerformCommand:(JFConnectionMachineCommand)command
{
	BOOL isConnect		= (command == JFConnectionMachineCommandConnect);
	BOOL isDisconnect	= (command == JFConnectionMachineCommandDisconnect);
	BOOL isReconnect	= (command == JFConnectionMachineCommandReconnect);
	BOOL isReset		= (command == JFConnectionMachineCommandReset);
	
	BOOL retVal = NO;
	switch(self.state)
	{
		case JFConnectionStateConnected:		retVal = isDisconnect;					break;
		case JFConnectionStateConnecting:		retVal = isDisconnect;					break;
		case JFConnectionStateDisconnected:		retVal = isReset;						break;
		case JFConnectionStateDisconnecting:	retVal = NO;							break;
		case JFConnectionStateLost:				retVal = (isDisconnect || isReconnect);	break;
		case JFConnectionStateReady:			retVal = (isConnect || isReset);		break;
		case JFConnectionStateReconnecting:		retVal = isDisconnect;					break;
		case JFConnectionStateResetting:		retVal = NO;							break;
		case JFConnectionStateUnknown:			retVal = isReset;						break;
			
		default:
			break;
	}
	return retVal;
}

- (BOOL)connect
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandConnect])
			return NO;
		
		self.state = JFConnectionStateConnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.connectCompletion = ^(BOOL succeeded)
	{
		__strong typeof(self) strongSelf = weakSelf;
		if(!strongSelf)
			return;
		
		strongSelf.connectCompletion = nil;
		
		@synchronized(strongSelf)
		{
			if(strongSelf.state == JFConnectionStateConnecting)
				strongSelf.state = (succeeded ? JFConnectionStateConnected : JFConnectionStateLost);
		}
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachinePerformConnect:self];
	}];
	
	return YES;
}

- (BOOL)disconnect
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandDisconnect])
			return NO;
		
		self.state = JFConnectionStateDisconnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.disconnectCompletion = ^(BOOL succeeded)
	{
		__strong typeof(self) strongSelf = weakSelf;
		if(!strongSelf)
			return;
		
		strongSelf.disconnectCompletion = nil;
		
		@synchronized(strongSelf)
		{
			if(strongSelf.state == JFConnectionStateDisconnecting)
				strongSelf.state = (succeeded ? JFConnectionStateDisconnected : JFConnectionStateUnknown);
		}
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachinePerformDisconnect:self];
	}];
	
	return YES;
}

- (BOOL)reconnect
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandReconnect])
			return NO;
		
		self.state = JFConnectionStateReconnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.reconnectCompletion = ^(BOOL succeeded)
	{
		__strong typeof(self) strongSelf = weakSelf;
		if(!strongSelf)
			return;
		
		strongSelf.reconnectCompletion = nil;
		
		@synchronized(strongSelf)
		{
			if(strongSelf.state == JFConnectionStateReconnecting)
				strongSelf.state = (succeeded ? JFConnectionStateConnected : JFConnectionStateLost);
		}
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachinePerformReconnect:self];
	}];
	
	return YES;
}

- (BOOL)reset
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandReset])
			return NO;
		
		self.state = JFConnectionStateResetting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.resetCompletion = ^(BOOL succeeded)
	{
		__strong typeof(self) strongSelf = weakSelf;
		if(!strongSelf)
			return;
		
		strongSelf.resetCompletion = nil;
		
		@synchronized(strongSelf)
		{
			if(strongSelf.state == JFConnectionStateResetting)
				strongSelf.state = (succeeded ? JFConnectionStateReady : JFConnectionStateUnknown);
		}
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachinePerformReset:self];
	}];
	
	return YES;
}


#pragma mark Connection management (Events)

- (void)onConnectCompleted:(BOOL)succeeded
{
	if(self.connectCompletion)
		self.connectCompletion(succeeded);
}

- (void)onConnectionLost
{
	@synchronized(self)
	{
		if(self.state != JFConnectionStateConnected)
			return;
		
		self.state = JFConnectionStateLost;
	}
}

- (void)onDisconnectCompleted:(BOOL)succeeded
{
	if(self.disconnectCompletion)
		self.disconnectCompletion(succeeded);
}

- (void)onReconnectCompleted:(BOOL)succeeded
{
	if(self.reconnectCompletion)
		self.reconnectCompletion(succeeded);
}

- (void)onResetCompleted:(BOOL)succeeded
{
	if(self.resetCompletion)
		self.resetCompletion(succeeded);
}

@end

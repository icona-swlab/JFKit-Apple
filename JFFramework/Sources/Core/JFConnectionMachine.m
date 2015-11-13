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
@property (strong, nonatomic)	JFSimpleCompletionBlock	connectCompletion;
@property (strong, nonatomic)	JFSimpleCompletionBlock	disconnectCompletion;
@property (strong, nonatomic)	JFSimpleCompletionBlock	reconnectCompletion;
@property (strong, nonatomic)	JFSimpleCompletionBlock	resetCompletion;

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
		
		id<JFConnectionMachineDelegate> delegate = self.delegate;
		NSString* delegateString = (delegate ? [NSString stringWithFormat:@" (delegate: '%@')", JFStringFromObject(delegate)] : JFEmptyString);
		NSString* logMessage = [NSString stringWithFormat:@"Connection machine '%@'%@ state changed from '%@' to '%@'.", JFStringFromObject(self), delegateString, oldString, newString];
		[self.logger logMessage:logMessage level:JFLogLevel7Debug hashtags:(JFLogHashtagDeveloper | JFLogHashtagNetwork)];
	}
	
	[MainOperationQueue addOperationWithBlock:^{
		id<JFConnectionMachineDelegate> delegate = self.delegate;
		if(delegate && [delegate respondsToSelector:@selector(connectionMachine:didChangeState:oldState:)])
			[delegate connectionMachine:self didChangeState:state oldState:oldState];
	}];
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
	return [self connect:nil];
}

- (BOOL)connect:(NSDictionary*)userInfo
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandConnect])
			return NO;
		
		self.state = JFConnectionStateConnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.connectCompletion = ^(BOOL succeeded, NSError* error)
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
		
		[MainOperationQueue addOperationWithBlock:^{
			if([strongSelf.delegate respondsToSelector:@selector(connectionMachine:didConnect:succeeded:error:)])
				[strongSelf.delegate connectionMachine:strongSelf didConnect:userInfo succeeded:succeeded error:error];
		}];
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachine:self performConnect:userInfo];
	}];
	
	return YES;
}

- (BOOL)disconnect
{
	return [self disconnect:nil];
}

- (BOOL)disconnect:(NSDictionary*)userInfo
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandDisconnect])
			return NO;
		
		self.state = JFConnectionStateDisconnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.disconnectCompletion = ^(BOOL succeeded, NSError* error)
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
		
		[MainOperationQueue addOperationWithBlock:^{
			if([strongSelf.delegate respondsToSelector:@selector(connectionMachine:didDisconnect:succeeded:error:)])
				[strongSelf.delegate connectionMachine:strongSelf didDisconnect:userInfo succeeded:succeeded error:error];
		}];
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachine:self performDisconnect:userInfo];
	}];
	
	return YES;
}

- (BOOL)reconnect
{
	return [self reconnect:nil];
}

- (BOOL)reconnect:(NSDictionary*)userInfo
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandReconnect])
			return NO;
		
		self.state = JFConnectionStateReconnecting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.reconnectCompletion = ^(BOOL succeeded, NSError* error)
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
		
		[MainOperationQueue addOperationWithBlock:^{
			if([strongSelf.delegate respondsToSelector:@selector(connectionMachine:didReconnect:succeeded:error:)])
				[strongSelf.delegate connectionMachine:strongSelf didReconnect:userInfo succeeded:succeeded error:error];
		}];
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachine:self performReconnect:userInfo];
	}];
	
	return YES;
}

- (BOOL)reset
{
	return [self reset:nil];
}

- (BOOL)reset:(NSDictionary*)userInfo
{
	@synchronized(self)
	{
		if(![self canPerformCommand:JFConnectionMachineCommandReset])
			return NO;
		
		self.state = JFConnectionStateResetting;
	}
	
	__weak typeof(self) weakSelf = self;
	self.resetCompletion = ^(BOOL succeeded, NSError* error)
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
		
		[MainOperationQueue addOperationWithBlock:^{
			if([strongSelf.delegate respondsToSelector:@selector(connectionMachine:didReset:succeeded:error:)])
				[strongSelf.delegate connectionMachine:strongSelf didReset:userInfo succeeded:succeeded error:error];
		}];
	};
	
	[MainOperationQueue addOperationWithBlock:^{
		[self.delegate connectionMachine:self performReset:userInfo];
	}];
	
	return YES;
}


#pragma mark Connection management (Events)

- (void)onConnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	if(self.connectCompletion)
		self.connectCompletion(succeeded, error);
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

- (void)onDisconnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	if(self.disconnectCompletion)
		self.disconnectCompletion(succeeded, error);
}

- (void)onReconnectCompleted:(BOOL)succeeded error:(NSError*)error
{
	if(self.reconnectCompletion)
		self.reconnectCompletion(succeeded, error);
}

- (void)onResetCompleted:(BOOL)succeeded error:(NSError*)error
{
	if(self.resetCompletion)
		self.resetCompletion(succeeded, error);
}

@end

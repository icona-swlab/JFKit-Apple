//
//  JFConnectionMachine.h
//  Livelet-iOS
//
//  Created by Jacopo Filié on 15/10/15.
//  Copyright © 2015 Jacopo Filié. All rights reserved.
//



#import "JFTypes.h"
#import "JFUtilities.h"



@class JFConnectionMachine;



@protocol JFConnectionMachineDelegate <NSObject>

@required

- (void)	connectionMachine:(JFConnectionMachine*)machine performConnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performDisconnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReconnect:(NSDictionary*)userInfo;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReset:(NSDictionary*)userInfo;

@optional

- (void)	connectionMachine:(JFConnectionMachine*)machine didChangeState:(JFConnectionState)newState oldState:(JFConnectionState)oldState;
- (void)	connectionMachine:(JFConnectionMachine*)machine didConnect:(NSDictionary*)userInfo succeeded:(BOOL)succeeded error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didDisconnect:(NSDictionary*)userInfo succeeded:(BOOL)succeeded error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didReconnect:(NSDictionary*)userInfo succeeded:(BOOL)succeeded error:(NSError*)error;
- (void)	connectionMachine:(JFConnectionMachine*)machine didReset:(NSDictionary*)userInfo succeeded:(BOOL)succeeded error:(NSError*)error;

@end



#pragma mark



@interface JFConnectionMachine : NSObject

#pragma mark Properties

// Flags
@property (assign, readonly)	JFConnectionState	state;

// Relationships
@property (weak, nonatomic, readonly)	id<JFConnectionMachineDelegate>	delegate;


#pragma mark Methods

// Memory management
- (instancetype)	initWithDelegate:(id<JFConnectionMachineDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// Connection management
- (BOOL)	connect;
- (BOOL)	connect:(NSDictionary*)userInfo;
- (BOOL)	disconnect;
- (BOOL)	disconnect:(NSDictionary*)userInfo;
- (BOOL)	reconnect;
- (BOOL)	reconnect:(NSDictionary*)userInfo;
- (BOOL)	reset;
- (BOOL)	reset:(NSDictionary*)userInfo;

// Connection management (Events)
- (void)	onConnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onConnectionLost;
- (void)	onDisconnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onReconnectCompleted:(BOOL)succeeded error:(NSError*)error;
- (void)	onResetCompleted:(BOOL)succeeded error:(NSError*)error;

@end

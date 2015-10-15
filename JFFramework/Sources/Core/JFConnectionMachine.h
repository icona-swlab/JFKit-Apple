//
//  JFConnectionMachine.h
//  Livelet-iOS
//
//  Created by Jacopo Filié on 15/10/15.
//  Copyright © 2015 Jacopo Filié. All rights reserved.
//



#import "JFTypes.h"



@class JFConnectionMachine;



@protocol JFConnectionMachineDelegate <NSObject>

@required

- (void)	connectionMachine:(JFConnectionMachine*)machine performConnect:(JFBlockWithBOOL)completion;
- (void)	connectionMachine:(JFConnectionMachine*)machine performDisconnect:(JFBlockWithBOOL)completion;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReconnect:(JFBlockWithBOOL)completion;
- (void)	connectionMachine:(JFConnectionMachine*)machine performReset:(JFBlockWithBOOL)completion;

@optional

- (void)	connectionMachine:(JFConnectionMachine*)machine didChangeState:(JFConnectionState)newState oldState:(JFConnectionState)oldState;

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
- (BOOL)	disconnect;
- (BOOL)	reconnect;
- (BOOL)	reset;

// Connection management (Events)
- (void)	onConnectionLost;

@end

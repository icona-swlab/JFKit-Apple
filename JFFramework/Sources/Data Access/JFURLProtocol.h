//
//  JFURLProtocol.h
//  JFFramework
//
//  Created by Jacopo Filié on 08/05/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



@interface JFURLProtocol : NSURLProtocol <NSURLConnectionDataDelegate>

#pragma mark Methods

// Networking management
- (NSURLCredential*)	credential;

@end

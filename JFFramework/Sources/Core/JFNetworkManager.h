//
//  JFNetworkManager.h
//  JFFramework
//
//  Created by Jacopo Filié on 08/10/15.
//
//



#import "JFManager.h"

#import "JFHTTPRequest.h"
#import "JFUtilities.h"



@interface JFNetworkManager : JFManager

#pragma mark Methods

// Services management
- (BOOL)	performRequest:(JFHTTPRequest*)request completion:(JFCompletionBlock)completion;

@end

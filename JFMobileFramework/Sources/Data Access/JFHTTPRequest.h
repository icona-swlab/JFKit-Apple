//
//  JFHTTPRequest.h
//
//  Created by Jacopo Filié on 03/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>



@class JFHTTPRequest;



// List of supported HTTP methods.
typedef NS_ENUM(UInt8, JFHTTPMethod)
{
	JFHTTPMethodGet,
	JFHTTPMethodPost,
};



@protocol JFHTTPRequestDelegate

@required

// HTTP request events
- (void)	onHTTPRequest:(JFHTTPRequest*)request completedRequestWithData:(NSData*)data;
- (void)	onHTTPRequest:(JFHTTPRequest*)request failedRequestWithError:(NSError*)error;

@end



@interface JFHTTPRequest : NSObject

// Attributes
@property (strong, nonatomic)	NSDictionary*		additionalInfo;
@property (strong, nonatomic)	NSURLCredential*	credential;
@property (assign, nonatomic)	NSStringEncoding	encoding;
@property (assign, nonatomic)	JFHTTPMethod		httpMethod;
@property (strong, nonatomic)	NSURL*				url;

// Memory management
- (instancetype)	initWithDelegate:(NSObject<JFHTTPRequestDelegate>*)delegate;

// Attributes management
- (void)	setValue:(NSString*)value forHTTPField:(NSString*)field;
- (void)	setValue:(NSString*)value forHTTPHeaderField:(NSString*)field;

// HTTP request management
- (void)	start;

@end

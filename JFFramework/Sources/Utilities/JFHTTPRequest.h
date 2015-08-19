//
//  JFHTTPRequest.h
//  Copyright (C) 2013 Jacopo Filié
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



#import "JFUtilities.h"



@class JFHTTPRequest;



#pragma mark Typedefs

// List of supported HTTP methods.
typedef NS_ENUM(UInt8, JFHTTPMethod)
{
	JFHTTPMethodGet,
	JFHTTPMethodPost,
};

// Request state
typedef NS_ENUM(UInt8, JFHTTPRequestState)
{
	JFHTTPRequestStateReady,
	JFHTTPRequestStateStarted,
	JFHTTPRequestStateCompleted,
	JFHTTPRequestStateFailed,
};



#pragma mark



@protocol JFHTTPRequestDelegate

@required

- (void)	httpRequest:(JFHTTPRequest*)request completedRequestWithData:(NSData*)data;
- (void)	httpRequest:(JFHTTPRequest*)request failedRequestWithError:(NSError*)error;

@end



#pragma mark



@interface JFHTTPRequest : NSObject

#pragma mark Properties

// Attributes
@property (assign, nonatomic)			NSStringEncoding	encoding;
@property (assign, nonatomic)			JFHTTPMethod		httpMethod;
@property (assign, nonatomic, readonly)	JFHTTPRequestState	state;

// Data
@property (strong, nonatomic)			NSDictionary*		additionalInfo;
@property (strong, nonatomic)			NSURLCredential*	credential;
@property (assign, nonatomic, readonly)	NSInteger			responseCode;
@property (strong, nonatomic, readonly)	NSData*				responseData;
@property (strong, nonatomic, readonly)	NSError*			responseError;
@property (strong, nonatomic, readonly)	NSDictionary*		responseHeaderFields;
@property (strong, nonatomic)			NSURL*				url;

// Relationships
@property (weak, nonatomic, readonly)	NSObject<JFHTTPRequestDelegate>*	delegate;


#pragma mark Methods

// Memory management
- (instancetype)	initWithDelegate:(NSObject<JFHTTPRequestDelegate>*)delegate;

// Attributes management
- (void)	setHTTPBody:(NSData*)body;
- (void)	setValue:(NSString*)value forHTTPField:(NSString*)field;
- (void)	setValue:(NSString*)value forHTTPHeaderField:(NSString*)field;

// HTTP request management
- (void)	reset;
- (void)	start;

@end

//
//  JFHTTPRequest.h
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

//
//  JFHTTPRequest.m
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



#import "JFHTTPRequest.h"



@interface JFHTTPRequest () <NSURLConnectionDataDelegate>

#pragma mark Properties

// Attributes
@property (assign, nonatomic, readwrite)	JFHTTPRequestState	state;

// Data
@property (copy, nonatomic)					NSData*					body;
@property (strong, nonatomic, readonly)		NSMutableDictionary*	fields;
@property (strong, nonatomic, readonly)		NSMutableDictionary*	headerFields;
@property (assign, nonatomic, readwrite)	NSInteger				responseCode;
@property (strong, nonatomic, readwrite)	NSData*					responseData;
@property (strong, nonatomic, readwrite)	NSError*				responseError;
@property (strong, nonatomic, readwrite)	NSDictionary*			responseHeaderFields;

// HTTP request
@property (strong, nonatomic)			NSURLConnection*		connection;
@property (strong, nonatomic, readonly)	NSMutableData*			receivedData;
@property (strong, nonatomic, readonly)	NSMutableURLRequest*	request;


#pragma mark Methods

// Attributes management
- (NSString*)	getEncodedFields;
- (NSString*)	getHTTPMethodString;
- (NSURL*)		getURL;

// HTTP request management
- (void)	clean;

@end



#pragma mark



@implementation JFHTTPRequest

#pragma mark Properties

// Attributes
@synthesize encoding	= _encoding;
@synthesize httpMethod	= _httpMethod;

// Data
@synthesize additionalInfo			= _additionalInfo;
@synthesize body					= _body;
@synthesize credential				= _credential;
@synthesize fields					= _fields;
@synthesize headerFields			= _headerFields;
@synthesize responseCode			= _responseCode;
@synthesize responseData			= _responseData;
@synthesize responseError			= _responseError;
@synthesize responseHeaderFields	= _responseHeaderFields;
@synthesize url						= _url;

// Flags
@synthesize state	= _state;

// HTTP request
@synthesize connection		= _connection;
@synthesize receivedData	= _receivedData;
@synthesize request			= _request;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark Properties accessors (Attributes)

- (void)setEncoding:(NSStringEncoding)encoding
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	_encoding = encoding;
}

- (void)setHttpMethod:(JFHTTPMethod)httpMethod
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	_httpMethod = httpMethod;
}


#pragma mark Properties accessors (Data)

- (void)setAdditionalInfo:(NSDictionary*)additionalInfo
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	_additionalInfo = additionalInfo;
}

- (void)setCredential:(NSURLCredential*)credential
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	_credential = credential;
}

- (void)setUrl:(NSURL*)url
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	_url = url;
}


#pragma mark Memory management

- (instancetype)initWithDelegate:(NSObject<JFHTTPRequestDelegate>*)delegate
{
	self = (delegate ? [super init] : nil);
	if(self)
	{
		// Attributes
		_encoding = NSUTF8StringEncoding;
		_state = JFHTTPRequestStateReady;
		
		// Data
		_fields = [NSMutableDictionary dictionary];
		_headerFields = [NSMutableDictionary dictionary];
		
		// HTTP request
		_receivedData = [NSMutableData data];
		_request = [NSMutableURLRequest new];
		
		// Relationships
		_delegate = delegate;
	}
	return self;
}


#pragma mark Attributes management

- (NSString*)getEncodedFields
{
	NSMutableArray* parameters = [NSMutableArray new];
	
	for(NSString* key in [self.fields allKeys])
	{
		NSString* encodedKey = [key stringByAddingPercentEscapesUsingEncoding:self.encoding];
		NSString* encodedValue = [[self.fields objectForKey:key] stringByAddingPercentEscapesUsingEncoding:self.encoding];
		NSString* parameter = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
		if(parameter)
			[parameters addObject:parameter];
	}
	
	return [parameters componentsJoinedByString:@"&"];
}

- (NSString*)getHTTPMethodString
{
	NSString* retVal = nil;
	switch(self.httpMethod)
	{
		case JFHTTPMethodGet:	retVal = @"GET";	break;
		case JFHTTPMethodPost:	retVal = @"POST";	break;
			
		default:
			break;
	}
	return retVal;
}

- (NSURL*)getURL
{
	NSURL* retVal = self.url;
	if((self.httpMethod == JFHTTPMethodGet) && ([self.fields count] > 0))
	{
		NSMutableString* urlString = [[retVal absoluteString] mutableCopy];
		[urlString appendFormat:@"?%@", [self getEncodedFields]];
		retVal = [NSURL URLWithString:urlString];
	}
	return retVal;
}

- (void)setHTTPBody:(NSData*)body
{
	if(!body || (self.state != JFHTTPRequestStateReady))
		return;
	
	self.body = body;
}

- (void)setValue:(NSString*)value forHTTPField:(NSString*)field
{
	if(!field || (self.state != JFHTTPRequestStateReady))
		return;
	
	if(value)
		[self.fields setValue:value forKey:field];
	else
		[self.fields removeObjectForKey:field];
}

- (void)setValue:(NSString*)value forHTTPHeaderField:(NSString*)field
{
	if(!field || (self.state != JFHTTPRequestStateReady))
		return;
	
	if(value)
		[self.headerFields setValue:value forKey:field];
	else
		[self.headerFields removeObjectForKey:field];
}


#pragma mark HTTP request management

- (void)clean
{
	self.connection = nil;
	[self.receivedData setLength:0];
}

- (void)reset
{
	if(self.state == JFHTTPRequestStateStarted)
	{
		[self.connection cancel];
		[self clean];
		JFHideNetworkActivityIndicator;
	}
	
	self.responseCode = 0;
	self.responseData = nil;
	self.responseError = nil;
	self.responseHeaderFields = nil;
	
	self.state = JFHTTPRequestStateReady;
}

- (void)start
{
	if(self.state != JFHTTPRequestStateReady)
		return;
	
	NSURL* url = [self getURL];
	if(url)
	{
		[self.request setHTTPMethod:[self getHTTPMethodString]];
		[self.request setURL:url];
		
		for(NSString* field in [self.headerFields allKeys])
			[self.request setValue:[self.headerFields objectForKey:field] forHTTPHeaderField:field];
		
		NSData* body = self.body;
		
		if(!body && (self.httpMethod == JFHTTPMethodPost) && ([self.fields count] > 0))
		{
			NSString* fields = [self getEncodedFields];
			body = [fields dataUsingEncoding:self.encoding];
		}
		
		if(body)
		{
			[self.request setHTTPBody:body];
			[self setValue:JFStringFromNSUInteger([body length]) forHTTPHeaderField:@"Content-length"];
		}
		
		JFShowNetworkActivityIndicator;
		self.state = JFHTTPRequestStateStarted;
		self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
	}
}


#pragma mark Protocol implementation (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	[self clean];
	JFHideNetworkActivityIndicator;
	self.state = JFHTTPRequestStateFailed;
	self.responseError = error;
	[self.delegate httpRequest:self failedRequestWithError:error];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	if([response isKindOfClass:[NSHTTPURLResponse class]])
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		self.responseCode = httpResponse.statusCode;
		self.responseHeaderFields = [httpResponse allHeaderFields];
	}
	
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
	if(self.credential)
		[[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
	else
		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	NSData* data = [self.receivedData copy];
	[self clean];
	JFHideNetworkActivityIndicator;
	self.state = JFHTTPRequestStateCompleted;
	self.responseData = data;
	[self.delegate httpRequest:self completedRequestWithData:data];
}

@end

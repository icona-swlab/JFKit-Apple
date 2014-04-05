//
//  JFHTTPRequest.m
//
//  Created by Jacopo Filié on 03/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import "JFHTTPRequest.h"

#import "JFUtilities.h"



@interface JFHTTPRequest ()

// Attributes
@property (strong, nonatomic, readonly)	NSMutableDictionary*	fields;
@property (strong, nonatomic, readonly)	NSMutableDictionary*	headerFields;

// HTTP request
@property (strong, nonatomic)			NSURLConnection*		connection;
@property (strong, nonatomic, readonly)	NSMutableData*			receivedData;
@property (strong, nonatomic, readonly)	NSMutableURLRequest*	request;
@property (assign, nonatomic)			NSInteger				responseCode;

// Listeners
@property (weak, nonatomic)	NSObject<JFHTTPRequestDelegate>*	delegate;

// Attributes management
- (NSString*)	getEncodedFields;
- (NSString*)	getHTTPMethodString;
- (NSURL*)		getURL;

// HTTP request management
- (void)	clean;

@end



@implementation JFHTTPRequest

#pragma mark - Properties

// Attributes
@synthesize additionalInfo	= _additionalInfo;
@synthesize credential		= _credential;
@synthesize encoding		= _encoding;
@synthesize fields			= _fields;
@synthesize headerFields	= _headerFields;
@synthesize httpMethod		= _httpMethod;
@synthesize url				= _url;

// HTTP request
@synthesize connection		= _connection;
@synthesize receivedData	= _receivedData;
@synthesize request			= _request;
@synthesize responseCode	= _responseCode;

// Listeners
@synthesize delegate	= _delegate;


#pragma mark - Properties accessors (Attributes)

- (void)setAdditionalInfo:(NSDictionary*)additionalInfo
{
	if(self.connection)
		return;
	
	_additionalInfo = additionalInfo;
}

- (void)setCredential:(NSURLCredential*)credential
{
	if(self.connection)
		return;
	
	_credential = credential;
}

- (void)setEncoding:(NSStringEncoding)encoding
{
	if(self.connection)
		return;
	
	_encoding = encoding;
}

- (void)setHttpMethod:(JFHTTPMethod)httpMethod
{
	if(self.connection)
		return;
	
	_httpMethod = httpMethod;
}

- (void)setUrl:(NSURL*)url
{
	if(self.connection)
		return;
	
	_url = url;
}


#pragma mark - Memory management

- (instancetype)initWithDelegate:(NSObject<JFHTTPRequestDelegate>*)delegate
{
	self = (delegate ? [super init] : nil);
	if(self)
	{
		// Attributes
		_encoding = NSUTF8StringEncoding;
		_fields = [NSMutableDictionary dictionary];
		_headerFields = [NSMutableDictionary dictionary];
		
		// HTTP request
		_receivedData = [NSMutableData data];
		_request = [NSMutableURLRequest new];
		
		// Listeners
		_delegate = delegate;
	}
	return self;
}


#pragma mark - Attributes management

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

- (void)setValue:(NSString*)value forHTTPField:(NSString*)field
{
	if(!field || self.connection)
		return;
	
	if(value)
		[self.fields setValue:value forKey:field];
	else
		[self.fields removeObjectForKey:field];
}

- (void)setValue:(NSString*)value forHTTPHeaderField:(NSString*)field
{
	if(!field || self.connection)
		return;
	
	if(value)
		[self.headerFields setValue:value forKey:field];
	else
		[self.headerFields removeObjectForKey:field];
}


#pragma mark - HTTP request management

- (void)clean
{
	self.connection = nil;
	[self.receivedData setLength:0];
}

- (void)start
{
	if(self.connection)
		return;
	
	NSURL* url = [self getURL];
	if(url)
	{
		[self.request setHTTPMethod:[self getHTTPMethodString]];
		[self.request setURL:url];
		
		for(NSString* field in [self.headerFields allKeys])
			[self.request setValue:[self.headerFields objectForKey:field] forHTTPHeaderField:field];
		
		if((self.httpMethod == JFHTTPMethodPost) && ([self.fields count] > 0))
		{
			NSString* fields = [self getEncodedFields];
			NSData* body = [fields dataUsingEncoding:self.encoding];
			if(body)
			{
				[self.request setHTTPBody:body];
				[self setValue:NSUIntegerToString([body length]) forHTTPHeaderField:@"Content-length"];
			}
		}
		
		ShowNetworkActivityIndicator;
		self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
	}
}


#pragma mark - Connection delegate

- (void)connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
	if(self.credential)
		[[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
	else
		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	[self clean];
	HideNetworkActivityIndicator;
	[self.delegate onHTTPRequest:self failedRequestWithError:error];
}


#pragma mark - Connection data delegate

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
	}
	
	[self.receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	NSData* data = [self.receivedData copy];
	[self clean];
	HideNetworkActivityIndicator;
	[self.delegate onHTTPRequest:self completedRequestWithData:data];
}

@end

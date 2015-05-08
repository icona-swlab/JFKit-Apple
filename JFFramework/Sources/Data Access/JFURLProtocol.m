//
//  JFURLProtocol.m
//  JFFramework
//
//  Created by Jacopo Filié on 08/05/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFURLProtocol.h"

#import "JFUtilities.h"



#pragma mark Constants

static NSString* const	JFURLProtocolToken	= @"JFURLProtocolToken";



#pragma mark



@interface JFURLProtocol ()

#pragma mark Properties

// Networking
@property (strong, nonatomic)	NSURLConnection*	connection;

@end



#pragma mark



@implementation JFURLProtocol

#pragma mark Properties

// Networking
@synthesize	connection	= _connection;


#pragma mark Memory management

+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{
	return ![NSURLProtocol propertyForKey:JFURLProtocolToken inRequest:request];
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
	return request;
}


#pragma mark Networking management

- (NSURLCredential*)credential
{
	return nil;
}

- (void)startLoading
{
	NSMutableURLRequest* mRequest = [self.request mutableCopy];
	[NSURLProtocol setProperty:@(YES) forKey:JFURLProtocolToken inRequest:mRequest];
	self.connection = [NSURLConnection connectionWithRequest:mRequest delegate:self];
}

- (void)stopLoading
{
	[self.connection cancel];
	self.connection = nil;
}


#pragma mark Protocol implementation (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	[self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[self.client URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	[self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection*)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
{
	LogMethod;
	
	id<NSURLAuthenticationChallengeSender> sender = [challenge sender];
	
	NSURLCredential* credential = [self credential];
	if(credential)
		[sender useCredential:credential forAuthenticationChallenge:challenge];
	else
		[sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	[self.client URLProtocolDidFinishLoading:self];
}

@end

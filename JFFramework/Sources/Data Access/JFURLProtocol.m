//
//  JFURLProtocol.m
//  Copyright (C) 2015 Jacopo Filié
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

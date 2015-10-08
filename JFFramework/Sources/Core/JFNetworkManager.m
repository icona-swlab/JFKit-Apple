//
//  JFNetworkManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 08/10/15.
//
//



#import "JFNetworkManager.h"

#import "JFString.h"



#pragma mark - Macros

#define JFNetworkManagerKey(_name)	(JFReversedDomain @".networkManager.key." _name)



#pragma mark - Constants

static	NSString* const	JFHTTPRequestCompletionBlockKey	= JFNetworkManagerKey(@"HTTPRequestCompletionBlock");



#pragma mark



@interface JFNetworkManager () <JFHTTPRequestDelegate>

#pragma mark Properties

// Services
@property (strong, nonatomic, readonly)	NSMutableSet<JFHTTPRequest*>*	HTTPRequestPool;


#pragma mark Methods

// Services management
- (void)	handleRequestCompletion:(JFHTTPRequest*)request data:(NSData*)data error:(NSError*)error;
- (BOOL)	performRequest:(JFHTTPRequest*)request completion:(JFCompletionBlock)completion;

@end



#pragma mark



@implementation JFNetworkManager

#pragma mark Properties

// Services
@synthesize HTTPRequestPool	= _HTTPRequestPool;


#pragma mark Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Services
		_HTTPRequestPool = [NSMutableSet new];
	}
	return self;
}


#pragma mark Services management

- (void)handleRequestCompletion:(JFHTTPRequest*)request data:(NSData*)data error:(NSError*)error
{
	if(!request)
		return;
	
	// Dequeues the request.
	NSMutableSet* requestPool = self.HTTPRequestPool;
	@synchronized(requestPool)
	{
		if(![requestPool containsObject:request])
			return;
		
		[requestPool removeObject:request];
	}
	
	// Retrieves the completion block and stops the operation if it is not found.
	JFCompletionBlock completion = [request.additionalInfo objectForKey:JFHTTPRequestCompletionBlockKey];
	if(!completion)
		return;
	
	// Performs the completion block passing the converted object and the error.
	completion((data != nil), data, error);
}

- (BOOL)performRequest:(JFHTTPRequest*)request completion:(JFCompletionBlock)completion
{
	if(!request || (request.state != JFHTTPRequestStateReady))
		return NO;
	
	// Saves the completion block.
	if(completion)
	{
		NSMutableDictionary* additionalInfo = [request.additionalInfo mutableCopy];
		if(!additionalInfo)
			additionalInfo = [NSMutableDictionary dictionary];
		[additionalInfo setObject:completion forKey:JFHTTPRequestCompletionBlockKey];
		request.additionalInfo = [additionalInfo copy];
	}
	
	// Enqueues the request.
	NSMutableSet* requestPool = self.HTTPRequestPool;
	@synchronized(requestPool)
	{
		[requestPool addObject:request];
	}
	
	// Forces itself as the request delegate.
	request.delegate = self;
	
	// Starts the request.
	[request start];
	
	return YES;
}


#pragma mark Protocol implementation (JFHTTPRequestDelegate)

- (void)httpRequest:(JFHTTPRequest*)request completedRequestWithData:(NSData*)data
{
	[self handleRequestCompletion:request data:data error:nil];
}

- (void)httpRequest:(JFHTTPRequest*)request failedRequestWithError:(NSError*)error
{
	[self handleRequestCompletion:request data:nil error:error];
}

@end

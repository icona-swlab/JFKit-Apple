//
//  JFErrorsManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 10/09/15.
//
//



#import "JFErrorsManager.h"

#import "JFString.h"



@interface JFErrorsManager ()

@end



#pragma mark



@implementation JFErrorsManager

#pragma mark Properties

// Data
@synthesize domain	= _domain;


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithDomain:@"ApplicationDomain"];
}

- (instancetype)initWithDomain:(NSString*)domain
{
	self = (JFStringIsNullOrEmpty(domain) ? nil : [super init]);
	if(self)
	{
		// Data
		_domain = [domain copy];
	}
	return self;
}


#pragma mark Data management

- (NSString*)localizedDescriptionForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString*)localizedFailureReasonForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString*)localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode
{
	return nil;
}

- (NSString*)stringForErrorCode:(NSString*)errorCode
{
	return nil;
}


#pragma mark Errors management

- (NSError*)errorWithCode:(NSInteger)errorCode
{
	NSString* description = [self localizedDescriptionForErrorCode:errorCode];
	NSString* failureReason = [self localizedFailureReasonForErrorCode:errorCode];
	NSString* recoverySuggestion = [self localizedRecoverySuggestionForErrorCode:errorCode];
	
	NSMutableDictionary* userInfo = nil;
	
	if(description || failureReason || recoverySuggestion)
	{
		userInfo = [NSMutableDictionary dictionary];
		if(description)			[userInfo setObject:description forKey:NSLocalizedDescriptionKey];
		if(failureReason)		[userInfo setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
		if(recoverySuggestion)	[userInfo setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
	}
	
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary*)userInfo
{
	return [NSError errorWithDomain:self.domain code:errorCode userInfo:userInfo];
}

@end

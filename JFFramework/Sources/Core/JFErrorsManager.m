//
//  JFErrorsManager.m
//  JFFramework
//
//  Created by Jacopo Filié on 10/09/15.
//
//



#import "JFErrorsManager.h"

#import "JFString.h"
#import "JFUtilities.h"



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
	return [self initWithDomain:AppIdentifier];
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

- (NSString*)debugStringForErrorCode:(NSInteger)errorCode
{
	return nil;
}

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

- (NSDictionary*)userInfoForErrorCode:(NSInteger)errorCode
{
	return [self userInfoForErrorCode:errorCode underlyingError:nil];
}

- (NSDictionary*)userInfoForErrorCode:(NSInteger)errorCode underlyingError:(NSError*)error
{
	NSString* description = [self localizedDescriptionForErrorCode:errorCode];
	NSString* failureReason = [self localizedFailureReasonForErrorCode:errorCode];
	NSString* recoverySuggestion = [self localizedRecoverySuggestionForErrorCode:errorCode];
	
	NSMutableDictionary* retObj = nil;
	
	if(description || failureReason || recoverySuggestion || error)
	{
		retObj = [NSMutableDictionary dictionary];
		if(description)			[retObj setObject:description forKey:NSLocalizedDescriptionKey];
		if(error)				[retObj setObject:error forKey:NSUnderlyingErrorKey];
		if(failureReason)		[retObj setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
		if(recoverySuggestion)	[retObj setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
	}
	
	return [retObj copy];
}


#pragma mark Errors management

- (NSError*)errorWithCode:(NSInteger)errorCode
{
	NSDictionary* userInfo = [self userInfoForErrorCode:errorCode];
	return [self errorWithCode:errorCode userInfo:userInfo];
}

- (NSError*)errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary*)userInfo
{
	return [NSError errorWithDomain:self.domain code:errorCode userInfo:userInfo];
}

@end

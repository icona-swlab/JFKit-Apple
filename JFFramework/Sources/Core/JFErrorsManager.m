//
//  JFErrorsManager.m
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

- (NSError*)debugPlaceholderError
{
	return [self errorWithCode:NSIntegerMax];
}

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

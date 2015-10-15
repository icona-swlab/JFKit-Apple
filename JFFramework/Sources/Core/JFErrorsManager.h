//
//  JFErrorsManager.h
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



#import "JFManager.h"



@interface JFErrorsManager : JFManager

#pragma mark Properties

// Data
@property (copy, nonatomic, readonly)	NSString*	domain;


#pragma mark Methods

// Memory management
- (instancetype)	initWithDomain:(NSString*)domain NS_DESIGNATED_INITIALIZER;

// Data management
- (NSString*)		debugStringForErrorCode:(NSInteger)errorCode;
- (NSString*)		localizedDescriptionForErrorCode:(NSInteger)errorCode;
- (NSString*)		localizedFailureReasonForErrorCode:(NSInteger)errorCode;
- (NSString*)		localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode;
- (NSDictionary*)	userInfoForErrorCode:(NSInteger)errorCode;
- (NSDictionary*)	userInfoForErrorCode:(NSInteger)errorCode underlyingError:(NSError*)error;

// Errors management
- (NSError*)	debugPlaceholderError;
- (NSError*)	errorWithCode:(NSInteger)errorCode;
- (NSError*)	errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary*)userInfo;

@end

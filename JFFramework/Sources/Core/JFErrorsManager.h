//
//  JFErrorsManager.h
//  JFFramework
//
//  Created by Jacopo Filié on 10/09/15.
//
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
- (NSString*)	localizedDescriptionForErrorCode:(NSInteger)errorCode;
- (NSString*)	localizedFailureReasonForErrorCode:(NSInteger)errorCode;
- (NSString*)	localizedRecoverySuggestionForErrorCode:(NSInteger)errorCode;
- (NSString*)	stringForErrorCode:(NSString*)errorCode;

// Errors management
- (NSError*)	errorWithCode:(NSInteger)errorCode;
- (NSError*)	errorWithCode:(NSInteger)errorCode userInfo:(NSDictionary*)userInfo;

@end

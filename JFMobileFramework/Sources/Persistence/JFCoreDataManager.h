//
//  JFCoreDataManager.h
//
//  Created by Jacopo Filié on 26/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>



@interface JFCoreDataManager : NSObject

// Memory management
- (instancetype)	initWithPathToPersistentStore:(NSString*)persistentStoreFilePath andPathToDataModel:(NSString*)dataModelFilePath;
- (instancetype)	initWithURLToPersistentStore:(NSURL*)persistentStoreFileURL andURLToDataModel:(NSURL*)dataModelFileURL;

// Connection management
- (NSManagedObjectContext*)	createManagedObjectContext;

// Fetch requests management
- (NSFetchRequest*)	fetchRequestTemplateForName:(NSString*)name;
- (NSFetchRequest*)	fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables;

@end

//
//  JFCoreDataManager.h
//
//  Created by Jacopo Filié on 26/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>



@interface JFCoreDataManager : NSObject

// Connection
@property (strong, nonatomic, readonly)	NSURL*							dataModelURL;
@property (strong, nonatomic, readonly)	NSManagedObjectContext*			mainManagedObjectContext;
@property (strong, nonatomic, readonly)	NSManagedObjectModel*			managedObjectModel;
@property (strong, nonatomic, readonly)	NSPersistentStoreCoordinator*	persistentStoreCoordinator;
@property (strong, nonatomic, readonly)	NSURL*							persistentStoreURL;

// Memory management
- (instancetype)	initWithPersistentStoreURL:(NSURL*)persistentStoreURL andDataModelURL:(NSURL*)dataModelURL;

// Connection management
- (NSManagedObjectContext*)	createPrivateManagedObjectContext;

// Fetch requests management
- (NSFetchRequest*)	fetchRequestTemplateForName:(NSString*)name;
- (NSFetchRequest*)	fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables;

@end

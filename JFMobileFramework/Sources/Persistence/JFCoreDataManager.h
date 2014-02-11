//
//  JFCoreDataManager.h
//
//  Created by Jacopo Filié on 26/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>



@interface JFCoreDataManager : NSObject

// Store
@property (strong, nonatomic, readonly)	NSURL*							dataModelURL;
@property (strong, nonatomic, readonly)	NSManagedObjectContext*			mainManagedObjectContext;
@property (strong, nonatomic, readonly)	NSManagedObjectModel*			managedObjectModel;
@property (strong, nonatomic, readonly)	NSPersistentStoreCoordinator*	persistentStoreCoordinator;
@property (strong, nonatomic, readonly)	NSString*						persistentStoreType;
@property (strong, nonatomic, readonly)	NSURL*							persistentStoreURL;

// Memory management
- (instancetype)	initWithDataModelURL:(NSURL*)dataModelURL persistentStoreURL:(NSURL*)persistentStoreURL persistentStoreType:(NSString*)persistentStoreType;

// Fetch requests management
- (NSFetchRequest*)	fetchRequestTemplateForName:(NSString*)name;
- (NSFetchRequest*)	fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables;

// Store management
- (NSManagedObjectContext*)	createPrivateManagedObjectContext;

@end

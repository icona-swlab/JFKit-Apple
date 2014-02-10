//
//  JFCoreDataManager.m
//
//  Created by Jacopo Filié on 26/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import "JFCoreDataManager.h"

#import "JFUtilities.h"



@interface JFCoreDataManager ()

// Connection management
- (NSManagedObjectContext*)	createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

@end



@implementation JFCoreDataManager

#pragma mark - Properties

// Connection
@synthesize dataModelURL				= _dataModelURL;
@synthesize mainManagedObjectContext	= _mainManagedObjectContext;
@synthesize managedObjectModel			= _managedObjectModel;
@synthesize persistentStoreCoordinator	= _persistentStoreCoordinator;
@synthesize persistentStoreURL			= _persistentStoreURL;


#pragma mark - Properties accessors (Connection)

- (NSManagedObjectContext*)mainManagedObjectContext
{
	@synchronized(self)
	{
		if(!_mainManagedObjectContext)
			_mainManagedObjectContext = [self createManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
		
		return _mainManagedObjectContext;
	}
}

- (NSManagedObjectModel*)managedObjectModel
{
	@synchronized(self)
	{
		if(!_managedObjectModel)
			_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.dataModelURL];
		
		return _managedObjectModel;
	}
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	@synchronized(self)
	{
		if(!_persistentStoreCoordinator && self.managedObjectModel)
		{
			NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
			NSError* error = nil;
			if([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error])
				_persistentStoreCoordinator = coordinator;
			else
				NSLog(@"%@: could not connect to persistent store at URL '%@' for error '%@'.", ClassName, [self.persistentStoreURL absoluteString], error);
		}
		
		return _persistentStoreCoordinator;
	}
}


#pragma mark - Memory management

- (instancetype)initWithPersistentStoreURL:(NSURL*)persistentStoreURL andDataModelURL:(NSURL*)dataModelURL
{
	self = ((persistentStoreURL && dataModelURL) ? [super init] : nil);
	if(self)
	{
		// Connection
		_dataModelURL = [dataModelURL copy];
		_persistentStoreURL = [persistentStoreURL copy];
	}
	return self;
}


#pragma mark - Connection management

- (NSManagedObjectContext*)createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
	if(!self.persistentStoreCoordinator)
		return nil;
	
	NSManagedObjectContext* retVal = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
	if(retVal)
	{
		retVal.persistentStoreCoordinator = self.persistentStoreCoordinator;
		retVal.undoManager = [NSUndoManager new];
	}
	return retVal;
}

- (NSManagedObjectContext*)createPrivateManagedObjectContext
{
	return [self createManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
}


#pragma mark - Fetch requests management

- (NSFetchRequest*)fetchRequestTemplateForName:(NSString*)name
{
	if(!name || !self.managedObjectModel)
		return nil;
	
	return [self.managedObjectModel fetchRequestTemplateForName:name];
}

- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables
{
	if(!name || !variables || !self.managedObjectModel)
		return nil;
	
	return [self.managedObjectModel fetchRequestFromTemplateWithName:name substitutionVariables:variables];
}

@end

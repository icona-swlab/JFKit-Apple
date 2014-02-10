//
//  JFCoreDataManager.m
//
//  Created by Jacopo Filié on 26/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import "JFCoreDataManager.h"

#import "JFUtilities.h"



@interface JFCoreDataManager ()

// Connection
@property (strong, nonatomic, readonly)	NSURL*							dataModelFileURL;
@property (strong, nonatomic, readonly)	NSManagedObjectModel*			managedObjectModel;
@property (strong, nonatomic, readonly)	NSPersistentStoreCoordinator*	persistentStoreCoordinator;
@property (strong, nonatomic, readonly)	NSURL*							persistentStoreFileURL;

@end



@implementation JFCoreDataManager

#pragma mark - Properties

// Connection
@synthesize dataModelFileURL			= _dataModelFileURL;
@synthesize managedObjectModel			= _managedObjectModel;
@synthesize persistentStoreCoordinator	= _persistentStoreCoordinator;
@synthesize persistentStoreFileURL		= _persistentStoreFileURL;


#pragma mark - Properties accessors (Connection)

- (NSManagedObjectModel*)managedObjectModel
{
	@synchronized(self)
	{
		if(!_managedObjectModel)
			_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.dataModelFileURL];
		
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
			if([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreFileURL options:nil error:&error])
				_persistentStoreCoordinator = coordinator;
			else
				NSLog(@"%@: could not connect to persistent store at URL '%@' for error '%@'.", ClassName, [self.persistentStoreFileURL absoluteString], error);
		}
		
		return _persistentStoreCoordinator;
	}
}


#pragma mark - Memory management

- (instancetype)initWithPathToPersistentStore:(NSString*)persistentStoreFilePath andPathToDataModel:(NSString*)dataModelFilePath
{
	if(!persistentStoreFilePath || !dataModelFilePath)
	{
		self = nil;
		return nil;
	}
	
	return [self initWithURLToPersistentStore:[NSURL fileURLWithPath:persistentStoreFilePath] andURLToDataModel:[NSURL fileURLWithPath:dataModelFilePath]];
}

- (instancetype)initWithURLToPersistentStore:(NSURL*)persistentStoreFileURL andURLToDataModel:(NSURL*)dataModelFileURL
{
	self = ((persistentStoreFileURL && dataModelFileURL) ? [super init] : nil);
	if(self)
	{
		// Connection
		_dataModelFileURL = [dataModelFileURL copy];
		_persistentStoreFileURL = [persistentStoreFileURL copy];
	}
	return self;
}


#pragma mark - Connection management

- (NSManagedObjectContext*)createManagedObjectContext
{
	if(!self.persistentStoreCoordinator)
		return nil;
	
	NSManagedObjectContext* retVal = [NSManagedObjectContext new];
	retVal.persistentStoreCoordinator = self.persistentStoreCoordinator;
	return retVal;
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

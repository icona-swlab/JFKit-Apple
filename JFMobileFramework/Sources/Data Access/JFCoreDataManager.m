//
//  JFCoreDataManager.m
//  Copyright (C) 2013  Jacopo Filié
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



#import "JFCoreDataManager.h"

#import "JFUtilities.h"



@interface JFCoreDataManager ()

// Store management
- (NSManagedObjectContext*)	createManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

@end



@implementation JFCoreDataManager

#pragma mark - Properties

// Store
@synthesize dataModelURL				= _dataModelURL;
@synthesize mainManagedObjectContext	= _mainManagedObjectContext;
@synthesize managedObjectModel			= _managedObjectModel;
@synthesize persistentStoreCoordinator	= _persistentStoreCoordinator;
@synthesize persistentStoreType			= _persistentStoreType;
@synthesize persistentStoreURL			= _persistentStoreURL;


#pragma mark - Properties accessors (Store)

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
			if([coordinator addPersistentStoreWithType:self.persistentStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error])
				_persistentStoreCoordinator = coordinator;
			else
				NSLog(@"%@: could not connect to persistent store at URL '%@' for error '%@'.", ClassName, [self.persistentStoreURL absoluteString], error);
		}
		
		return _persistentStoreCoordinator;
	}
}


#pragma mark - Memory management

- (instancetype)initWithDataModelURL:(NSURL*)dataModelURL persistentStoreURL:(NSURL*)persistentStoreURL persistentStoreType:(NSString*)persistentStoreType
{
	self = ((dataModelURL && persistentStoreURL && !IsNullOrEmptyString(persistentStoreType)) ? [super init] : nil);
	if(self)
	{
		// Connection
		_dataModelURL = [dataModelURL copy];
		_persistentStoreType = [persistentStoreType copy];
		_persistentStoreURL = [persistentStoreURL copy];
	}
	return self;
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


#pragma mark - Store management

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

@end

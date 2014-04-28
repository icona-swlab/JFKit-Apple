//
//  JFCoreDataManager.h
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



#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>



@interface JFCoreDataManager : NSObject

// Store
@property (strong, nonatomic, readonly)	NSURL*							dataModelURL;
@property (strong, readonly)			NSManagedObjectContext*			mainManagedObjectContext;
@property (strong, readonly)			NSManagedObjectModel*			managedObjectModel;
@property (strong, readonly)			NSPersistentStoreCoordinator*	persistentStoreCoordinator;
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

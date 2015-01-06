//
//  JFCoreDataManagerTester.m
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 05/01/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFCoreDataManagerTester.h"



@interface JFCoreDataManagerTester ()

// Managers
@property (strong, nonatomic)	JFCoreDataManager*	coreDataManager;

@end



@implementation JFCoreDataManagerTester

#pragma mark - Properties

// Managers
@synthesize coreDataManager	= _coreDataManager;


#pragma mark - Memory management

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		NSURL* dataModelURL = BundleResourceURL(@"Database1.momd");
		NSURL* persistentStoreURL = [[[JFFileManager defaultManager] URLForSystemDirectoryDocuments] URLByAppendingPathComponent:@"Database.sqlite"];
		NSString* persistentStoreType = NSSQLiteStoreType;
		
		// Managers
		_coreDataManager = [[JFCoreDataManager alloc] initWithDataModelURL:dataModelURL persistentStoreURL:persistentStoreURL persistentStoreType:persistentStoreType];
	}
	return self;
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	__unused NSManagedObjectContext* context = self.coreDataManager.mainManagedObjectContext;
}

@end

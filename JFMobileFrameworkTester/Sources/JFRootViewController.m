//
//  JFRootViewController.m
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 05/01/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFRootViewController.h"

#import "JFCoreDataManagerTester.h"



@interface JFRootViewControllerRow : NSObject

// Data
@property (strong, nonatomic, readonly)	NSString*	title;
@property (strong, nonatomic, readonly)	Class		viewControllerClass;

// Memory management
+ (instancetype)	rowWithTitle:(NSString*)title viewControllerClass:(Class)viewControllerClass;
- (instancetype)	initWithTitle:(NSString*)title viewControllerClass:(Class)viewControllerClass;

@end



@interface JFRootViewController ()

// Data
@property (strong, nonatomic)	NSArray*	sections;	// Array of "JFTableViewSection" objects.

// User interface management
- (void)	presentModalViewControllerForRow:(JFRootViewControllerRow*)row;

@end



@implementation JFRootViewController

#pragma mark - Properties

// Data
@synthesize sections	= _sections;


#pragma mark - User interface management

- (void)presentModalViewControllerForRow:(JFRootViewControllerRow*)row
{
	if(!row || !row.viewControllerClass)
		return;
	
	UIViewController* viewController = [[row.viewControllerClass alloc] init];
	if(viewController)
	{
		viewController.title = row.title;
		UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewController];
		[self presentViewController:navController animated:YES completion:nil];
	}
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSMutableArray* sections = [NSMutableArray array];
	NSMutableArray* rows = [NSMutableArray array];
	
	// Prepares the user interface section.
	JFTableViewSection* section = [[JFTableViewSection alloc] init];
	section.headerTitle = @"Data Access";
	[rows addObject:[JFRootViewControllerRow rowWithTitle:@"CoreData Manager" viewControllerClass:[JFCoreDataManagerTester class]]];
	section.items = [rows copy];
	[sections addObject:section];
	[rows removeAllObjects];
	
	self.sections = [sections copy];
}


#pragma mark - Protocol implementation (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.sections count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"Cell";
	
	UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!retVal)
		retVal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
	JFTableViewSection* section = [self.sections objectAtIndex:indexPath.section];
	JFRootViewControllerRow* row = [section.items objectAtIndex:indexPath.row];
	
	retVal.textLabel.text = row.title;
	
	return retVal;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [((JFTableViewSection*)[self.sections objectAtIndex:section]).items count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return ((JFTableViewSection*)[self.sections objectAtIndex:section]).headerTitle;
}


#pragma mark - Protocol implementation (UITableViewDelegate)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFTableViewSection* section = [self.sections objectAtIndex:indexPath.section];
	JFRootViewControllerRow* row = [section.items objectAtIndex:indexPath.row];
	
	[self presentModalViewControllerForRow:row];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end



@implementation JFRootViewControllerRow

#pragma mark - Properties

// Data
@synthesize title				= _title;
@synthesize viewControllerClass	= _viewControllerClass;


#pragma mark - Memory management

+ (instancetype)rowWithTitle:(NSString*)title viewControllerClass:(Class)viewControllerClass
{
	return [[self alloc] initWithTitle:title viewControllerClass:viewControllerClass];
}

- (instancetype)initWithTitle:(NSString*)title viewControllerClass:(Class)viewControllerClass
{
	self = (title ? [self init] : nil);
	if(self)
	{
		// Data
		_title = title;
		_viewControllerClass = viewControllerClass;
	}
	return self;
}

@end

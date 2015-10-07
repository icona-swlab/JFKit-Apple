//
//  JFMenuController.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFMenuViewController.h"

#import "JFTableSection.h"



@interface JFMenuViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark Properties

// Data
@property (strong, nonatomic, readonly)	NSMutableArray<JFTableSection*>*	tableItems;

// User interface
@property (strong, nonatomic)	UITableView*	tableView;

@end



#pragma mark



@implementation JFMenuViewController

#pragma mark Properties

// Data
@synthesize items		= _items;
@synthesize tableItems	= _tableItems;

// User interface
@synthesize tableView	= _tableView;


#pragma mark Properties accessors (Data)

- (void)setItems:(NSArray<JFMenuSection*>*)items
{
	if(_items == items)
		return;
	
	_items = [items copy];
	
	[self reloadItems];
}


#pragma mark Memory management

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		// Data
		_tableItems = [NSMutableArray new];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		// Data
		_tableItems = [NSMutableArray new];
	}
	return self;
}


#pragma mark Data management

- (void)reloadItems
{
	LogMethod;
}


#pragma mark User interface management (View lifecycle)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	tableView.dataSource = self;
	tableView.delegate = self;
	[self.view addSubview:tableView];
	self.tableView = tableView;
}


#pragma mark Protocol implementation (UITableViewDatasource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.tableItems count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* const CellIdentifier = @"Menu Item";
	
	UITableViewCell* retObj = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!retObj)
		retObj = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
	return retObj;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	JFMenuSection* menuSection = [self.tableItems objectAtIndex:section];
	return menuSection.title;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	JFMenuSection* menuSection = [self.tableItems objectAtIndex:section];
	return [menuSection.subitems count];
}

@end

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



#pragma mark - Constants

static CGFloat	DefaultIndentationWidth	= 0.0;




@interface JFMenuViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark Properties

// Data
@property (strong, nonatomic, readonly)	NSMutableSet<JFMenuItem*>*			allItems;
@property (strong, nonatomic, readonly)	NSMutableArray<JFTableSection*>*	tableItems;

// User interface
@property (strong, nonatomic)	UITableView*	tableView;


#pragma mark Methods

// Data management
- (JFMenuItem*)				itemForRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSArray<JFMenuItem*>*)	serializeSubitemsOfNode:(JFMenuNode*)node;

// Notifications management
- (void)	notifyDidSelectItem:(JFMenuItem*)item;

@end



#pragma mark



@implementation JFMenuViewController

#pragma mark Properties

// Attributes
@synthesize indentationWidth	= _indentationWidth;

// Data
@synthesize allItems	= _allItems;
@synthesize sections	= _sections;
@synthesize tableItems	= _tableItems;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize tableView	= _tableView;


#pragma mark Properties accessors (Data)

- (void)setSections:(NSArray<JFMenuSection*>*)sections
{
	if(_sections == sections)
		return;
	
	_sections = [sections copy];
	
	[self reloadItems];
}


#pragma mark Memory management

+ (void)initialize
{
	if(self != [JFMenuViewController class])
		return;
	
	UITableViewCell* cell = [UITableViewCell new];
	
	DefaultIndentationWidth = cell.indentationWidth;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		// Attributes
		_indentationWidth = DefaultIndentationWidth;
		
		// Data
		_allItems = [NSMutableSet new];
		_tableItems = [NSMutableArray new];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		// Attributes
		_indentationWidth = DefaultIndentationWidth;
		
		// Data
		_allItems = [NSMutableSet new];
		_tableItems = [NSMutableArray new];
	}
	return self;
}


#pragma mark Data management

- (JFMenuItem*)itemForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(!indexPath)
		return nil;
	
	NSArray* items = self.tableItems;
	
	NSUInteger lastIndex = [items count] - 1;
	if(indexPath.section > lastIndex)
		return nil;
	
	JFTableSection* section = [items objectAtIndex:indexPath.section];
	
	lastIndex = [section.items count] - 1;
	if(indexPath.row > lastIndex)
		return nil;
	
	return [section.items objectAtIndex:indexPath.row];
}

- (void)reloadItems
{
	NSArray* menuSections = self.sections;
	NSMutableArray* tableItems = [NSMutableArray arrayWithCapacity:[menuSections count]];
	NSMutableSet* allItems = [NSMutableSet setWithCapacity:[menuSections count]];
	
	for(JFMenuSection* menuSection in menuSections)
	{
		JFTableSection* tableSection = [[JFTableSection alloc] init];
		tableSection.footerTitle = menuSection.detailText;
		tableSection.headerTitle = menuSection.title;
		
		NSArray* sectionItems = [self serializeSubitemsOfNode:menuSection];
		if(sectionItems)
		{
			tableSection.items = sectionItems;
			[allItems addObjectsFromArray:tableSection.items];
		}
		
		[tableItems addObject:tableSection];
	}
	
	[self.allItems setSet:allItems];
	[self.tableItems setArray:tableItems];
	
	if([self isViewLoaded])
		[self.tableView reloadData];
}

- (NSArray<JFMenuItem*>*)serializeSubitemsOfNode:(JFMenuNode*)node
{
	if(!node)
		return nil;
	
	NSMutableArray<JFMenuItem*>* retObj = [NSMutableArray arrayWithCapacity:[node.subitems count]];
	
	for(JFMenuItem* item in node.subitems)
	{
		[retObj addObject:item];
		NSArray<JFMenuItem*>* subitems = [self serializeSubitemsOfNode:item];
		if(subitems)
			[retObj addObjectsFromArray:subitems];
	}
	
	return [retObj copy];
}


#pragma mark Notifications management

- (void)notifyDidSelectItem:(JFMenuItem*)item
{
	if(![self.allItems containsObject:item])
		return;
	
	id<JFMenuViewControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(menuViewController:didSelectItem:)])
		[delegate menuViewController:self didSelectItem:item];
}


#pragma mark User interface management (View lifecycle)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	tableView.backgroundColor = [UIColor clearColor];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.opaque = NO;
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
	
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	
	NSUInteger indentationLevel = 0;
	JFMenuItem* superitem = item.superitem;
	
	while(superitem)
	{
		indentationLevel++;
		superitem = superitem.superitem;
	}
	
	retObj.detailTextLabel.text = item.detailText;
	retObj.indentationLevel = indentationLevel;
	retObj.indentationWidth = self.indentationWidth;
	retObj.textLabel.text = item.title;
	
	return retObj;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	JFTableSection* menuSection = [self.tableItems objectAtIndex:section];
	return [menuSection.items count];
}

- (NSString*)tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
	JFTableSection* menuSection = [self.tableItems objectAtIndex:section];
	return menuSection.footerTitle;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	JFTableSection* menuSection = [self.tableItems objectAtIndex:section];
	return menuSection.headerTitle;
}


#pragma mark Protocol implementation (UITableViewDelegate)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	[self notifyDidSelectItem:item];
}

@end
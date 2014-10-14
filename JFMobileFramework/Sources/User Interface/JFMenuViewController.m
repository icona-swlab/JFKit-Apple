//
//  JFMenuViewController.m
//  Copyright (C) 2014  Jacopo Filié
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

#import "JFMenuGroup.h"
#import "JFMenuItem.h"
#import "JFUtilities.h"



@interface JFMenuViewController ()

// Data
@property (strong, nonatomic, readonly)	NSMutableArray*	items;

// Memory management
- (void)	commonInit;

// User interface management (Table view)
- (void)	collapseGroup:(JFMenuGroup*)group atIndex:(NSInteger)index;
- (void)	expandGroup:(JFMenuGroup*)group atIndex:(NSInteger)index;

// Data management
- (JFMenuItem*)	itemForRowAtIndexPath:(NSIndexPath*)indexPath;

@end



@implementation JFMenuViewController

#pragma mark - Properties

// Attributes
@synthesize itemsIndentationLevel		= _itemsIndentationLevel;
@synthesize itemsIndentationWidth		= _itemsIndentationWidth;
@synthesize subitemsIndentationLevel	= _subitemsIndentationLevel;
@synthesize subitemsIndentationWidth	= _subitemsIndentationWidth;

// Data
@synthesize items	= _items;

// Flags
@synthesize shouldIndentItems		= _shouldIndentItems;
@synthesize shouldIndentSubitems	= _shouldIndentSubitems;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark - Memory management

- (void)commonInit
{
	// Attributes
	_itemsIndentationLevel = 0;
	_itemsIndentationWidth = 0.0f;
	_subitemsIndentationLevel = 1;
	_subitemsIndentationWidth = 10.0f;
	
	// Data
	_items = [NSMutableArray new];
	
	// Flags
	_shouldIndentItems = NO;
	_shouldIndentSubitems = YES;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		[self commonInit];
	}
	return self;
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark - User interface management (Table view)

- (void)collapseGroup:(JFMenuGroup*)group atIndex:(NSInteger)index
{
	if(!group || group.isCollapsed)
		return;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:shouldCollapseGroup:)])
		[self.delegate menuViewController:self shouldCollapseGroup:group];
	
	NSMutableArray* indexPaths = [NSMutableArray array];
	for(NSUInteger row = 1; row <= [group.items count]; row++)
	{
		NSIndexPath* childIndexPath = [NSIndexPath indexPathForRow:row inSection:index];
		[indexPaths addObject:childIndexPath];
	}
	
	group.isCollapsed = YES;
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

- (void)expandGroup:(JFMenuGroup*)group atIndex:(NSInteger)index
{
	if(!group || !group.isCollapsed)
		return;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:shouldExpandGroup:)])
		[self.delegate menuViewController:self shouldExpandGroup:group];
	
	NSMutableArray* indexPaths = [NSMutableArray array];
	for(NSUInteger row = 1; row <= [group.items count]; row++)
	{
		NSIndexPath* childIndexPath = [NSIndexPath indexPathForRow:row inSection:index];
		[indexPaths addObject:childIndexPath];
	}
	
	group.isCollapsed = NO;
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - Data management

- (JFMenuItem*)itemForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* retVal = [self.items objectAtIndex:indexPath.section];
	if((indexPath.row > 0) && [retVal isKindOfClass:[JFMenuGroup class]])
	{
		NSInteger row = indexPath.row - 1;
		JFMenuGroup* group = (JFMenuGroup*)retVal;
		retVal = ((row < [group.items count]) ? [group.items objectAtIndex:row] : nil);
	}
	return retVal;
}

- (void)setMenuItems:(NSArray*)items
{
	[self.items setArray:items];
	[self.tableView reloadData];
}


#pragma mark - Delegation management (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	
	UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	retVal.detailTextLabel.text = item.detailText;
	retVal.textLabel.text = item.text;
	
	return retVal;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	JFMenuItem* item = [self.items objectAtIndex:section];
	if(![item isKindOfClass:[JFMenuGroup class]])
		return 1;
	
	JFMenuGroup* group = (JFMenuGroup*)item;
	if(group.isCollapsed)
		return 1;
	
	return [group.items count] + 1;
}


#pragma mark - Delegation management (UITableViewDelegate)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	
	if([item isKindOfClass:[JFMenuGroup class]])
	{
		JFMenuGroup* group = (JFMenuGroup*)item;
		if(group.isCollapsed)
			[self expandGroup:group atIndex:indexPath.section];
		else
			[self collapseGroup:group atIndex:indexPath.section];
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:didSelectItem:)])
		[self.delegate menuViewController:self didSelectItem:item];
}

@end

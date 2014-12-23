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

#import "JFMenuItem.h"
#import "JFUtilities.h"



@interface JFMenuViewController ()

// Data
@property (strong, nonatomic, readonly)	NSMutableArray*	tableItems;	// Two-levels version of the 'items' array.

// Data management
- (JFMenuItem*)		groupForItem:(JFMenuItem*)item;
- (NSIndexPath*)	indexPathOfItem:(JFMenuItem*)item;
- (JFMenuItem*)		itemForIndexPath:(NSIndexPath*)indexPath;

// User interface management (TableView)
- (void)	applyAttributesOfItem:(JFMenuItem*)item toCell:(UITableViewCell*)cell;
- (void)	loadItem:(JFMenuItem*)item intoCell:(UITableViewCell*)cell;
- (void)	updateCellAtIndexPath:(NSIndexPath*)indexPath;

@end



@implementation JFMenuViewController

#pragma mark - Properties

// Data
@synthesize items			= _items;
@synthesize selectedItem	= _selectedItem;
@synthesize tableItems		= _tableItems;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark - Properties accessors (Data)

- (void)setItems:(NSArray*)items
{
	if(AreArraysEqual(_items, items))
		return;
	
	_items = items;
	
	[self reloadItems];
}

- (void)setSelectedItem:(JFMenuItem*)selectedItem
{
	if(_selectedItem == selectedItem)
		return;

	JFMenuItem* oldItem = _selectedItem;
	
	_selectedItem = selectedItem;
	
	if(oldItem)
	{
		if([self isViewLoaded])
		{
			[self updateCellAtIndexPath:[self indexPathOfItem:oldItem]];
			
			JFMenuItem* group = [self groupForItem:oldItem];
			[self updateCellAtIndexPath:[self indexPathOfItem:group]];
		}
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:didDeselectItem:)])
			[self.delegate menuViewController:self didDeselectItem:oldItem];
	}
	
	if(_selectedItem)
	{
		if([self isViewLoaded])
		{
			[self updateCellAtIndexPath:[self indexPathOfItem:_selectedItem]];
			
			JFMenuItem* group = [self groupForItem:_selectedItem];
			[self updateCellAtIndexPath:[self indexPathOfItem:group]];
		}
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:didSelectItem:)])
			[self.delegate menuViewController:self didSelectItem:_selectedItem];
	}
}


#pragma mark - Memory management

- (instancetype)init
{
	self = [self initWithStyle:UITableViewStyleGrouped];
	if(self)
	{}
	return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{}
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

- (instancetype)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if(self)
	{}
	return self;
}


#pragma mark - Data management

- (void)collapseGroup:(JFMenuItem*)group
{
	if(!group || ![group isGroup] || [group isGroupCollapsed])
		return;
}

- (void)expandGroup:(JFMenuItem*)group
{
	if(!group || ![group isGroup] || ![group isGroupCollapsed])
		return;
}

- (JFMenuItem*)groupForItem:(JFMenuItem*)item
{
	if(!item)
		return nil;
	
	for(NSArray* items in self.tableItems)
	{
		for(JFMenuItem* group in items)
		{
			if(group == item)
				return nil;
			
			if([group isGroup] && [group.subitems containsObject:item])
				return group;
		}
	}
	
	return nil;
}

- (NSIndexPath*)indexPathOfItem:(JFMenuItem*)item
{
	if(!item)
		return nil;
	
	for(NSInteger section = 0; section < [self.tableItems count]; section++)
	{
		NSArray* items = [self.tableItems objectAtIndex:section];
		if([items containsObject:item])
		{
			NSInteger row = [items indexOfObject:item];
			return [NSIndexPath indexPathForRow:row inSection:section];
		}
	}
	return nil;
}

- (JFMenuItem*)itemForIndexPath:(NSIndexPath*)indexPath
{
	if(!indexPath)
		return nil;
	
	return [[self.tableItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)reloadItems
{
	// Prepares the block to recursively retrieve all subitems of an item.
	__block __weak NSArray* (^weakGetSubitems)(JFMenuItem*);
	NSArray* (^getSubitems)(JFMenuItem*) = ^NSArray*(JFMenuItem* item)
	{
		if(!item || ![item isGroup] || [item isGroupCollapsed])
			return nil;
		
		NSMutableArray* retVal = [NSMutableArray array];
		for(JFMenuItem* subitem in item.subitems)
		{
			[retVal addObject:subitem];
			NSArray* subitems = weakGetSubitems(subitem);
			if(subitems)
				[retVal addObjectsFromArray:subitems];
		}
		return retVal;
	};
	weakGetSubitems = getSubitems;
	
	[self.tableItems removeAllObjects];
	
	for(JFMenuItem* item in self.items)
	{
		NSMutableArray* sectionItems = [NSMutableArray arrayWithObject:item];
		NSArray* subitems = getSubitems(item);
		if(subitems)
			[sectionItems addObjectsFromArray:subitems];
		[self.tableItems addObject:sectionItems];
	}
	
	if([self isViewLoaded])
		[self.tableView reloadData];
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - User interface management (TableView)

- (void)applyAttributesOfItem:(JFMenuItem*)item toCell:(UITableViewCell*)cell
{
	if(!item || !cell)
		return;
	
	BOOL isSelected = (item == self.selectedItem);
	BOOL isSelectedGroup = (!isSelected && (item == [self groupForItem:self.selectedItem]));
	
	BOOL shouldUseSelectedAttributes = ((isSelected || (isSelectedGroup && item.shouldDisplayAsSelectedIfSubitemIsSelected)) && item.selectedAttributes);
	
	JFMenuItemAttributes* attributes = (shouldUseSelectedAttributes ? item.selectedAttributes : item.attributes);
	
	// Colors
	cell.backgroundColor = attributes.backgroundColor;
	cell.detailTextLabel.textColor = attributes.detailTextColor;
	cell.textLabel.textColor = attributes.textColor;
	
	// Fonts
	cell.detailTextLabel.font = attributes.detailTextFont;
	cell.textLabel.font = attributes.textFont;
	
	// Indentation
	cell.indentationLevel = attributes.indentationLevel;
	cell.indentationWidth = attributes.indentationWidth;
	
	// Selection
	cell.selectionStyle = attributes.selectionStyle;
}

- (void)loadItem:(JFMenuItem*)item intoCell:(UITableViewCell*)cell
{
	if(!item || !cell)
		return;
	
	cell.detailTextLabel.text = item.detailText;
	cell.imageView.image = item.image;
	cell.textLabel.text = item.text;
}

- (void)updateCellAtIndexPath:(NSIndexPath*)indexPath
{
	if(!indexPath)
		return;
	
	UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
	JFMenuItem* item = [self itemForIndexPath:indexPath];
	if(!cell || !item)
		return;
	
	[self applyAttributesOfItem:item toCell:cell];
	[self loadItem:item intoCell:cell];
}


#pragma mark - Protocol implementation (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.tableItems count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* cellIdentifier = @"Cell";
	
	UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!retVal)
		retVal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	
	JFMenuItem* item = [self itemForIndexPath:indexPath];
	[self loadItem:item intoCell:retVal];
	
	if(item == self.selectedItem)
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	return retVal;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.tableItems objectAtIndex:section] count];
}


#pragma mark - Protocol implementation (UITableViewDelegate)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForIndexPath:indexPath];
	self.selectedItem = item;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForIndexPath:indexPath];
	[self applyAttributesOfItem:item toCell:cell];
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForIndexPath:indexPath];
	if(!item.selectionEnabled)
		return nil;
	
	if([self.delegate respondsToSelector:@selector(menuViewController:shouldSelectItem:)])
	{
		if(![self.delegate menuViewController:self shouldSelectItem:item])
			return nil;
	}
	
	return indexPath;
}

@end

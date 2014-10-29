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
#import "JFMenuItemTableViewCell.h"
#import "JFUtilities.h"



@interface JFMenuViewController ()

// Memory management
- (void)	commonInit;

// User interface management (Table view)
- (void)	applyAttributesOfItem:(JFMenuItem*)item toCell:(JFMenuItemTableViewCell*)cell;
- (void)	collapseGroup:(JFMenuGroup*)group atIndex:(NSInteger)index;
- (void)	collapseGroupsIfPossible;
- (void)	expandGroup:(JFMenuGroup*)group atIndex:(NSInteger)index;
- (void)	loadDataOfItem:(JFMenuItem*)item intoCell:(JFMenuItemTableViewCell*)cell;
- (void)	updateCellAtIndexPath:(NSIndexPath*)indexPath;

// Data management
- (JFMenuGroup*)	groupForItem:(JFMenuItem*)item;
- (NSIndexPath*)	indexPathOfItem:(JFMenuItem*)item;
- (JFMenuItem*)		itemForRowAtIndexPath:(NSIndexPath*)indexPath;

@end



@implementation JFMenuViewController

#pragma mark - Properties

// Data
@synthesize items			= _items;
@synthesize selectedItem	= _selectedItem;

// Flags
@synthesize shouldCollapseGroups	= _shouldCollapseGroups;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark - Properties accessors (Data)

- (void)setItems:(NSArray*)items
{
	if(_items == items)
		return;
	
	self.selectedItem = nil;
	
	_items = items;
	
	if(self.shouldCollapseGroups)
		[self collapseGroupsIfPossible];
	
	if([self isViewLoaded])
		[self.tableView reloadData];
}

- (void)setSelectedItem:(JFMenuItem*)selectedItem
{
	if(_selectedItem == selectedItem)
		return;
	
	// Checks if the new selected item is one of the menu items and cancels the operation if not.
	if(![self.items containsObject:selectedItem] && ![self groupForItem:selectedItem])
		return;
	
	JFMenuItem* oldItem = _selectedItem;
	
	_selectedItem = selectedItem;
	
	if(oldItem)
	{
		if([self isViewLoaded])
			[self updateCellAtIndexPath:[self indexPathOfItem:oldItem]];
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:didDeselectItem:)])
			[self.delegate menuViewController:self didDeselectItem:oldItem];
	}
	
	if(_selectedItem)
	{
		if([self isViewLoaded])
			[self updateCellAtIndexPath:[self indexPathOfItem:_selectedItem]];
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:didSelectItem:)])
			[self.delegate menuViewController:self didSelectItem:_selectedItem];
	}
	
	if(self.shouldCollapseGroups)
		[self collapseGroupsIfPossible];
}


#pragma mark - Properties accessors (Flags)

- (void)setShouldCollapseGroups:(BOOL)shouldCollapseGroups
{
	if(_shouldCollapseGroups == shouldCollapseGroups)
		return;
	
	_shouldCollapseGroups = shouldCollapseGroups;
	
	if(_shouldCollapseGroups)
		[self collapseGroupsIfPossible];
}

#pragma mark - Memory management

- (void)commonInit
{
	// Flags
	_shouldCollapseGroups = YES;
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
	
	self.tableView.rowHeight = [JFMenuItemTableViewCell height];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.tableView registerNib:[JFMenuItemTableViewCell nib] forCellReuseIdentifier:[JFMenuItemTableViewCell reuseIdentifier]];
}


#pragma mark - User interface management (Table view)

- (void)applyAttributesOfItem:(JFMenuItem*)item toCell:(JFMenuItemTableViewCell*)cell
{
	if(!item || !cell)
		return;
	
	JFMenuGroup* group = ([item isKindOfClass:[JFMenuGroup class]] ? (JFMenuGroup*)item : nil);
	
	BOOL isSelectedItem = (self.selectedItem == item);
	BOOL isContainingGroup = (group && [group.items containsObject:self.selectedItem]);
	
	JFMenuItemAttributes* attributes = (((isSelectedItem || isContainingGroup) && item.selectedAttributes) ? item.selectedAttributes : item.attributes);
	
	cell.backgroundColor = attributes.backgroundColor;
	
	cell.indentationLevel = attributes.indentationLevel;
	cell.indentationWidth = attributes.indentationWidth;
	
	cell.separatorColor = attributes.separatorColor;
	cell.separatorHeight = ((group && !group.isCollapsed && group.shouldHideSeparatorWhenExpanded) ? 0.0f : attributes.separatorHeight);
	
	cell.backgroundPadding = attributes.backgroundPadding;
	cell.contentPadding = attributes.contentPadding;
	
	cell.detailTextLabel.textColor = attributes.detailTextColor;
	cell.detailTextLabel.font = attributes.detailTextFont;
	cell.textLabel.textColor = attributes.textColor;
	cell.textLabel.font = attributes.textFont;
}

- (void)collapseGroup:(JFMenuGroup*)group atIndex:(NSInteger)index
{
	if(!group || group.isCollapsed)
		return;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:shouldCollapseGroup:)])
	{
		if(![self.delegate menuViewController:self shouldCollapseGroup:group])
			return;
	}
	
	group.isCollapsed = YES;
	
	if(![self isViewLoaded])
		return;
	
	Block completion = ^(void)
	{
		JFMenuItemTableViewCell* cell = (JFMenuItemTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
		[self applyAttributesOfItem:group toCell:cell];
	};
	
	NSMutableArray* indexPaths = [NSMutableArray array];
	for(NSUInteger row = 1; row <= [group.items count]; row++)
	{
		NSIndexPath* childIndexPath = [NSIndexPath indexPathForRow:row inSection:index];
		[indexPaths addObject:childIndexPath];
	}
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:completion];
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
	[CATransaction commit];
}

- (void)collapseGroupsIfPossible
{
	[self.tableView beginUpdates];
	for(NSUInteger index = 0; index < [self.items count]; index++)
	{
		JFMenuItem* item = [self.items objectAtIndex:index];
		if(![item isKindOfClass:[JFMenuGroup class]])
			continue;
		
		JFMenuGroup* group = (JFMenuGroup*)item;
		if(group.isCollapsed || (group == self.selectedItem) || ([group.items containsObject:self.selectedItem]))
			continue;
		
		[self collapseGroup:group atIndex:index];
	}
	[self.tableView endUpdates];
}

- (void)expandGroup:(JFMenuGroup*)group atIndex:(NSInteger)index
{
	if(!group || !group.isCollapsed)
		return;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(menuViewController:shouldExpandGroup:)])
	{
		if(![self.delegate menuViewController:self shouldExpandGroup:group])
			return;
	}
	
	group.isCollapsed = NO;
	
	if(![self isViewLoaded])
		return;
	
	JFMenuItemTableViewCell* cell = (JFMenuItemTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
	[self applyAttributesOfItem:group toCell:cell];
	
	NSMutableArray* indexPaths = [NSMutableArray array];
	for(NSUInteger row = 1; row <= [group.items count]; row++)
	{
		NSIndexPath* childIndexPath = [NSIndexPath indexPathForRow:row inSection:index];
		[indexPaths addObject:childIndexPath];
	}
	
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

- (void)loadDataOfItem:(JFMenuItem*)item intoCell:(JFMenuItemTableViewCell*)cell
{
	if(!cell || !item)
		return;
	
	JFMenuGroup* group = ([item isKindOfClass:[JFMenuGroup class]] ? (JFMenuGroup*)item : nil);
	
	BOOL isSelectedItem = (self.selectedItem == item);
	BOOL isContainingGroup = (group && [group.items containsObject:self.selectedItem]);
	
	cell.backgroundImage = item.backgroundImage;
	cell.detailTextLabel.text = item.detailText;
	cell.imageView.image = (((isSelectedItem || isContainingGroup) && item.selectedImage) ? item.selectedImage : item.image);
	cell.textLabel.text = item.text;
	cell.userInteractionEnabled = item.userInteractionEnabled;
}

- (void)updateCellAtIndexPath:(NSIndexPath*)indexPath
{
	if(!indexPath)
		return;
	
	JFMenuItemTableViewCell* cell = (JFMenuItemTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	if(!cell || !item)
		return;
	
	[self applyAttributesOfItem:item toCell:cell];
	[self loadDataOfItem:item intoCell:cell];
	
	JFMenuGroup* group = [self groupForItem:item];
	if(!group)
		return;
	
	[self updateCellAtIndexPath:[self indexPathOfItem:group]];
}


#pragma mark - Data management

- (JFMenuGroup*)groupForItem:(JFMenuItem*)item
{
	if([self.items containsObject:item])
		return nil;
	
	JFMenuGroup* retVal = nil;
	for(JFMenuItem* menuItem in self.items)
	{
		if(![menuItem isKindOfClass:[JFMenuGroup class]])
			continue;
		
		JFMenuGroup* group = (JFMenuGroup*)menuItem;
		if([group.items containsObject:item])
		{
			retVal = group;
			break;
		}
	}
	return retVal;
}

- (NSIndexPath*)indexPathOfItem:(JFMenuItem*)item
{
	JFMenuGroup* group = [self groupForItem:item];
	NSInteger section = [self.items indexOfObject:(group ? group : item)];
	NSInteger row = (group ? ([group.items indexOfObject:item] + 1) : 0);
	
	if((section == NSNotFound) || (row == NSNotFound))
		return nil;
	
	return [NSIndexPath indexPathForRow:row inSection:section];
}

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


#pragma mark - Protocol implementation (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	
	JFMenuItemTableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:[JFMenuItemTableViewCell reuseIdentifier] forIndexPath:indexPath];
	
	[self loadDataOfItem:item intoCell:retVal];
	
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


#pragma mark - Protocol implementation (UITableViewDelegate)

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
	
	self.selectedItem = item;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(JFMenuItemTableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	[self applyAttributesOfItem:item toCell:cell];
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFMenuItem* item = [self itemForRowAtIndexPath:indexPath];
	if(!item.selectionEnabled)
		return nil;
	
	return indexPath;
}

@end

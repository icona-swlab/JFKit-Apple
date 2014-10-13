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

@end



@implementation JFMenuViewController

#pragma mark - Properties

// Data
@synthesize items	= _items;

// Relationships
@synthesize delegate	= _delegate;


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


#pragma mark - Delegation management (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.items count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	retVal.textLabel.text = [NSString stringWithFormat:@"Cell n.%@", NSIntegerToString(indexPath.row + 1)];
	return retVal;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	JFMenuItem* item = [self.items objectAtIndex:section];
	if(![item isKindOfClass:[JFMenuGroup class]])
		return 1;
	
	JFMenuGroup* group = (JFMenuGroup*)item;
	return [group.items count] + 1;
}


#pragma mark - Delegation management (UITableViewDelegate)

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{}

@end

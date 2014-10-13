//
//  JFDrawerController.m
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



#import "JFDrawerController.h"

#import "JFMenuViewController.h"
#import "JFPaneledViewController.h"



@interface JFDrawerController ()

// User interface
@property (strong, nonatomic, readonly)	JFMenuViewController*		menuViewController;
@property (strong, nonatomic, readonly)	JFPaneledViewController*	paneledViewController;

@end



@implementation JFDrawerController

#pragma mark - Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// User interface
		_menuViewController = [[JFMenuViewController alloc] initWithStyle:UITableViewStylePlain];
		_paneledViewController = [[JFPaneledViewController alloc] init];
	}
	return self;
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.view addSubview:self.paneledViewController.view];
	
	self.paneledViewController.leftPanel = self.menuViewController;
}

@end

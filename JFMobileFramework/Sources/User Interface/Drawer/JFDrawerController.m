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



@interface JFDrawerController () <JFMenuViewControllerDelegate, JFPaneledViewControllerDelegate>

// User interface
@property (strong, nonatomic, readonly)	JFMenuViewController*		menuViewController;
@property (strong, nonatomic, readonly)	JFPaneledViewController*	paneledViewController;

@end



@implementation JFDrawerController

#pragma mark - Properties

// Attributes
@synthesize menuBackgroundColor	= _menuBackgroundColor;

// Flags
@synthesize selectedItem	= _selectedItem;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize menuViewController		= _menuViewController;
@synthesize paneledViewController	= _paneledViewController;
@synthesize rootViewController		= _rootViewController;


#pragma mark - Properties accessors (Attributes)

- (void)setMenuBackgroundColor:(UIColor*)menuBackgroundColor
{
	if(_menuBackgroundColor == menuBackgroundColor)
		return;
	
	_menuBackgroundColor = menuBackgroundColor;
	
	if([self isViewLoaded])
		self.menuViewController.view.backgroundColor = _menuBackgroundColor;
}


#pragma mark - Properties accessors (User interface)

- (void)setRootViewController:(UIViewController*)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	_rootViewController = rootViewController;
	
	self.paneledViewController.rootPanel = _rootViewController;
}


#pragma mark - Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// User interface
		_menuViewController = [[JFMenuViewController alloc] initWithStyle:UITableViewStylePlain];
		_paneledViewController = [[JFPaneledViewController alloc] init];
		
		// Builds the relationships.
		self.menuViewController.delegate = self;
		self.paneledViewController.delegate = self;
	}
	return self;
}


#pragma mark - Data management

- (void)setMenuItems:(NSArray*)items
{
	[self.menuViewController setMenuItems:items];
}


#pragma mark - User interface management

- (BOOL)hideMenu
{
	return [self hideMenu:YES];
}

- (BOOL)hideMenu:(BOOL)animated
{
	return [self.paneledViewController showRootPanel:animated completion:nil];
}

- (BOOL)showMenu
{
	return [self showMenu:YES];
}

- (BOOL)showMenu:(BOOL)animated
{
	return [self.paneledViewController showLeftPanel:animated completion:nil];
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.menuViewController.view.backgroundColor = self.menuBackgroundColor;
	
	[self.view addSubview:self.paneledViewController.view];
	
	self.paneledViewController.leftPanel = self.menuViewController;
	self.paneledViewController.rootPanel = self.rootViewController;
}


#pragma mark - Protocol implementation (JFMenuViewControllerDelegate)

- (void)menuViewController:(JFMenuViewController*)menuViewController didSelectItem:(JFMenuItem*)item
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(drawerController:didSelectItem:)])
		[self.delegate drawerController:self didSelectItem:item];
}


#pragma mark - Protocol implementation (JFPaneledViewControllerDelegate)

- (BOOL)paneledViewController:(JFPaneledViewController*)paneledViewController shouldShowRightPanel:(UIViewController*)rightPanel
{
	return NO;
}

@end

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
#import "JFSliderController.h"



@interface JFDrawerController () <JFMenuViewControllerDelegate, JFSliderControllerDelegate>

// User interface
@property (strong, nonatomic, readonly)	JFMenuViewController*	menuViewController;
@property (strong, nonatomic, readonly)	JFSliderController*		sliderController;

@end



@implementation JFDrawerController

#pragma mark - Properties

// Attributes
@synthesize menuBackgroundColor	= _menuBackgroundColor;
@synthesize menuBackgroundImage	= _menuBackgroundImage;

// Relationships
@synthesize delegate	= _delegate;

// User interface
@synthesize menuViewController	= _menuViewController;
@synthesize sliderController	= _sliderController;
@synthesize rootViewController	= _rootViewController;


#pragma mark - Properties accessors (Attributes)

- (void)setMenuBackgroundColor:(UIColor*)menuBackgroundColor
{
	if(_menuBackgroundColor == menuBackgroundColor)
		return;
	
	_menuBackgroundColor = menuBackgroundColor;
	
	if([self isViewLoaded])
		self.menuViewController.view.backgroundColor = _menuBackgroundColor;
}

- (void)setMenuBackgroundImage:(UIImage*)menuBackgroundImage
{
	if(_menuBackgroundImage == menuBackgroundImage)
		return;
	
	_menuBackgroundImage = menuBackgroundImage;
	
	// TODO: update the menu background.
}


#pragma mark - Properties accessors (Data)

- (NSArray*)menuItems
{
	return self.menuViewController.items;
}

- (void)setMenuItems:(NSArray*)menuItems
{
	self.menuViewController.items = menuItems;
}

- (JFMenuItem*)selectedMenuItem
{
	return self.menuViewController.selectedItem;
}

- (void)setSelectedMenuItem:(JFMenuItem*)selectedMenuItem
{
	self.menuViewController.selectedItem = selectedMenuItem;
}


#pragma mark - Properties accessors (User interface)

- (void)setRootViewController:(UIViewController*)rootViewController
{
	if(_rootViewController == rootViewController)
		return;
	
	_rootViewController = rootViewController;
	
	self.sliderController.rootPanel = _rootViewController;
}


#pragma mark - Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// User interface
		_menuViewController = [[JFMenuViewController alloc] init];
		_sliderController = [[JFSliderController alloc] init];
		
		// Builds the relationships.
		self.menuViewController.delegate = self;
		self.sliderController.delegate = self;
	}
	return self;
}


#pragma mark - User interface management

- (BOOL)hideMenu
{
	return [self hideMenu:YES];
}

- (BOOL)hideMenu:(BOOL)animated
{
	return [self.sliderController showPanel:JFSliderControllerPanelRoot animated:animated completion:nil];
}

- (BOOL)showMenu
{
	return [self showMenu:YES];
}

- (BOOL)showMenu:(BOOL)animated
{
	return [self.sliderController showPanel:JFSliderControllerPanelLeft animated:animated completion:nil];
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.menuViewController.view.backgroundColor = self.menuBackgroundColor;
	
	[self.view addSubview:self.sliderController.view];
	
	self.sliderController.leftPanel = self.menuViewController;
	self.sliderController.rootPanel = self.rootViewController;
}


#pragma mark - Protocol implementation (JFMenuViewControllerDelegate)

- (void)menuViewController:(JFMenuViewController*)menuViewController didSelectItem:(JFMenuItem*)item
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(drawerController:didSelectItem:)])
		[self.delegate drawerController:self didSelectItem:item];
}


#pragma mark - Protocol implementation (JFSliderControllerDelegate)

- (BOOL)sliderController:(JFSliderController*)sliderController shouldShowPanel:(JFSliderControllerPanel)panel
{
	return (panel != JFSliderControllerPanelRight);
}

@end

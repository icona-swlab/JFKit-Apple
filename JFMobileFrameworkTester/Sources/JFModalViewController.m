//
//  JFModalViewController.m
//  JFMobileFrameworkTester
//
//  Created by Jacopo Filié on 05/01/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFModalViewController.h"



@interface JFModalViewController ()

// User interface management (Actions)
- (void)	dismiss;

@end



@implementation JFModalViewController

#pragma mark - Memory management

- (instancetype)init
{
	return [self initWithNibName:StandardXIBName bundle:nil];
}


#pragma mark - User interface management (Actions)

- (void)dismiss
{
	[self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}


#pragma mark - User interface management (Inherited)

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
}

@end

//
//  JFTabBarController.m
//  JFMobileFramework
//
//  Created by Jacopo Filié on 02/01/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFTabBarController.h"



@interface JFTabBarController ()

@end



@implementation JFTabBarController

#pragma mark - User interface management (Rotation)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return [self.selectedViewController supportedInterfaceOrientations];
}

@end

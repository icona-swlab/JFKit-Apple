//
//  JFTabBarController.m
//  JFMobileFramework
//
//  Created by Jacopo Filié on 02/01/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



#import "JFTabBarController.h"

#import "JFUtilities.h"



@interface JFTabBarController ()

@end



@implementation JFTabBarController

#pragma mark - User interface management (Rotation)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	if(!iOS7Plus)
	{
		if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarControllerPreferredInterfaceOrientationForPresentation:)])
			return [self.delegate tabBarControllerPreferredInterfaceOrientationForPresentation:self];
	}
	
	return [super preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarControllerShouldAutorotate:)])
		return [self.delegate tabBarControllerShouldAutorotate:self];
	
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	if(!iOS7Plus)
	{
		if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarControllerSupportedInterfaceOrientations:)])
			return [self.delegate tabBarControllerSupportedInterfaceOrientations:self];
	}
	
	return [super supportedInterfaceOrientations];
}

@end

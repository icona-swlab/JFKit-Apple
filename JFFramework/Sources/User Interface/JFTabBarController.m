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



#pragma mark



@implementation JFTabBarController

#pragma mark User interface management (Rotation)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	if(!iOS7Plus)
	{
		id<JFTabBarControllerDelegate> delegate = self.delegate;
		if(delegate && [delegate respondsToSelector:@selector(tabBarControllerPreferredInterfaceOrientationForPresentation:)])
			return [delegate tabBarControllerPreferredInterfaceOrientationForPresentation:self];
	}
	
	return [super preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	id<JFTabBarControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(tabBarControllerShouldAutorotate:)])
		return [delegate tabBarControllerShouldAutorotate:self];
	
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	if(!iOS7Plus)
	{
		id<JFTabBarControllerDelegate> delegate = self.delegate;
		if(delegate && [delegate respondsToSelector:@selector(tabBarControllerSupportedInterfaceOrientations:)])
			return [delegate tabBarControllerSupportedInterfaceOrientations:self];
	}
	
	return [super supportedInterfaceOrientations];
}

@end

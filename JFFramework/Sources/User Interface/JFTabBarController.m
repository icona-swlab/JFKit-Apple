//
//  JFTabBarController.m
//  Copyright (C) 2014 Jacopo Filié
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



#import "JFTabBarController.h"

#import "JFUtilities.h"



@interface JFTabBarController ()

@end



#pragma mark



@implementation JFTabBarController

#pragma mark Properties

// Relationships
@dynamic delegate;


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

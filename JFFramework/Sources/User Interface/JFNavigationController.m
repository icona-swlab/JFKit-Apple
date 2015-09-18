//
//  JFNavigationController.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFNavigationController.h"

#import "JFUtilities.h"



@interface JFNavigationController ()

@end



#pragma mark



@implementation JFNavigationController

#pragma mark Properties

// Relationships
@dynamic delegate;


#pragma mark Properties accessors (User interface)

- (UIViewController*)rootViewController
{
	return [[self viewControllers] firstObject];
}


#pragma mark User interface management (Rotation)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	if(!iOS7Plus)
	{
		id<JFNavigationControllerDelegate> delegate = self.delegate;
		if(delegate && [delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)])
			return [delegate navigationControllerPreferredInterfaceOrientationForPresentation:self];
	}
	
	return [super preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	id<JFNavigationControllerDelegate> delegate = self.delegate;
	if(delegate && [delegate respondsToSelector:@selector(navigationControllerShouldAutorotate:)])
		return [delegate navigationControllerShouldAutorotate:self];
	
	return [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	if(!iOS7Plus)
	{
		id<JFNavigationControllerDelegate> delegate = self.delegate;
		if(delegate && [delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)])
			return [delegate navigationControllerSupportedInterfaceOrientations:self];
	}
	
	return [super supportedInterfaceOrientations];
}

@end

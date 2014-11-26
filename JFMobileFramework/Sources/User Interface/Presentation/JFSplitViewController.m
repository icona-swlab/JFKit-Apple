//
//  JFSplitViewController.m
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



#import "JFSplitViewController.h"



@interface JFSplitViewController ()

@end



@implementation JFSplitViewController

#pragma mark - User interface management (Inherited)

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(splitViewControllerPreferredInterfaceOrientationForPresentation:)])
		return [self.delegate splitViewControllerPreferredInterfaceOrientationForPresentation:self];
	
	return [super preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(splitViewControllerShouldAutorotate:)])
		return [self.delegate splitViewControllerShouldAutorotate:self];
	
	return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(splitViewControllerSupportedInterfaceOrientations:)])
		return [self.delegate splitViewControllerSupportedInterfaceOrientations:self];
	
	return [super supportedInterfaceOrientations];
}

@end

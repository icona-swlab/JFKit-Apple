//
//  JFViewController.m
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



#import "JFViewController.h"

#import "JFUtilities.h"



#pragma mark Notifications

// Navigation
NSString* const	JFViewControllerHasBeenDismissedNotification	= @"JFViewControllerHasBeenDismissedNotification";
NSString* const	JFViewControllerHasBeenPoppedNotification		= @"JFViewControllerHasBeenPoppedNotification";
NSString* const	JFViewControllerHasBeenPresentedNotification	= @"JFViewControllerHasBeenPresentedNotification";
NSString* const	JFViewControllerHasBeenPushedNotification		= @"JFViewControllerHasBeenPushedNotification";
NSString* const	JFViewControllerIsBeingDismissedNotification	= @"JFViewControllerIsBeingDismissedNotification";
NSString* const	JFViewControllerIsBeingPoppedNotification		= @"JFViewControllerIsBeingPoppedNotification";
NSString* const	JFViewControllerIsBeingPresentedNotification	= @"JFViewControllerIsBeingPresentedNotification";
NSString* const	JFViewControllerIsBeingPushedNotification		= @"JFViewControllerIsBeingPushedNotification";



#pragma mark



@interface JFViewController ()

#pragma mark Methods

// Notifications management (Navigation)
- (void)	notifyHasBeenDismissed:(BOOL)animated;
- (void)	notifyHasBeenPopped:(BOOL)animated;
- (void)	notifyHasBeenPresented:(BOOL)animated;
- (void)	notifyHasBeenPushed:(BOOL)animated;
- (void)	notifyIsBeingDismissed:(BOOL)animated;
- (void)	notifyIsBeingPopped:(BOOL)animated;
- (void)	notifyIsBeingPresented:(BOOL)animated;
- (void)	notifyIsBeingPushed:(BOOL)animated;

@end



#pragma mark



@implementation JFViewController

#pragma mark Memory management

- (instancetype)init
{
	return [self initWithNibName:StandardXIBName bundle:nil];
}


#pragma mark User interface management (View lifecycle)

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([self isBeingPresented])
		[self notifyHasBeenPresented:animated];
	
	if([self isMovingToParentViewController])
		[self notifyHasBeenPushed:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if([self isBeingDismissed])
		[self notifyHasBeenDismissed:animated];
	
	if([self isMovingFromParentViewController])
		[self notifyHasBeenPopped:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if([self isBeingPresented])
		[self notifyIsBeingPresented:animated];
	
	if([self isMovingToParentViewController])
		[self notifyIsBeingPushed:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if([self isBeingDismissed])
		[self notifyIsBeingDismissed:animated];
	
	if([self isMovingFromParentViewController])
		[self notifyIsBeingPopped:animated];
}


#pragma mark Notifications management (Navigation)

- (void)notifyHasBeenDismissed:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenDismissedNotification object:self];
}

- (void)notifyHasBeenPopped:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPoppedNotification object:self];
}

- (void)notifyHasBeenPresented:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPresentedNotification object:self];
}

- (void)notifyHasBeenPushed:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPushedNotification object:self];
}

- (void)notifyIsBeingDismissed:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerIsBeingDismissedNotification object:self];
}

- (void)notifyIsBeingPopped:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerIsBeingPoppedNotification object:self];
}

- (void)notifyIsBeingPresented:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerIsBeingPresentedNotification object:self];
}

- (void)notifyIsBeingPushed:(BOOL)animated
{
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerIsBeingPushedNotification object:self];
}

@end

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

#import "JFLogger.h"
#import "JFUtilities.h"



#pragma mark Notifications

// Navigation (Keys)
NSString* const	JFViewControllerIsAnimatedKey	= @"JFViewControllerIsAnimatedKey";

// Navigation (Names)
NSString* const	JFViewControllerHasBeenDismissedNotification	= @"JFViewControllerHasBeenDismissedNotification";
NSString* const	JFViewControllerHasBeenPoppedNotification		= @"JFViewControllerHasBeenPoppedNotification";
NSString* const	JFViewControllerHasBeenPresentedNotification	= @"JFViewControllerHasBeenPresentedNotification";
NSString* const	JFViewControllerHasBeenPushedNotification		= @"JFViewControllerHasBeenPushedNotification";
NSString* const	JFViewControllerWillBeDismissedNotification		= @"JFViewControllerWillBeDismissedNotification";
NSString* const	JFViewControllerWillBePoppedNotification		= @"JFViewControllerWillBePoppedNotification";
NSString* const	JFViewControllerWillBePresentedNotification		= @"JFViewControllerWillBePresentedNotification";
NSString* const	JFViewControllerWillBePushedNotification		= @"JFViewControllerWillBePushedNotification";



#pragma mark



@interface JFViewController ()

#pragma mark Methods

// Notifications management (Navigation)
- (void)	notifyHasBeenDismissed:(BOOL)animated;
- (void)	notifyHasBeenPopped:(BOOL)animated;
- (void)	notifyHasBeenPresented:(BOOL)animated;
- (void)	notifyHasBeenPushed:(BOOL)animated;
- (void)	notifyWillBeDismissed:(BOOL)animated;
- (void)	notifyWillBePopped:(BOOL)animated;
- (void)	notifyWillBePresented:(BOOL)animated;
- (void)	notifyWillBePushed:(BOOL)animated;

@end



#pragma mark



@implementation JFViewController

#pragma mark Properties

// Debug
@synthesize logger	= _logger;
@synthesize logging	= _logging;


#pragma mark Memory management

- (instancetype)init
{
	return [self initWithNibName:StandardXIBName bundle:nil];
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil logger:[JFLogger defaultLogger]];
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil logger:(JFLogger*)logger
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		// Debug
		_logger = logger;
		_logging = YES;
	}
	return self;
}


#pragma mark User interface management (Navigation)

- (void)hasBeenDismissed:(BOOL)animated
{}

- (void)hasBeenPopped:(BOOL)animated
{}

- (void)hasBeenPresented:(BOOL)animated
{}

- (void)hasBeenPushed:(BOOL)animated
{}

- (void)willBeDismissed:(BOOL)animated
{}

- (void)willBePopped:(BOOL)animated
{}

- (void)willBePresented:(BOOL)animated
{}

- (void)willBePushed:(BOOL)animated
{}


#pragma mark User interface management (View lifecycle)

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([self isBeingPresented])
	{
		[self hasBeenPresented:animated];
		[self notifyHasBeenPresented:animated];
	}
	
	if([self isMovingToParentViewController])
	{
		[self hasBeenPushed:animated];
		[self notifyHasBeenPushed:animated];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if([self isBeingDismissed])
	{
		[self hasBeenDismissed:animated];
		[self notifyHasBeenDismissed:animated];
	}
	
	if([self isMovingFromParentViewController])
	{
		[self hasBeenPopped:animated];
		[self notifyHasBeenPopped:animated];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if([self isBeingPresented])
	{
		[self willBePresented:animated];
		[self notifyWillBePresented:animated];
	}
	
	if([self isMovingToParentViewController])
	{
		[self willBePushed:animated];
		[self notifyWillBePushed:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if([self isBeingDismissed])
	{
		[self willBeDismissed:animated];
		[self notifyWillBeDismissed:animated];
	}
	
	if([self isMovingFromParentViewController])
	{
		[self willBePopped:animated];
		[self notifyWillBePopped:animated];
	}
}


#pragma mark Notifications management (Navigation)

- (void)notifyHasBeenDismissed:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenDismissedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPopped:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPoppedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPresented:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPresentedNotification object:self userInfo:userInfo];
}

- (void)notifyHasBeenPushed:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerHasBeenPushedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBeDismissed:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBeDismissedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePopped:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePoppedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePresented:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePresentedNotification object:self userInfo:userInfo];
}

- (void)notifyWillBePushed:(BOOL)animated
{
	NSDictionary* userInfo = @{JFViewControllerIsAnimatedKey : @(animated)};
	[NSDefaultNotificationCenter postNotificationName:JFViewControllerWillBePushedNotification object:self userInfo:userInfo];
}

@end

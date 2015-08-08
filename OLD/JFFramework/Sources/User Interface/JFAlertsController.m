//
//  JFAlertsController.m
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



#import "JFAlertsController.h"

#import "JFAlert.h"



@interface JFAlertsController () <JFAlertDelegate>

#pragma mark Properties

// User interface
@property (strong, nonatomic, readonly)	NSMutableSet*	alerts;


#pragma mark Methods

// User interface management (Action sheets)
- (JFAlert*)	createActionSheetWithTitle:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons;

@end



#pragma mark



@implementation JFAlertsController

#pragma mark Properties

// User interface
@synthesize alerts	= _alerts;


#pragma mark Memory management

- (void)dealloc
{
	for(JFAlert* alert in self.alerts)
		[alert dismiss:nil];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// User interface
		_alerts = [NSMutableSet new];
	}
	return self;
}


#pragma mark User interface management (Action sheets)

- (JFAlert*)createActionSheetWithTitle:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* retVal = [[JFAlert alloc] init];
	retVal.delegate = self;
	retVal.title = title;
	
	retVal.cancelButton = cancelButton;
	retVal.destructiveButton = destructiveButton;
	retVal.otherButtons = otherButtons;
	
	return retVal;
}

- (void)presentActionSheetFromBarButtonItem:(UIBarButtonItem*)barButtonItem title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromBarButtonItem:barButtonItem completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromRect:(CGRect)rect inView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromRect:rect inView:view completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromTabBar:(UITabBar*)tabBar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromTabBar:tabBar completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromToolbar:(UIToolbar*)toolbar title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromToolbar:toolbar completion:nil])
			[self.alerts addObject:alert];
	});
}

- (void)presentActionSheetFromView:(UIView*)view title:(NSString*)title cancelButton:(JFAlertButton*)cancelButton destructiveButton:(JFAlertButton*)destructiveButton otherButtons:(NSArray*)otherButtons
{
	JFAlert* alert = [self createActionSheetWithTitle:title cancelButton:cancelButton destructiveButton:destructiveButton otherButtons:otherButtons];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsActionSheetFromView:view completion:nil])
			[self.alerts addObject:alert];
	});
}


#pragma mark User interface management (Alert views)

- (void)presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray*)otherButtons
{
	[self presentAlertViewWithTitle:title message:message cancelButton:cancelButton otherButtons:otherButtons timeout:0.0];
}

- (void)presentAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButton:(JFAlertButton*)cancelButton otherButtons:(NSArray*)otherButtons timeout:(NSTimeInterval)timeout
{
	JFAlert* alert = [[JFAlert alloc] init];
	alert.delegate = self;
	alert.message = message;
	alert.title = title;
	
	alert.cancelButton = cancelButton;
	alert.otherButtons = otherButtons;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		if([alert presentAsAlertViewWithTimeout:timeout completion:nil])
			[self.alerts addObject:alert];
	});
}


#pragma mark Protocol implementation (JFAlertViewDelegate)

- (void)alert:(JFAlert*)alert didDismissWithButton:(JFAlertButton*)button
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.alerts removeObject:alert];
	});
}

@end

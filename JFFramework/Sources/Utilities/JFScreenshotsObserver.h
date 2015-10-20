//
//  JFScreenshotsObserver.h
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



#import "JFManager.h"

#import "JFTypes.h"



#pragma mark - Constans

FOUNDATION_EXPORT	NSString* const	JFScreenshotsObserverListUpdatedNotification;


#pragma mark - Typedefs

typedef NS_ENUM(NSInteger, JFPhotosAuthorizationStatus)
{
	JFPhotosAuthorizationStatusNotDetermined,
	JFPhotosAuthorizationStatusRestricted,
	JFPhotosAuthorizationStatusDenied,
	JFPhotosAuthorizationStatusAuthorized
};



#pragma mark



@interface JFScreenshotsObserver : JFManager

#pragma mark Properties

// Data
@property (assign, nonatomic, readonly)	UIImage*	newestScreenshot;
@property (assign, nonatomic, readonly)	UIImage*	oldestScreenshot;
@property (assign, nonatomic, readonly)	NSUInteger	screenshotsCount;

// Flags
@property (assign, nonatomic, readonly)				JFPhotosAuthorizationStatus	authorizationStatus;
@property (assign, readonly, getter = isObserving)	BOOL						observing;


#pragma mark Methods

// Data management
- (void)		requestScreenshotAtIndex:(NSUInteger)index completion:(JFBlockWithObject)completion;
- (UIImage*)	screenshotAtIndex:(NSUInteger)index;

// Services management
- (void)	startObserving;
- (void)	stopObserving;

@end

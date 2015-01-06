//
//  JFMobileKit.h
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



#ifndef JFMobileFramework_JFMobileKit_h
#define JFMobileFramework_JFMobileKit_h

// SDK
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Data access
#import	"JFCoreDataManager.h"
#import	"JFHTTPRequest.h"

// Debug
#import "JFLogger.h"

// User interface (Activity Indicators)
#import "JFActivityIndicatorView.h"

// User interface (Alerts)
#import "JFAlertView.h"

// User interface (Galleries)
#import "JFGalleryView.h"

// User interface (Keyboard)
#import "JFKeyboardViewHandler.h"

// User interface (Structure)
#import "JFNavigationController.h"
#import "JFSliderController.h"
#import "JFSplitViewController.h"
#import "JFTabBarController.h"

// User interface (Tables)
#import "JFTableViewSection.h"

// User interface (Texts)
#import "JFLabel.h"
#import "JFTextView.h"

// User interface (Toolbars)
#import "JFTransparentToolbar.h"

// User interface (Work In Progress)
#import "JFDrawerController.h"
#import "JFMenuItem.h"
#import "JFMenuViewController.h"
#import "JFSimpleFormViewController.h"

// Utilities
#import "JFFileManager.h"
#import "JFUpdatableFile.h"
#import "JFUtilities.h"

#endif
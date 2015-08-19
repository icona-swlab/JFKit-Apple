//
//  JFFramework.h
//  Copyright (C) 2015  Jacopo Filié
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



#pragma mark - Framework version constants

#if TARGET_OS_IPHONE

//! Project version number for JFFramework-iOS.
FOUNDATION_EXPORT double JFFramework_iOSVersionNumber;

//! Project version string for JFFramework-iOS.
FOUNDATION_EXPORT const unsigned char JFFramework_iOSVersionString[];

#else

//! Project version number for JFFramework-OSX.
FOUNDATION_EXPORT double JFFramework_OSXVersionNumber;

//! Project version string for JFFramework-OSX.
FOUNDATION_EXPORT const unsigned char JFFramework_OSXVersionString[];

#endif



#pragma mark - Common headers

// Addons (Data Objects)
#import "NSIndexPath+JFFramework.h"

// Addons (Utilities)
#import "NSFileManager+JFFramework.h"
#import "NSObject+JFFramework.h"

// Core
#import "JFManager.h"

// Data objects
#import "JFByteStream.h"
#import "JFColor.h"
#import "JFString.h"

// Utilities
#import	"JFHTTPRequest.h"
#import "JFLogger.h"
#import "JFUtilities.h"
#import "JFXMLParser.h"

#if TARGET_OS_IPHONE
#pragma mark - iOS specific headers

// Core
#import "JFAppDelegate.h"

// User Interface
#import "JFAlert.h"
#import "JFAlertsController.h"
#import "JFWindowController.h"

#else
#pragma mark - OS X specific headers

#endif

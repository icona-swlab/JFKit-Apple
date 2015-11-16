//
//  JFShortcuts.h
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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros

#define	ApplicationDelegate		((AppDelegate*)[SharedApplication delegate])
#define	ClassBundle				[NSBundle bundleForClass:[self class]]
#define	ClassName				NSStringFromClass([self class])
#define	LogMethod				NSLog(@"%@ (%@): executing '%@'.", ClassName, JFStringFromPointerOfObject(self), MethodName)
#define MainBundle				[NSBundle mainBundle]
#define MainNotificationCenter	[NSNotificationCenter defaultCenter]
#define MainOperationQueue		[NSOperationQueue mainQueue]
#define MethodName				NSStringFromSelector(_cmd)
#define ProcessInfo				[NSProcessInfo processInfo]

#if TARGET_OS_IPHONE
#define CurrentDevice				[UIDevice currentDevice]
#define CurrentDeviceOrientation	[CurrentDevice orientation]
#define CurrentStatusBarOrientation	[SharedApplication statusBarOrientation]
#define MainScreen					[UIScreen mainScreen]
#define	SharedApplication			[UIApplication sharedApplication]
#else
#define	SharedApplication			NSApp
#define	SharedWorkspace				[NSWorkspace sharedWorkspace]
#endif


#pragma mark Macros (Info)

#define AppBuild			JFApplicationInfoForKey(@"CFBundleVersion")
#define AppDetailedVersion	[NSString stringWithFormat:@"%@ (%@)", AppVersion, AppBuild]
#define AppDisplayName		JFApplicationInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier		JFApplicationInfoForKey(@"CFBundleIdentifier")
#define AppName				JFApplicationInfoForKey(@"CFBundleName")
#define AppVersion			JFApplicationInfoForKey(@"CFBundleShortVersionString")


#pragma mark Macros (System)

#if TARGET_OS_IPHONE
#define iPad				(UserInterfaceIdiom == UIUserInterfaceIdiomPad)
#define iPhone				(UserInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define SystemVersion		[CurrentDevice systemVersion]
#define UserInterfaceIdiom	[CurrentDevice userInterfaceIdiom]
#endif


#pragma mark Macros (Version)

#if TARGET_OS_IPHONE
#define iOS(_version)		JFCheckSystemVersion(_version, JFRelationEqual)
#define iOSPlus(_version)	JFCheckSystemVersion(_version, JFRelationGreaterThanOrEqual)
#define iOS6				iOS(@"6")
#define iOS6Plus			iOSPlus(@"6")
#define iOS7				iOS(@"7")
#define iOS7Plus			iOSPlus(@"7")
#define iOS8				iOS(@"8")
#define iOS8Plus			iOSPlus(@"8")
#define iOS9				iOS(@"9")
#define iOS9Plus			iOSPlus(@"9")
#else
#define OSX(_version)		JFCheckSystemVersion(_version, JFRelationEqual)
#define OSXPlus(_version)	JFCheckSystemVersion(_version, JFRelationGreaterThanOrEqual)
#define OSX10_6				OSX(@"10.6")
#define OSX10_6Plus			OSXPlus(@"10.6")
#define OSX10_7				OSX(@"10.7")
#define OSX10_7Plus			OSXPlus(@"10.7")
#define OSX10_8				OSX(@"10.8")
#define OSX10_8Plus			OSXPlus(@"10.8")
#define OSX10_9				OSX(@"10.9")
#define OSX10_9Plus			OSXPlus(@"10.9")
#define OSX10_10			OSX(@"10.10")
#define OSX10_10Plus		OSXPlus(@"10.10")
#define OSX10_11			OSX(@"10.11")
#define OSX10_11Plus		OSXPlus(@"10.11")
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

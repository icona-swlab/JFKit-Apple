//
//  JFUtilities.h
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



#import "JFString.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros

#define	ClassBundle				[NSBundle bundleForClass:[self class]]
#define	ClassName				JFStringFromObjectClass(self)
#define	LogMethod				NSLog(@"%@ (%@): executing '%@'.", ClassName, JFStringFromID(self), MethodName)
#define MainBundle				[NSBundle mainBundle]
#define MainNotificationCenter	[NSNotificationCenter defaultCenter]
#define MainOperationQueue		[NSOperationQueue mainQueue]
#define MethodName				NSStringFromSelector(_cmd)

#if TARGET_OS_IPHONE
#define	ApplicationDelegate				((AppDelegate*)[SharedApplication delegate])
#define CurrentDevice					[UIDevice currentDevice]
#define CurrentDeviceOrientation		[CurrentDevice orientation]
#define CurrentStatusBarOrientation		[SharedApplication statusBarOrientation]
#define JFHideNetworkActivityIndicator	JFToggleNetworkActivityIndicator(NO)
#define JFNibName						JFNibNameForClass([self class])
#define JFShowNetworkActivityIndicator	JFToggleNetworkActivityIndicator(YES)
#define MainScreen						[UIScreen mainScreen]
#define	SharedApplication				[UIApplication sharedApplication]
#define weak							weak
#else
#define JFHideNetworkActivityIndicator
#define JFShowNetworkActivityIndicator
#define weak							unsafe_unretained
#endif


#pragma mark Macros (Info)

#define AppDisplayName	JFApplicationInfoForKey(@"CFBundleDisplayName")
#define AppIdentifier	JFApplicationInfoForKey(@"CFBundleIdentifier")
#define AppName			JFApplicationInfoForKey(@"CFBundleName")
#define AppVersionLong	JFApplicationInfoForKey(@"CFBundleVersion")
#define AppVersionShort	JFApplicationInfoForKey(@"CFBundleShortVersionString")


#pragma mark Macros (Localization)

#define	JFBundleLanguage					[JFBundleLanguages firstObject];
#define	JFBundleLanguages					[MainBundle preferredLocalizations];
#define	JFDevelopmentLanguage				[MainBundle developmentLocalization];
#define JFLocalizedString(_key, _defVal)	NSLocalizedStringWithDefaultValue(_key, nil, ClassBundle, _defVal, _comment)
#define	JFSystemLanguage					[JFSystemLanguages firstObject]
#define	JFSystemLanguages					[NSLocale preferredLanguages]


#pragma mark Macros (Resources)

#define JFResourceURL(_filename)				JFBundleResourceURLForFile(ClassBundle, _filename)
#define JFResourceURLWithType(_filename, _type)	JFBundleResourceURLForFileWithType(ClassBundle, _filename, _type)


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
#endif


////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedefs

typedef NS_ENUM(UInt8, JFRelation) {
	JFRelationLessThan,
	JFRelationLessThanOrEqual,
	JFRelationEqual,
	JFRelationGreaterThanOrEqual,
	JFRelationGreaterThan,
};


#pragma mark Typedefs (Blocks)

typedef void	(^JFBlock)					(void);
typedef void	(^JFBlockWithArray)			(NSArray* array);
typedef void	(^JFBlockWithBOOL)			(BOOL value);
typedef void	(^JFBlockWithDictionary)	(NSDictionary* dictionary);
typedef void	(^JFBlockWithError)			(NSError* error);
typedef void	(^JFBlockWithInteger)		(NSInteger value);
typedef void	(^JFBlockWithNotification)	(NSNotification* notification);
typedef void	(^JFBlockWithObject)		(id object);
typedef void	(^JFBlockWithSet)			(NSSet* set);
typedef void	(^JFCompletionBlock)		(BOOL succeded, id object, NSError* error);
typedef void	(^JFSimpleCompletionBlock)	(BOOL succeded, NSError* error);


#pragma mark Typedefs (Math)

typedef double	JFDegrees;
typedef double	JFRadians;


#pragma mark Typedefs (Metrics)

typedef NS_ENUM(UInt64, JFMetrics) {
	
	// Binary
	JFKibi	= 1024ULL,
	JFMebi	= JFKibi * JFKibi,
	JFGibi	= JFMebi * JFKibi,
	JFTebi	= JFGibi * JFKibi,
	
	// Decimal
	JFKilo	= 1000ULL,
	JFMega	= JFKilo * JFKilo,
	JFGiga	= JFMega * JFKilo,
	JFTera	= JFGiga * JFKilo,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT NSTimeInterval const	JFAnimationDuration;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT id	JFApplicationInfoForKey(NSString* key);
FOUNDATION_EXPORT BOOL	JFAreObjectsEqual(id obj1, id obj2);

#if TARGET_OS_IPHONE
FOUNDATION_EXPORT NSString*	JFNibNameForClass(Class class);
FOUNDATION_EXPORT void		JFToggleNetworkActivityIndicator(BOOL visible);
#endif


#pragma mark Functions (Images)

#if TARGET_OS_IPHONE
FOUNDATION_EXPORT NSString*	JFGetLaunchImageName();
FOUNDATION_EXPORT NSString*	JFGetLaunchImageNameForOrientation(UIInterfaceOrientation orientation);
#endif


#pragma mark Functions (Math)

FOUNDATION_EXPORT JFDegrees	JFDegreesFromRadians(JFRadians radians);
FOUNDATION_EXPORT JFRadians	JFRadiansFromDegress(JFDegrees degrees);


#pragma mark Functions (Resources)

FOUNDATION_EXPORT NSURL*	JFBundleResourceURLForFile(NSBundle* bundle, NSString* filename);
FOUNDATION_EXPORT NSURL*	JFBundleResourceURLForFileWithType(NSBundle* bundle, NSString* filename, NSString* type);

#pragma mark Functions (Runtime)

FOUNDATION_EXPORT void	JFPerformSelector(NSObject* target, SEL action);
FOUNDATION_EXPORT void	JFPerformSelector1(NSObject* target, SEL action, id object);
FOUNDATION_EXPORT void	JFPerformSelector2(NSObject* target, SEL action, id obj1, id obj2);


#pragma mark Functions (Version)

#if TARGET_OS_IPHONE
FOUNDATION_EXPORT BOOL	JFCheckSystemVersion(NSString* version, JFRelation relation);
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

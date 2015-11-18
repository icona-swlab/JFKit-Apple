//
//  JFUtilities.m
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



#import "JFUtilities.h"

#import "JFString.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

NSTimeInterval const	JFAnimationDuration	= 0.25;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

id JFApplicationInfoForKey(NSString* key)
{
	return [[MainBundle infoDictionary] objectForKey:key];
}

BOOL JFAreObjectsEqual(id<NSObject> obj1, id<NSObject> obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^checkClass)(Class) = ^BOOL(Class class)
	{
		if(![obj1 isKindOfClass:class])	return NO;
		if(![obj2 isKindOfClass:class])	return NO;
		return YES;
	};
	
	id o1 = obj1;
	id o2 = obj2;
	
	if(checkClass([NSArray class]))			return [o1 isEqualToArray:o2];
	if(checkClass([NSData class]))			return [o1 isEqualToData:o2];
	if(checkClass([NSDate class]))			return [o1 isEqualToDate:o2];
	if(checkClass([NSDictionary class]))	return [o1 isEqualToDictionary:o2];
	if(checkClass([NSNumber class]))		return [o1 isEqualToNumber:o2];
	if(checkClass([NSSet class]))			return [o1 isEqualToSet:o2];
	if(checkClass([NSString class]))		return [o1 isEqualToString:o2];
	
	return [obj1 isEqual:obj2];
}

#if TARGET_OS_IPHONE

NSString* JFNibNameForClass(Class class)
{
	NSString* retVal = nil;
	while(!retVal && class)
	{
		NSBundle* bundle = [NSBundle bundleForClass:class];
		NSString* className = NSStringFromClass(class);
		
		for(NSUInteger i = 0; i < 2; i++)
		{
			NSString* baseName;
			if(i == 0)
			{
				NSRange range = [className rangeOfString:@"Controller" options:NSBackwardsSearch];
				if(range.location == NSNotFound)
					continue;
				
				baseName = [className stringByReplacingCharactersInRange:range withString:JFEmptyString];
			}
			else
				baseName = className;
			
			for(NSUInteger j = 0; j < 2; j++)
			{
				NSString* fileName = ((j == 0) ? [baseName stringByAppendingString:(iPad ? @"~ipad" : @"~iphone")] : baseName);
				if(JFBundleResourceURLForFileWithType(bundle, fileName, @"nib"))
				{
					retVal = fileName;
					break;
				}
			}
			
			if(retVal)
				break;
		}
		
		if(!retVal)
			class = [class superclass];
	}
	return retVal;
}

void JFToggleNetworkActivityIndicator(BOOL visible)
{
	static NSUInteger counter = 0;
	[MainOperationQueue addOperationWithBlock:^{
		counter += (visible ? 1 : -1);
		SharedApplication.networkActivityIndicatorVisible = (counter > 0);
	}];
}

#endif


#pragma mark Functions (Images)

#if TARGET_OS_IPHONE

NSString* JFLaunchImageName()
{
	return JFLaunchImageNameForOrientation(CurrentStatusBarOrientation);
}

NSString* JFLaunchImageNameForOrientation(UIInterfaceOrientation orientation)
{
	static NSString* const NameKey				= @"UILaunchImageName";
	static NSString* const MinimumOSVersionKey	= @"UILaunchImageMinimumOSVersion";
	static NSString* const OrientationKey		= @"UILaunchImageOrientation";
	static NSString* const SizeKey				= @"UILaunchImageSize";
	
	static NSDictionary* LaunchScreens = nil;
	if(!LaunchScreens)
	{
		NSArray* dicts = JFApplicationInfoForKey(@"UILaunchImages");
		
		NSString* searchString = @"-700";
		
		NSMutableDictionary* mDicts = [NSMutableDictionary dictionaryWithCapacity:[dicts count]];
		for(NSDictionary* dict in dicts)
		{
			NSString* key = [dict objectForKey:NameKey];
			NSMutableDictionary* mDict = [dict mutableCopy];
			[mDict removeObjectForKey:NameKey];
			[mDicts setObject:[mDict copy] forKey:key];
			
			NSRange range = [key rangeOfString:searchString];
			if(range.location != NSNotFound)
			{
				key = [key stringByReplacingOccurrencesOfString:searchString withString:JFEmptyString];
				[mDict removeObjectForKey:MinimumOSVersionKey];
				[mDicts setObject:[mDict copy] forKey:key];
			}
		}
		LaunchScreens = [mDicts copy];
	}
	
	static CGSize screenSize = {0.0, 0.0};
	if(CGSizeEqualToSize(screenSize, CGSizeZero))
	{
		UIScreen* screen = MainScreen;
		CGRect screenBounds = (iOS8Plus ? [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace] : screen.bounds);
		screenSize = screenBounds.size;
	}
	
	static NSString* landscapeRetObj = nil;
	static NSString* portraitRetObj = nil;
	
	BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
	
	NSString* retObj = (isLandscape ? landscapeRetObj : (isPortrait ? portraitRetObj : nil));
	
	if(!retObj)
	{
		NSString* retObjVersion = nil;
		for(NSString* key in [LaunchScreens allKeys])
		{
			NSDictionary* dict = [LaunchScreens objectForKey:key];
			
			// Checks the orientation and skips to the next if not satisfied.
			NSString* orientationString = [dict objectForKey:OrientationKey];
			if([orientationString isEqualToString:@"Portrait"])
			{
				if(isLandscape)
					continue;
			}
			else if([orientationString isEqualToString:@"Landscape"])
			{
				if(isPortrait)
					continue;
			}
			else
				continue;
			
			// Checks the size and skips to the next if not satisfied.
			NSString* sizeString = [dict objectForKey:SizeKey];
			CGSize size = CGSizeFromString(sizeString);
			if(!CGSizeEqualToSize(size, screenSize))
				continue;
			
			// Checks the minimum iOS version and skips to the next if not satisfied.
			NSString* minVersion = [dict objectForKey:MinimumOSVersionKey];
			if(minVersion)
			{
				if(!iOSPlus(minVersion))
					continue;
				
				// Checks if the current image minVersion is better than the last used image version.
				if(retObjVersion && [minVersion compare:retObjVersion options:NSNumericSearch] != NSOrderedDescending)
					continue;
			}
			else if(retObjVersion)
				continue;
			
			if(isLandscape)	landscapeRetObj = key;
			if(isPortrait)	portraitRetObj = key;
			
			retObj = key;
			retObjVersion = minVersion;
			
			if(iOS(minVersion))
				break;
		}
	}
	
	return retObj;
}

#endif


#pragma mark Functions (Math)

JFDegrees JFDegreesFromRadians(JFRadians radians)
{
	return radians * 180.0 / M_PI;
}

JFRadians JFRadiansFromDegrees(JFDegrees degrees)
{
	return degrees * M_PI / 180.0;
}


#pragma mark Functions (Resources)

NSURL* JFBundleResourceURLForFile(NSBundle* bundle, NSString* filename)
{
	return JFBundleResourceURLForFileWithType(bundle, [filename stringByDeletingPathExtension], [filename pathExtension]);
}

NSURL* JFBundleResourceURLForFileWithType(NSBundle* bundle, NSString* filename, NSString* type)
{
	if(!bundle || JFStringIsNullOrEmpty(filename))
		return nil;
	
	return [bundle URLForResource:filename withExtension:type];
}


#pragma mark Functions (Runtime)

void JFPerformSelector(NSObject* target, SEL action)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL) = (void*)implementation;
	performMethod(target, action);
}

void JFPerformSelector1(NSObject* target, SEL action, id object)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id) = (void*)implementation;
	performMethod(target, action, object);
}

void JFPerformSelector2(NSObject* target, SEL action, id obj1, id obj2)
{
	IMP implementation = [target methodForSelector:action];
	void (*performMethod)(id, SEL, id, id) = (void*)implementation;
	performMethod(target, action, obj1, obj2);
}


#pragma mark Functions (Validation)

BOOL JFValidateConnectionState(JFConnectionState state)
{
	BOOL retVal = YES;
	switch(state)
	{
		case JFConnectionStateConnected:
		case JFConnectionStateConnecting:
		case JFConnectionStateDisconnected:
		case JFConnectionStateDisconnecting:
		case JFConnectionStateLost:
		case JFConnectionStateReady:
		case JFConnectionStateReconnecting:
		case JFConnectionStateUnknown:
			break;
			
		default:
		{
			retVal = NO;
			break;
		}
	}
	return retVal;
}


#pragma mark Functions (Version)

BOOL JFCheckSystemVersion(NSString* version, JFRelation relation)
{
	static NSInteger currentMajorVersion = 0;
	static NSInteger currentMinorVersion = 0;
	static NSInteger currentPatchVersion = 0;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)])
		{
			NSOperatingSystemVersion currentVersion = ProcessInfo.operatingSystemVersion;
			currentMajorVersion = currentVersion.majorVersion;
			currentMinorVersion = currentVersion.minorVersion;
			currentPatchVersion = currentVersion.patchVersion;
		}
		else
		{
#if TARGET_OS_IPHONE
			NSArray* versionComponents = [SystemVersion componentsSeparatedByString:@"."];
			NSUInteger count = [versionComponents count];
			if(count > 0) currentMajorVersion = [versionComponents[0] integerValue];
			if(count > 1) currentMinorVersion = [versionComponents[1] integerValue];
			if(count > 2) currentPatchVersion = [versionComponents[2] integerValue];
#else
			SInt32 majorVersion, minorVersion, patchVersion;
			Gestalt(gestaltSystemVersionMajor, &majorVersion);
			Gestalt(gestaltSystemVersionMinor, &minorVersion);
			Gestalt(gestaltSystemVersionBugFix, &patchVersion);
			currentMajorVersion = majorVersion;
			currentMinorVersion = minorVersion;
			currentPatchVersion = patchVersion;
#endif
		}
	});
	
	if(JFStringIsNullOrEmpty(version))
		return NO;
	
	NSArray* versionComponents = [version componentsSeparatedByString:@"."];
	NSUInteger count = [versionComponents count];
	
	NSInteger majorVersion = -1;
	NSInteger minorVersion = -1;
	NSInteger patchVersion = -1;
	
	if(count > 0)
	{
		NSInteger value = [versionComponents[0] integerValue];
		if(value >= 0)
			majorVersion = value;
	}
	
	if(majorVersion == -1)
		return NO;
	
	if(count > 1)
	{
		NSInteger value = [versionComponents[1] integerValue];
		if(value >= 0)
			minorVersion = value;
	}
	if(count > 2)
	{
		NSInteger value = [versionComponents[2] integerValue];
		if(value >= 0)
			patchVersion = value;
	}
	
	NSInteger comps1[3] = {majorVersion, minorVersion, patchVersion};
	NSInteger comps2[3] = {currentMajorVersion, currentMinorVersion, currentPatchVersion};
	
	NSComparisonResult result = NSOrderedSame;
	for(NSUInteger i = 0; i < 3; i++)
	{
		NSInteger comp1 = comps1[i];
		if(comp1 == -1)
			break;
		
		NSInteger comp2 = comps2[i];
		
		if(comp2 == comp1)		result = NSOrderedSame;
		else if(comp2 < comp1)	result = NSOrderedAscending;
		else if(comp2 > comp1)	result = NSOrderedDescending;
		
		if(result != NSOrderedSame)
			break;
	}
	
	BOOL ascending	= (result == NSOrderedAscending);
	BOOL descending	= (result == NSOrderedDescending);
	
	switch(relation)
	{
		case JFRelationLessThan:			return ascending;
		case JFRelationLessThanOrEqual:		return (ascending || !descending);
		case JFRelationEqual:				return (!ascending && !descending);
		case JFRelationGreaterThanOrEqual:	return (descending || !ascending);
		case JFRelationGreaterThan:			return descending;
		default:
			break;
	}
	
	return NO;
}

NSString* JFSystemVersion()
{
	static NSString* retObj = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)])
		{
			NSOperatingSystemVersion version = ProcessInfo.operatingSystemVersion;
			retObj = [NSString stringWithFormat:@"%@.%@.%@", JFStringFromNSInteger(version.majorVersion), JFStringFromNSInteger(version.minorVersion), JFStringFromNSInteger(version.patchVersion)];
		}
		else
		{
#if TARGET_OS_IPHONE
			retObj = SystemVersion;
#else
			SInt32 majorVersion, minorVersion, patchVersion;
			Gestalt(gestaltSystemVersionMajor, &majorVersion);
			Gestalt(gestaltSystemVersionMinor, &minorVersion);
			Gestalt(gestaltSystemVersionBugFix, &patchVersion);
			retObj = [NSString stringWithFormat:@"%@.%@.%@", JFStringFromSInt32(majorVersion), JFStringFromSInt32(minorVersion), JFStringFromSInt32(patchVersion)];
#endif
		}
	});
	return retObj;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

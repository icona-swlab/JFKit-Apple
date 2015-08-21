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

NSTimeInterval const	JFAnimationDuration	= 1.0 / 3.0;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

id JFApplicationInfoForKey(NSString* key)
{
	return [[MainBundle infoDictionary] objectForKey:key];
}

BOOL JFAreObjectsEqual(id obj1, id obj2)
{
	// If both are 'nil', they are equal.
	if(!obj1 && !obj2)
		return YES;
	
	// If anyone is still equal to 'nil', they can't be equal.
	if(!obj1 || !obj2)
		return NO;
	
	BOOL (^validateClass)(Class) = ^BOOL(Class class)
	{
		if(![obj1 isKindOfClass:class])	return NO;
		if(![obj2 isKindOfClass:class])	return NO;
		return YES;
	};
	
	if(validateClass([NSArray class]))		return [obj1 isEqualToArray:obj2];
	if(validateClass([NSData class]))		return [obj1 isEqualToData:obj2];
	if(validateClass([NSDate class]))		return [obj1 isEqualToDate:obj2];
	if(validateClass([NSDictionary class]))	return [obj1 isEqualToDictionary:obj2];
	if(validateClass([NSNumber class]))		return [obj1 isEqualToNumber:obj2];
	if(validateClass([NSSet class]))		return [obj1 isEqualToSet:obj2];
	if(validateClass([NSString class]))		return [obj1 isEqualToString:obj2];
	
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

NSString* JFGetLaunchImageName()
{
	return JFGetLaunchImageNameForOrientation(CurrentStatusBarOrientation);
}

NSString* JFGetLaunchImageNameForOrientation(UIInterfaceOrientation orientation)
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
			
			// Checks the orientation and jumps to the next if not satisfied.
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
			
			// Checks the size and jumps to the next if not satisfied.
			NSString* sizeString = [dict objectForKey:SizeKey];
			CGSize size = CGSizeFromString(sizeString);
			if(!CGSizeEqualToSize(size, screenSize))
				continue;
			
			// Checks the minimum iOS version and jumps to the next if not satisfied.
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

JFRadians JFRadiansFromDegress(JFDegrees degrees)
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


#pragma mark Functions (Version)

#if TARGET_OS_IPHONE

BOOL JFCheckSystemVersion(NSString* version, JFRelation relation)
{
	if(JFStringIsNullOrEmpty(version))
		return NO;
	
	NSArray* comps1 = [version componentsSeparatedByString:@"."];
	NSArray* comps2 = [SystemVersion componentsSeparatedByString:@"."];
	
	NSUInteger comps1Count = [comps1 count];
	NSUInteger comps2Count = [comps2 count];
	if((comps1Count == 0) || (comps1Count > comps2Count))
		return NO;
	
	NSComparisonResult result = NSOrderedSame;
	for(NSUInteger i = 0; i < comps1Count; i++)
	{
		NSString* comp1 = [comps1 objectAtIndex:i];
		NSString* comp2 = [comps2 objectAtIndex:i];
		
		result = [comp1 compare:comp2 options:NSNumericSearch];
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

#else

BOOL JFCheckSystemVersion(double version, JFRelation relation)
{
	double systemVersion = NSAppKitVersionNumber;
	switch(relation)
	{
		case JFRelationLessThan:			return (systemVersion < version);
		case JFRelationLessThanOrEqual:		return (systemVersion <= version);
		case JFRelationEqual:				return (systemVersion == version);
		case JFRelationGreaterThanOrEqual:	return (systemVersion >= version);
		case JFRelationGreaterThan:			return (systemVersion > version);
		default:
			break;
	}
	return NO;
}

#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

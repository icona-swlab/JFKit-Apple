//
//  JFScreenshotsObserver.m
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



#import "JFScreenshotsObserver.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "JFLogger.h"
#import "JFUtilities.h"



#pragma mark - Macros

#define JFScreenshotsObserverNotification(_name)	(JFReversedDomain @".screenshotsObserver.notification." _name)



#pragma mark - Constants

// Notifications
NSString* const	JFScreenshotsObserverListUpdatedNotification	= JFScreenshotsObserverNotification(@"listUpdated");

// Timers
static	NSTimeInterval	JFScreenshotsObserverPollingTimeout	= 1.0;



#pragma mark



@interface JFScreenshotsObserver () <PHPhotoLibraryChangeObserver>

#pragma mark Properties

// Data
@property (strong, nonatomic)	NSArray*					assets;			// Contains "ALAsset" objects up to iOS7 and "PHAsset" objects since iOS8.
@property (strong, nonatomic)	PHFetchResult<PHAsset*>*	fetchResult;	// Used since iOS8.

// Flags
@property (assign, readwrite, getter = isObserving)	BOOL	observing;

// Relationships
@property (strong, nonatomic, readonly)	ALAssetsLibrary*	assetsLibrary;	// Used up to iOS7.
@property (strong, nonatomic, readonly)	PHPhotoLibrary*		photoLibrary;	// Used since iOS8.

// Timers
@property (strong, nonatomic)	NSTimer*	pollingTimer;


#pragma mark Methods

// Data management
- (void)		fetchScreenshots;
- (NSArray*)	fetchValidAssetsFromCurrentFetchResult;				// Used since iOS8.
- (NSArray*)	fetchValidAssetsFromGroup:(ALAssetsGroup*)group;	// Used up to iOS7.
- (void)		requestScreenshotAtIndex:(NSUInteger)index asynchronously:(BOOL)async completion:(JFBlockWithObject)completion;
- (BOOL)		validateAsset:(ALAsset*)asset;						// Used up to iOS7.
- (BOOL)		validateScreenshotSize:(CGSize)size;

// Notifications management
- (void)	notifiedUserDidTakeScreenshot:(NSNotification*)notification;	// Used since iOS7.
- (void)	notifyListUpdated;

// Services management
- (void)	requestAuthorization:(JFBlockWithBOOL)completion;

// Timers management
- (void)	pollingTimerFired:(NSTimer*)timer;	// Used up to iOS6.
- (void)	resetPollingTimer;					// Used up to iOS6.
- (void)	setUpPollingTimer;					// Used up to iOS6.

@end



#pragma mark



@interface JFScreenshot ()

#pragma mark Properties

// Attributes
@property (strong, nonatomic, readwrite)	NSDate*				creationDate;
@property (assign, nonatomic, readwrite)	UIImageOrientation	orientation;
@property (assign, nonatomic, readwrite)	CGFloat				scale;
@property (assign, nonatomic, readwrite)	CGSize				size;
@property (strong, nonatomic, readwrite)	NSString*			UTI;

// Data
@property (strong, nonatomic, readwrite)	NSData*		data;
@property (strong, nonatomic, readwrite)	UIImage*	image;
@property (strong, nonatomic, readwrite)	NSString*	name;

@end



#pragma mark



@implementation JFScreenshotsObserver

#pragma mark Properties

// Data
@synthesize assets		= _assets;
@synthesize fetchResult	= _fetchResult;

// Flags
@synthesize observing	= _observing;

// Relationships
@synthesize assetsLibrary	= _assetsLibrary;
@synthesize photoLibrary	= _photoLibrary;

// Timers
@synthesize pollingTimer	= _pollingTimer;


#pragma mark Properties (Data)

- (void)setAssets:(NSArray*)assets
{
	if(JFAreObjectsEqual(_assets, assets))
		return;
	
	_assets = assets;
	
	[self notifyListUpdated];
}

- (void)setFetchResult:(PHFetchResult<PHAsset*>*)fetchResult
{
	if(JFAreObjectsEqual(_fetchResult, fetchResult))
		return;
	
	_fetchResult = fetchResult;
	
	self.assets = [self fetchValidAssetsFromCurrentFetchResult];
}

- (JFScreenshot*)newestScreenshot
{
	return [self screenshotAtIndex:self.screenshotsCount - 1];
}

- (JFScreenshot*)oldestScreenshot
{
	return [self screenshotAtIndex:0];
}

- (NSUInteger)screenshotsCount
{
	return [self.assets count];
}


#pragma mark Properties (Flags)

- (JFPhotosAuthorizationStatus)authorizationStatus
{
	JFPhotosAuthorizationStatus retVal = JFPhotosAuthorizationStatusNotDetermined;
	if(iOS8Plus)
	{
		switch([PHPhotoLibrary authorizationStatus])
		{
			case PHAuthorizationStatusAuthorized:		retVal = JFPhotosAuthorizationStatusAuthorized;		break;
			case PHAuthorizationStatusDenied:			retVal = JFPhotosAuthorizationStatusDenied;			break;
			case PHAuthorizationStatusRestricted:		retVal = JFPhotosAuthorizationStatusRestricted;		break;
			default:									retVal = JFPhotosAuthorizationStatusNotDetermined;	break;
		}
	}
	else
	{
		switch([ALAssetsLibrary authorizationStatus])
		{
			case ALAuthorizationStatusAuthorized:		retVal = JFPhotosAuthorizationStatusAuthorized;		break;
			case ALAuthorizationStatusDenied:			retVal = JFPhotosAuthorizationStatusDenied;			break;
			case ALAuthorizationStatusRestricted:		retVal = JFPhotosAuthorizationStatusRestricted;		break;
			default:									retVal = JFPhotosAuthorizationStatusNotDetermined;	break;
		}
	}
	return retVal;
}


#pragma mark Memory management

- (void)dealloc
{
	[self stopObserving];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		if(iOS8Plus)
		{
			// Relationships
			_photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
		}
		else
		{
			// Relationships
			_assetsLibrary = [ALAssetsLibrary new];
		}
	}
	return self;
}


#pragma mark Data management

- (void)fetchScreenshots
{
	if(self.authorizationStatus != JFPhotosAuthorizationStatusAuthorized)
		return;
	
	if(iOS8Plus)
	{
		UIScreen* screen = MainScreen;
		CGFloat scale = screen.scale;
		
		CGSize size = screen.bounds.size;
		size.width *= scale;
		size.height *= scale;
		
		NSString* formatString = @"(mediaType == %@) && (pixelWidth == %@) && (pixelHeight == %@)";
		NSArray* args = @[JFStringFromNSInteger(PHAssetMediaTypeImage), JFStringFromNSUInteger(size.width), JFStringFromNSUInteger(size.height)];
		
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
		
		PHFetchOptions* fetchOptions = [PHFetchOptions new];
		fetchOptions.predicate = [NSPredicate predicateWithFormat:formatString argumentArray:args];
		fetchOptions.sortDescriptors = @[sortDescriptor];
		
		self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
	}
	else
	{
		NSMutableArray* assets = [NSMutableArray array];
		
		ALAssetsLibraryGroupsEnumerationResultsBlock successBlock = ^(ALAssetsGroup* group, BOOL* stop)
		{
			NSArray* groupAssets = [self fetchValidAssetsFromGroup:group];
			if(groupAssets)
				[assets addObjectsFromArray:groupAssets];
			
			if(!group)
				self.assets = [assets copy];
		};
		
		[self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:successBlock failureBlock:nil];
	}
}

- (NSArray*)fetchValidAssetsFromCurrentFetchResult
{
	PHFetchResult<PHAsset*>* fetchResult = self.fetchResult;
	if(!fetchResult)
		return nil;
	
	NSMutableArray* retObj = [NSMutableArray arrayWithCapacity:[fetchResult count]];
	
	BOOL shouldCheckSubtype = iOS9Plus;
	
	for(PHAsset* asset in fetchResult)
	{
		if(shouldCheckSubtype && !(asset.mediaSubtypes & PHAssetMediaSubtypePhotoScreenshot))
			continue;
		
		// If the next check fails, probably the screenshot has been trashed.
		if(![asset canPerformEditOperation:PHAssetEditOperationContent])
			continue;
		
		[retObj addObject:asset];
	}
	
	return [retObj copy];
}

- (NSArray*)fetchValidAssetsFromGroup:(ALAssetsGroup*)group
{
	if(!group)
		return nil;
	
	[group setAssetsFilter:[ALAssetsFilter allPhotos]];
	
	NSMutableArray* retObj = [NSMutableArray array];
	
	ALAssetsGroupEnumerationResultsBlock block = ^(ALAsset* asset, NSUInteger index, BOOL* stop)
	{
		if([self validateAsset:asset])
			[retObj addObject:asset];
	};
	
	[group enumerateAssetsUsingBlock:block];
	
	return [retObj copy];
}

- (void)requestScreenshotAtIndex:(NSUInteger)index asynchronously:(BOOL)async completion:(JFBlockWithObject)completion
{
	if(!completion)
		return;
	
	JFBlockWithObject innerCompletion = ^(JFScreenshot* screenshot)
	{
		if(async)
		{
			[MainOperationQueue addOperationWithBlock:^{
				completion(screenshot);
			}];
		}
		else
			completion(screenshot);
	};
	
	NSArray* assets = self.assets;
	NSUInteger count = [assets count];
	if((count == 0) || (index > (count - 1)))
	{
		innerCompletion(nil);
		return;
	}
	
	CGFloat scale = MainScreen.scale;
	
	if(iOS8Plus)
	{
		PHAsset* asset = [assets objectAtIndex:index];
		
		PHImageManager* manager = [PHImageManager defaultManager];
		
		PHImageRequestOptions* options = [PHImageRequestOptions new];
		options.synchronous = !async;
		
		[manager requestImageDataForAsset:asset options:options resultHandler:^(NSData* imageData, NSString* dataUTI, UIImageOrientation orientation, NSDictionary* info) {
			
			NSString* name = (iOS9Plus ? [[PHAssetResource assetResourcesForAsset:asset] firstObject].originalFilename : [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent]);
			
			CGSize size = CGSizeMake(((CGFloat)asset.pixelWidth / scale), ((CGFloat)asset.pixelHeight / scale));
			
			JFScreenshot* screenshot = [[JFScreenshot alloc] init];
			
			// Attributes
			screenshot.creationDate	= asset.creationDate;
			screenshot.orientation	= orientation;
			screenshot.scale		= scale;
			screenshot.size			= size;
			screenshot.UTI			= dataUTI;
			
			// Data
			screenshot.data		= imageData;
			screenshot.image	= [UIImage imageWithData:imageData scale:scale];
			screenshot.name		= name;
			
			innerCompletion(screenshot);
		}];
	}
	else
	{
		ALAsset* asset = [assets objectAtIndex:index];
		
		ALAssetRepresentation* representation = [asset defaultRepresentation];
		if(!representation)
		{
			innerCompletion(nil);
			return;
		}
		
		UIImageOrientation orientation = UIImageOrientationUp;
		switch(representation.orientation)
		{
			case ALAssetOrientationDown:			orientation = UIImageOrientationDown;			break;
			case ALAssetOrientationDownMirrored:	orientation = UIImageOrientationDownMirrored;	break;
			case ALAssetOrientationLeft:			orientation = UIImageOrientationLeft;			break;
			case ALAssetOrientationLeftMirrored:	orientation = UIImageOrientationLeftMirrored;	break;
			case ALAssetOrientationRight:			orientation = UIImageOrientationRight;			break;
			case ALAssetOrientationRightMirrored:	orientation = UIImageOrientationRightMirrored;	break;
			case ALAssetOrientationUp:				orientation = UIImageOrientationUp;				break;
			case ALAssetOrientationUpMirrored:		orientation = UIImageOrientationUpMirrored;		break;
			default:
				break;
		}
		
		NSError* error = nil;
		NSUInteger length = (NSUInteger)representation.size;
		Byte* bytes = (Byte*)malloc(sizeof(Byte) * length);
		length = [representation getBytes:bytes fromOffset:0 length:length error:&error];
		if(error)
		{
			NSString* message = [NSString stringWithFormat:@"Failed to get screenshot data for error '%@'.", error];
			[self.logger logMessage:message level:JFLogLevel3Error hashtags:JFLogHashtagError];
		}
		NSData* imageData = ((length > 0) ? [NSData dataWithBytesNoCopy:bytes length:length freeWhenDone:YES] : nil);
		
		NSDate* creationDate = [asset valueForProperty:ALAssetPropertyDate];
		
		JFScreenshot* screenshot = [[JFScreenshot alloc] init];
		
		// Attributes
		screenshot.creationDate	= creationDate;
		screenshot.orientation	= orientation;
		screenshot.scale		= representation.scale;
		screenshot.size			= representation.dimensions;
		screenshot.UTI			= representation.UTI;
		
		// Data
		screenshot.data		= imageData;
		screenshot.image	= [UIImage imageWithData:imageData scale:scale];
		screenshot.name		= representation.filename;
		
		innerCompletion(screenshot);
	}
}

- (void)requestScreenshotAtIndex:(NSUInteger)index completion:(JFBlockWithObject)completion
{
	[self requestScreenshotAtIndex:index asynchronously:YES completion:completion];
}

- (JFScreenshot*)screenshotAtIndex:(NSUInteger)index
{
	__block JFScreenshot* retObj = nil;
	
	[self requestScreenshotAtIndex:index asynchronously:NO completion:^(JFScreenshot* screenshot) {
		retObj = screenshot;
	}];
	
	return retObj;
}

- (BOOL)validateAsset:(ALAsset*)asset
{
	if(!asset)
		return NO;
	
	ALAssetRepresentation* representation = [asset defaultRepresentation];
	if(!representation)
		return NO;
	
	return [self validateScreenshotSize:representation.dimensions];
}

- (BOOL)validateScreenshotSize:(CGSize)size
{
	CGSize screenSize = MainScreen.bounds.size;
	CGFloat scale = MainScreen.scale;
	
	screenSize.height *= scale;
	screenSize.width *= scale;
	
	return CGSizeEqualToSize(size, screenSize);
}


#pragma mark Notifications management

- (void)notifiedUserDidTakeScreenshot:(NSNotification*)notification
{
	[self fetchScreenshots];
}

- (void)notifyListUpdated
{
	[MainNotificationCenter postNotificationName:JFScreenshotsObserverListUpdatedNotification object:self];
}


#pragma mark Services management

- (void)requestAuthorization:(JFBlockWithBOOL)completion
{
	JFBlockWithBOOL performCompletion = ^(BOOL authorized)
	{
		if(!completion)
			return;
		
		[MainOperationQueue addOperationWithBlock:^{
			completion(authorized);
		}];
	};
	
	switch(self.authorizationStatus)
	{
		case JFPhotosAuthorizationStatusAuthorized:
		{
			performCompletion(YES);
			break;
		}
		case JFPhotosAuthorizationStatusDenied:
		case JFPhotosAuthorizationStatusRestricted:
		{
			performCompletion(NO);
			break;
		}
		case JFPhotosAuthorizationStatusNotDetermined:
		{
			if(iOS8Plus)
			{
				[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
					[self requestAuthorization:completion];
				}];
			}
			else
			{
				ALAssetsLibraryGroupsEnumerationResultsBlock successBlock = ^(ALAssetsGroup* group, BOOL* stop)
				{
					[self requestAuthorization:completion];
					*stop = YES;
				};
				
				ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error)
				{
					[self requestAuthorization:completion];
				};
				
				ALAssetsLibrary* library = [ALAssetsLibrary new];
				[library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:successBlock failureBlock:failureBlock];
			}
			break;
		}
		default:
			break;
	}
}

- (void)startObserving
{
	@synchronized(self)
	{
		if([self isObserving])
			return;
		
		self.observing = YES;
	}
	
	if(iOS8Plus)
		[self.photoLibrary registerChangeObserver:self];
	
	if(iOS7Plus)
		[MainNotificationCenter addObserver:self selector:@selector(notifiedUserDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
	else
		[self setUpPollingTimer];
	
	[self requestAuthorization:^(BOOL authorized) {
		if(authorized)
			[self fetchScreenshots];
		else
			[self stopObserving];
	}];
}

- (void)stopObserving
{
	@synchronized(self)
	{
		if(![self isObserving])
			return;
		
		self.observing = NO;
	}
	
	if(iOS8Plus)
		[self.photoLibrary unregisterChangeObserver:self];
	
	if(iOS7Plus)
		[MainNotificationCenter removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
	else
		[self resetPollingTimer];
}


#pragma mark Timers management

- (void)pollingTimerFired:(NSTimer*)timer
{
	[self fetchScreenshots];
}

- (void)resetPollingTimer
{
	NSTimer* timer = self.pollingTimer;
	if(!timer)
		return;
	
	if([timer isValid])
		[timer invalidate];
	
	self.pollingTimer = nil;
}

- (void)setUpPollingTimer
{
	if(self.pollingTimer)
		[self resetPollingTimer];
	
	self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:JFScreenshotsObserverPollingTimeout target:self selector:@selector(pollingTimerFired:) userInfo:nil repeats:YES];
}


#pragma mark Protocol implementation (PHPhotoLibraryChangeObserver)

- (void)photoLibraryDidChange:(PHChange*)changeInstance
{
	JFBlock block = ^(void)
	{
		PHFetchResult* fetchResult = self.fetchResult;
		if(!fetchResult)
			return;
		
		PHFetchResultChangeDetails* changeDetails = [changeInstance changeDetailsForFetchResult:fetchResult];
		if(changeDetails)
			self.fetchResult = [changeDetails fetchResultAfterChanges];
	};
	
	[MainOperationQueue addOperationWithBlock:block];
}

@end



#pragma mark



@implementation JFScreenshot

#pragma mark Properties

// Attributes
@synthesize creationDate	= _creationDate;
@synthesize orientation		= _orientation;
@synthesize scale			= _scale;
@synthesize size			= _size;
@synthesize UTI				= _UTI;

// Data
@synthesize data	= _data;
@synthesize image	= _image;
@synthesize name	= _name;

@end

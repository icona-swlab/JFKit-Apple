//
//  JFGalleryView.h
//
//  Created by Jacopo Filié on 16/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import <UIKit/UIKit.h>



@class JFGalleryView;



@protocol  JFGalleryViewDataSource

@required

// Data
- (UIImage*)	galleryView:(JFGalleryView*)galleryView imageForItemAtIndex:(NSUInteger)index;
- (NSUInteger)	numberOfItemsInGalleryView:(JFGalleryView*)galleryView;

@end



@protocol  JFGalleryViewDelegate

@optional

// User interface
- (UIEdgeInsets)	edgeInsetsForGalleryView:(JFGalleryView*)galleryView;

@end



@interface JFGalleryView : UIView

// Listeners
@property (weak, nonatomic)	IBOutlet	NSObject<JFGalleryViewDataSource>*	dataSource;

// Gallery view management
- (void)	reloadData;

@end

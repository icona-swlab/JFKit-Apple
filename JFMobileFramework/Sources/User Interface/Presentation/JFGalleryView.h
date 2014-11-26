//
//  JFGalleryView.h
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



@class JFGalleryView;



@protocol JFGalleryViewDataSource <NSObject>

@required

- (UIView*)		galleryView:(JFGalleryView*)galleryView viewAtIndex:(NSInteger)index;
- (NSUInteger)	numberOfViewsInGalleryView:(JFGalleryView*)galleryView;

@end



@protocol JFGalleryViewDelegate <NSObject>

@optional

// This method is called during the purge action.
- (void)	galleryView:(JFGalleryView*)galleryView didReleaseViewAtIndex:(NSInteger)index;

// These methods are called when the gallery view is scrolled by code.
- (void)	galleryView:(JFGalleryView*)galleryView didHideViewAtIndex:(NSInteger)index;
- (void)	galleryView:(JFGalleryView*)galleryView didShowViewAtIndex:(NSInteger)index;
- (void)	galleryView:(JFGalleryView*)galleryView willHideViewAtIndex:(NSInteger)index;
- (void)	galleryView:(JFGalleryView*)galleryView willShowViewAtIndex:(NSInteger)index;

// These methods are called when the gallery view is scrolled by dragging.
- (void)	galleryView:(JFGalleryView*)galleryView didScrollToViewAtIndex:(NSInteger)index;
- (void)	galleryView:(JFGalleryView*)galleryView isScrollingThroughViewAtIndex:(NSInteger)index;
- (void)	galleryView:(JFGalleryView*)galleryView willScrollFromViewAtIndex:(NSInteger)index;

@end



@interface JFGalleryView : UIView <UIScrollViewDelegate>

// Attributes
@property (assign, nonatomic, readonly)	NSInteger	currentIndex;
@property (assign, nonatomic)			CGFloat		pageControlDistanceFromBottom;
@property (assign, nonatomic)			CGFloat		pageControlHeight;
@property (assign, nonatomic)			BOOL		pageControlHidden;
@property (assign, nonatomic)			BOOL		pageControlHidesForSinglePage;
@property (assign, nonatomic)			BOOL		userScrollingEnabled;

// Relationships
@property (weak, nonatomic)	IBOutlet	id<JFGalleryViewDataSource>	dataSource;
@property (weak, nonatomic)	IBOutlet	id<JFGalleryViewDelegate>	delegate;

// Memory management
- (void)	commonInit;
- (void)	releaseUnusedViews;

// User interface management
- (void)	scrollToViewAtIndex:(NSInteger)index animated:(BOOL)animated;

// Data management
- (void)	reloadData;

@end

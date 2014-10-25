//
//  JFGalleryView.h
//  Copyright (C) 2013  Jacopo Filié
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

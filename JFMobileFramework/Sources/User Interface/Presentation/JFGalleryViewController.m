//
//  JFGalleryViewController.m
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



#import "JFGalleryViewController.h"



@interface JFGalleryViewController ()

@end



@implementation JFGalleryViewController

#pragma mark - Properties

// Layout
@synthesize	galleryView	= _galleryView;


#pragma mark - Properties accessors

// Layout

- (JFGalleryView*)galleryView
{
	if(!_galleryView)
	{
		_galleryView = [[JFGalleryView alloc] init];
		_galleryView.dataSource = self;
	}
	
	return _galleryView;
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	[self.galleryView releaseUnusedViews];
	[super didReceiveMemoryWarning];
}


#pragma mark - View delegate

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.galleryView.frame = self.view.bounds;
	[self.view addSubview:self.galleryView];
}

- (void)viewDidUnload
{
	// Layout
	self.galleryView = nil;
	
	[super viewDidUnload];
}


#pragma mark - Gallery view data source

- (UIView*)galleryView:(JFGalleryView*)galleryView viewAtIndex:(NSInteger)index
{
	return nil;
}

- (NSUInteger)numberOfViewsInGalleryViewController:(JFGalleryView*)galleryView
{
	return 0;
}

@end

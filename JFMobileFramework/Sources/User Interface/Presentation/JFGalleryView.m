//
//  JFGalleryView.m
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



#import "JFGalleryView.h"



@interface JFGalleryView ()

// Attributes
@property (assign, nonatomic)	NSInteger	previousIndex;
@property (assign, nonatomic)	BOOL		shouldPerformScrollViewDelegateMethods;

// Paging
@property (retain, nonatomic, readonly)	NSMutableArray*	galleryViews;
@property (retain, nonatomic, readonly)	UIPageControl*	pageControl;
@property (retain, nonatomic, readonly)	UIScrollView*	scrollView;

// View actions
- (void)	pageControlClicked;

// View management
- (CGRect)	frameForPageAtIndex:(NSInteger)index;
- (void)	resizeScrollViewContent;
- (void)	setupPageControl;
- (void)	setupScrollView;
- (void)	setupView;

// Data management
- (void)	loadViewAtIndex:(NSInteger)index;
- (void)	reset;

@end



#ifdef DEBUG
static BOOL debugMode = NO;
#else
static BOOL debugMode = NO;
#endif



@implementation JFGalleryView

#pragma mark - Properties

// Attributes
@synthesize	currentIndex							= _currentIndex;
@synthesize	pageControlDistanceFromBottom			= _pageControlDistanceFromBottom;
@synthesize	pageControlHeight						= _pageControlHeight;
@synthesize	pageControlHidden						= _pageControlHidden;
@synthesize	pageControlHidesForSinglePage			= _pageControlHidesForSinglePage;
@synthesize	previousIndex							= _previousIndex;
@synthesize	shouldPerformScrollViewDelegateMethods	= _shouldPerformScrollViewDelegateMethods;
@synthesize	userScrollingEnabled					= _userScrollingEnabled;

// Gallery
@synthesize	galleryViews	= _galleryViews;
@synthesize	pageControl		= _pageControl;
@synthesize	scrollView		= _scrollView;

// Targets
@synthesize	dataSource	= _dataSource;
@synthesize	delegate	= _delegate;


#pragma mark - Properties accessors

// Attributes

- (NSInteger)currentIndex
{
	return self.pageControl.currentPage;
}

- (void)setPageControlDistanceFromBottom:(CGFloat)pageControlDistanceFromBottom
{
	if(_pageControlDistanceFromBottom == pageControlDistanceFromBottom)
		return;
	
	_pageControlDistanceFromBottom = pageControlDistanceFromBottom;
	
	[self setupPageControl];
}

- (void)setPageControlHeight:(CGFloat)pageControlHeight
{
	if(_pageControlHeight == pageControlHeight)
		return;
	
	_pageControlHeight = pageControlHeight;
	
	[self setupPageControl];
}

- (void)setPageControlHidden:(BOOL)pageControlHidden
{
	if(_pageControlHidden == pageControlHidden)
		return;
	
	_pageControlHidden = pageControlHidden;
	
	[self setupPageControl];
}

- (void)setPageControlHidesForSinglePage:(BOOL)pageControlHidesForSinglePage
{
	if(_pageControlHidesForSinglePage == pageControlHidesForSinglePage)
		return;
	
	_pageControlHidesForSinglePage = pageControlHidesForSinglePage;
	
	[self setupPageControl];
}

- (void)setUserScrollingEnabled:(BOOL)userScrollingEnabled
{
	if(_userScrollingEnabled == userScrollingEnabled)
		return;
	
	_userScrollingEnabled = userScrollingEnabled;
	
	[self setupScrollView];
}

// Targets

- (void)setDataSource:(id<JFGalleryViewDataSource>)dataSource
{
	if(_dataSource == dataSource)
		return;
	
	_dataSource = dataSource;
	
	[self reloadData];
}


#pragma mark - Memory management

- (void)releaseUnusedViews
{
	// Releases all unused stored views of the gallery.
	NSInteger index = self.pageControl.currentPage;
	for(NSInteger i = 0; i < [self.galleryViews count]; i++)
	{
		if((i >= (index - 1)) && (i <= (index + 1)))
			continue;
		
		UIView* view = [self.galleryViews objectAtIndex:i];
		if((NSNull*)view != [NSNull null])
		{
			[view removeFromSuperview];
			[self.galleryViews replaceObjectAtIndex:i withObject:[NSNull null]];
			if(debugMode) NSLog(@"GALLERY VIEW: Released view at index %@.", NSIntegerToString(i));
		}
	}
}

- (id)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_pageControlDistanceFromBottom = 0.0f;
		_pageControlHeight = 36.0f;
		_pageControlHidesForSinglePage = YES;
		_previousIndex = NSNotFound;
		_shouldPerformScrollViewDelegateMethods = YES;
		_userScrollingEnabled = YES;
		
		// Paging
		_pageControl = [[UIPageControl alloc] init];
		_scrollView = [[UIScrollView alloc] init];
		_galleryViews = [[NSMutableArray alloc] init];
		
		// Super properties
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		[self setupView];
	}
	return self;
}


#pragma mark - View actions

- (void)pageControlClicked
{
	self.shouldPerformScrollViewDelegateMethods = NO;
	
    NSInteger index = self.currentIndex;
	
	// Loads the adjacent views.
	[self loadViewAtIndex:index - 1];
	[self loadViewAtIndex:index];
	[self loadViewAtIndex:index + 1];
	
	// Scrolls to the selected index.
	[self scrollToViewAtIndex:index animated:YES];
}


#pragma mark - View management

- (CGRect)frameForPageAtIndex:(NSInteger)index
{
	CGRect retVal = self.bounds;
	retVal.origin.x = self.bounds.size.width * index;
	return retVal;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self resizeScrollViewContent];
}

- (void)resizeScrollViewContent
{
	if(self.pageControl.numberOfPages == 0)
		self.scrollView.contentSize = self.scrollView.bounds.size;
	else
		self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * self.pageControl.numberOfPages, self.scrollView.bounds.size.height);
	
	// Prepares the views array with placeholders.
	for(NSUInteger i = 0; i < self.pageControl.numberOfPages; i++)
	{
		UIView* view = [self.galleryViews objectAtIndex:i];
		if((NSNull*)view != [NSNull null])
			view.frame = [self frameForPageAtIndex:i];
	}
}

- (void)scrollToViewAtIndex:(NSInteger)index animated:(BOOL)animated
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:willHideViewAtIndex:)])
		[self.delegate galleryView:self willHideViewAtIndex:self.previousIndex];
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:willShowViewAtIndex:)])
		[self.delegate galleryView:self willShowViewAtIndex:index];
	
	[self.scrollView scrollRectToVisible:[self frameForPageAtIndex:index] animated:animated];
	
	if(!animated)
		[self scrollViewDidEndScrollingAnimation:self.scrollView];
}

- (void)setupPageControl
{
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	self.pageControl.hidesForSinglePage = (self.pageControlHidden ? NO : self.pageControlHidesForSinglePage); // Must be set to NO or it will show the page control in any case when there are more than one page.
	self.pageControl.hidden = self.pageControlHidden; // Must be set after the 'hidesForSinglePage' property or it will be ignored.
	
	CGRect frame = self.pageControl.frame;
	frame.origin = CGPointMake(0.0f, self.bounds.size.height - self.pageControlHeight - self.pageControlDistanceFromBottom);
	frame.size = CGSizeMake(self.bounds.size.width, self.pageControlHeight);
	self.pageControl.frame = frame;
}

- (void)setupScrollView
{
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.scrollView.delegate = self;
	self.scrollView.frame = self.bounds;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.scrollEnabled = self.userScrollingEnabled;
	self.scrollView.scrollsToTop = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)setupView
{
	[self.pageControl addTarget:self action:@selector(pageControlClicked) forControlEvents:UIControlEventTouchUpInside];
	
	self.clipsToBounds = YES;
	
	[self setupPageControl];
	[self setupScrollView];
	
	[self addSubview:self.scrollView];
	[self addSubview:self.pageControl];
}


#pragma mark - Data management

- (void)loadViewAtIndex:(NSInteger)index
{
	if((index < 0) || (index >= self.pageControl.numberOfPages))
		return;
	
	// Tests if the view has been loaded already and loads it if not.
	UIView* view = [self.galleryViews objectAtIndex:index];
	if((NSNull*)view == [NSNull null])
	{
		view = ([self.dataSource respondsToSelector:@selector(galleryView:viewAtIndex:)] ? [self.dataSource galleryView:self viewAtIndex:index] : nil);
		if(!view)
		{
			view = [[UIView alloc] init];
			float red = (arc4random() % 255) / 255.0f;
			float green = (arc4random() % 255) / 255.0f;
			float blue = (arc4random() % 255) / 255.0f;
			view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
		}
		[self.galleryViews replaceObjectAtIndex:index withObject:view];
		if(debugMode) NSLog(@"GALLERY VIEW: Loaded view at index %@.", NSIntegerToString(index));
	}
	
	if(view)
	{
		view.frame = [self frameForPageAtIndex:index];
		[self.scrollView addSubview:view];
	}
}

- (void)reloadData
{
	[self reset];
	
	if(!self.dataSource)
		return;
	
	self.pageControl.numberOfPages = [self.dataSource numberOfViewsInGalleryViewController:self];
	if(self.pageControl.numberOfPages == 0)
		return;
	
	// Prepares the views array with placeholders.
	for(NSUInteger i = 0; i < self.pageControl.numberOfPages; i++)
		[self.galleryViews addObject:[NSNull null]];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:willShowViewAtIndex:)])
		[self.delegate galleryView:self willShowViewAtIndex:0];
	
	[self loadViewAtIndex:0];
	if(self.pageControl.numberOfPages > 1)
		[self loadViewAtIndex:1];
	
	self.pageControl.currentPage = 0;
	self.previousIndex = 0;
	
	[self resizeScrollViewContent];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:didShowViewAtIndex:)])
		[self.delegate galleryView:self didShowViewAtIndex:0];
}

- (void)reset
{
	self.pageControl.currentPage = NSNotFound; // It must be set to a value different from '0' or else it will not show the starting white dot when the gallery reloads the data.
	self.pageControl.numberOfPages = 0;
	self.previousIndex = NSNotFound;
	self.scrollView.contentOffset = CGPointZero;
	self.scrollView.contentSize = self.scrollView.bounds.size;
	[self.galleryViews removeAllObjects];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:didScrollToViewAtIndex:)])
		[self.delegate galleryView:self didScrollToViewAtIndex:self.currentIndex];
	
	self.previousIndex = self.currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
	if(!self.shouldPerformScrollViewDelegateMethods)
		return;
	
	// Updates the page control current page.
	CGFloat width = self.scrollView.frame.size.width;
	NSInteger index = floor((self.scrollView.contentOffset.x - (width / 2)) / width) + 1;
	self.pageControl.currentPage = index;
	
	// Loads the adjacent views.
	[self loadViewAtIndex:index - 1];
	[self loadViewAtIndex:index];
	[self loadViewAtIndex:index + 1];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:isScrollingThroughViewAtIndex:)])
		[self.delegate galleryView:self isScrollingThroughViewAtIndex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	self.shouldPerformScrollViewDelegateMethods = YES;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:willScrollFromViewAtIndex:)])
		[self.delegate galleryView:self willScrollFromViewAtIndex:self.currentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView
{
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:didHideViewAtIndex:)])
		[self.delegate galleryView:self didHideViewAtIndex:self.previousIndex];
	if(self.delegate && [self.delegate respondsToSelector:@selector(galleryView:didShowViewAtIndex:)])
		[self.delegate galleryView:self didShowViewAtIndex:self.currentIndex];
	
	self.previousIndex = self.currentIndex;
}

@end

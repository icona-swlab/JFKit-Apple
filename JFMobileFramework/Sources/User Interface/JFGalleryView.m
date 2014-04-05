//
//  JFGalleryView.m
//
//  Created by Jacopo Filié on 16/11/13.
//  Copyright (c) 2013 Jacopo Filié. All rights reserved.
//



#import "JFGalleryView.h"



@interface JFGalleryView () <UIScrollViewDelegate>

// Gallery view
@property (assign, nonatomic)	NSUInteger	numberOfItems;

// User interface
@property (assign, nonatomic)			UIEdgeInsets	edgeInsets;
@property (assign, nonatomic)			CGFloat			itemSpacing;
@property (assign, nonatomic)			CGFloat			itemWidth;
@property (strong, nonatomic, readonly)	UIScrollView*	scrollView;

// Memory management
- (void)	commonInit;

// User interface management
- (void)	setupScrollView;

@end



@implementation JFGalleryView

#pragma mark - Properties

// Gallery view
@synthesize numberOfItems	= _numberOfItems;

// Listeners
@synthesize dataSource	= _dataSource;

// User interface
@synthesize edgeInsets	= _edgeInsets;
@synthesize itemSpacing	= _itemSpacing;
@synthesize itemWidth	= _itemWidth;
@synthesize scrollView	= _scrollView;


#pragma mark - Memory management

- (void)commonInit
{
	// User interface
	_edgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
	_itemSpacing = 5.0f;
	_itemWidth = 100.0f;
	_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	_scrollView.delegate = self;
	
	// Setups the view.
	[self setupScrollView];
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self commonInit];
	}
	return self;
}


#pragma mark - User interface management

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	// Loads the scroll view data.
	[self reloadData];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize size = self.scrollView.bounds.size;
	
	CGFloat horizontalEdges = self.edgeInsets.left + self.edgeInsets.right;
	CGFloat verticalEdges = self.edgeInsets.top + self.edgeInsets.bottom;
	
	NSUInteger numberOfItemsPerPage = floorf((size.width - horizontalEdges + self.itemSpacing) / (self.itemSpacing + self.itemWidth));
	NSUInteger numberOfPages = ceilf((float)self.numberOfItems / numberOfItemsPerPage);
	
	size.width *= numberOfPages;
	self.scrollView.contentSize = size;
	
	CGRect itemFrame = CGRectMake(0.0f, self.edgeInsets.top, self.itemWidth, (size.height - verticalEdges));
	
	for(NSUInteger index = 0; index < self.numberOfItems; index++)
	{
		UIImage* image = [self.dataSource galleryView:self imageForItemAtIndex:index];
		
		NSUInteger currentPage = floorf((float)index / numberOfItemsPerPage);
		NSUInteger indexInPage = index % numberOfItemsPerPage;
		
		CGFloat pageOriginX = currentPage * self.scrollView.bounds.size.width;
		CGFloat itemOffset = self.edgeInsets.left + (self.itemSpacing + self.itemWidth) * indexInPage;
		
		itemFrame.origin.x = pageOriginX + itemOffset;
		
		UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = itemFrame;
		[self.scrollView addSubview:imageView];
	}
}

- (void)setupScrollView
{
	UIScrollView* scrollView = self.scrollView;
	
	scrollView.alwaysBounceHorizontal = YES;
	scrollView.alwaysBounceVertical = NO;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	scrollView.backgroundColor = nil;
	scrollView.bounces = YES;
	scrollView.canCancelContentTouches = NO;
	scrollView.clipsToBounds = YES;
	scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	scrollView.delaysContentTouches = NO;
	scrollView.directionalLockEnabled = NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	scrollView.opaque = NO;
	scrollView.pagingEnabled = YES;
	scrollView.scrollEnabled = YES;
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = YES;
	scrollView.showsVerticalScrollIndicator = NO;
	
	[self addSubview:self.scrollView];
}


#pragma mark - Gallery view management

- (void)reloadData
{
	self.numberOfItems = [self.dataSource numberOfItemsInGalleryView:self];
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end

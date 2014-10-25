//
//  JFSlideViewController.h
//
//  Created by Jacopo Filié on 05/10/12.
//  Copyright (c) 2012 Icona s.r.l. All rights reserved.
//



@class JFSlideViewController;



@protocol JFSlideViewDelegate <NSObject>

@optional

- (BOOL)	slideViewController:(JFSlideViewController*)slideViewController shouldShowRootViewController:(UIViewController*)viewController;

- (void)	slideViewController:(JFSlideViewController*)slideViewController didHideViewController:(UIViewController*)viewController;
- (void)	slideViewController:(JFSlideViewController*)slideViewController didShowViewController:(UIViewController*)viewController;

- (void)	slideViewController:(JFSlideViewController*)slideViewController willHideViewController:(UIViewController*)viewController;
- (void)	slideViewController:(JFSlideViewController*)slideViewController willShowViewController:(UIViewController*)viewController;

@end



@interface JFSlideViewController : UIViewController

// Attributes
@property (assign, nonatomic)	NSTimeInterval	fadeDuration;
@property (assign, nonatomic)	NSTimeInterval	slideDuration;
@property (assign, nonatomic)	CGFloat			visibleSlideOffset;

// Layout
@property (retain, nonatomic)	UIViewController*	leftViewController;
@property (retain, nonatomic)	UIViewController*	rightViewController;
@property (retain, nonatomic)	UIViewController*	rootViewController;

// Targets
@property (assign, nonatomic)	id<JFSlideViewDelegate>	delegate;

// View management
- (void)	showLeftView;
- (void)	showRightView;
- (void)	showRootView;

@end

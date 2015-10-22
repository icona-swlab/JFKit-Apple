//
//  WindowController.m
//  JFFramework
//
//  Created by Jacopo Filié on 04/10/15.
//
//



#import "WindowController.h"



@interface WindowController ()

@end



@implementation WindowController

- (UIViewController*)createRootViewController
{
	UIViewController* retObj = [UIViewController new];
	CGRect frame = retObj.view.bounds;
	frame.origin.y = frame.size.height / 2.0;
	frame.size.height = 44.0;
	JFRatingView* ratingView = [[JFRatingView alloc] initWithFrame:frame];
	ratingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	//retObj.view.backgroundColor = [UIColor cyanColor];
	ratingView.backgroundColor = [UIColor purpleColor];
	ratingView.emptyImage = [UIImage imageNamed:@"Empty"];
	ratingView.halfImage = [UIImage imageNamed:@"Half"];
	ratingView.fullImage = [UIImage imageNamed:@"Full"];
	ratingView.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
	ratingView.imagesDistance = 10.0f;
	ratingView.imageMinimumSize = CGSizeMake(20.0f, 20.0f);
	//ratingView.imageMaximumSize = CGSizeMake(20.0f, 100.0f);
	[retObj.view addSubview:ratingView];
	return retObj;
}

@end

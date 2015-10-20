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
	[retObj.view addSubview:ratingView];
	retObj.view.backgroundColor = [UIColor cyanColor];
	ratingView.backgroundColor = [UIColor purpleColor];
	ratingView.emptyImage = [UIImage imageNamed:@"Empty"];
	ratingView.halfImage = [UIImage imageNamed:@"Half"];
	ratingView.fullImage = [UIImage imageNamed:@"Full"];
	return retObj;
}

@end

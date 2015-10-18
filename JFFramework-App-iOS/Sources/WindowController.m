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
	frame.size.height = 44.0;
	JFRatingView* ratingView = [[JFRatingView alloc] initWithFrame:frame];
	ratingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	[retObj.view addSubview:ratingView];
	retObj.view.backgroundColor = [UIColor cyanColor];
	ratingView.backgroundColor = [UIColor purpleColor];
	return retObj;
}

@end

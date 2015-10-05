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
	JFMenuController* retObj = [JFMenuController new];
	return retObj;
}

@end

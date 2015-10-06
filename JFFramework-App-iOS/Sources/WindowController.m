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
	JFMenuViewController* retObj = [JFMenuViewController new];
	NSMutableArray* sections = [NSMutableArray array];
	for(NSUInteger i = 0; i < 3; i++)
	{
		JFMenuSection* section = [JFMenuSection new];
		section.title = [NSString stringWithFormat:@"Section %@", JFStringFromNSUInteger(i + 1)];
		for(NSUInteger j = 0; j < 5; j++)
		{
			JFMenuItem* item = [JFMenuItem new];
			item.title = [NSString stringWithFormat:@"Item %@", JFStringFromNSUInteger(j + 1)];
			for(NSUInteger k = 0; k < 5; k++)
			{
				JFMenuItem* subitem = [JFMenuItem new];
				subitem.title = [NSString stringWithFormat:@"Subitem %@", JFStringFromNSUInteger(k + 1)];
				[item addSubitem:subitem];
			}
			[section addSubitem:item];
		}
		[sections addObject:section];
	}
	retObj.items = sections;
	return retObj;
}

@end

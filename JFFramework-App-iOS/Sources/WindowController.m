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
	retObj.indentationWidth = 25.0;
	NSMutableArray* sections = [NSMutableArray array];
	for(NSUInteger i = 0; i < 2; i++)
	{
		NSString* sectionIndexString = JFStringFromNSUInteger(i + 1);
		JFMenuSection* section = [JFMenuSection new];
		section.detailText = [NSString stringWithFormat:@"Section %@ footer", sectionIndexString];
		section.title = [NSString stringWithFormat:@"Section %@ header", sectionIndexString];
		for(NSUInteger j = 0; j < 2; j++)
		{
			NSString* itemIndexString1 = [sectionIndexString stringByAppendingFormat:@".%@", JFStringFromNSUInteger(j + 1)];
			JFMenuItem* item = [JFMenuItem new];
			item.title = [NSString stringWithFormat:@"%@. Item", itemIndexString1];
			for(NSUInteger k = 0; k < 2; k++)
			{
				NSString* itemIndexString2 = [itemIndexString1 stringByAppendingFormat:@".%@", JFStringFromNSUInteger(k + 1)];
				JFMenuItem* subitem = [JFMenuItem new];
				subitem.title = [NSString stringWithFormat:@"%@. Item", itemIndexString2];
				for(NSUInteger l = 0; l < 2; l++)
				{
					NSString* itemIndexString3 = [itemIndexString2 stringByAppendingFormat:@".%@", JFStringFromNSUInteger(l + 1)];
					JFMenuItem* subsubitem = [JFMenuItem new];
					subsubitem.title = [NSString stringWithFormat:@"%@. Item", itemIndexString3];
					[subitem addSubitem:subsubitem];
				}
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

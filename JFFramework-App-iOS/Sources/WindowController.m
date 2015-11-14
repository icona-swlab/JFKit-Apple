//
//  WindowController.m
//  JFFramework
//
//  Created by Jacopo Filié on 04/10/15.
//
//



#import "WindowController.h"



@interface WindowController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)	NSArray*	colors;

@end



@implementation WindowController

@synthesize colors	= _colors;

- (UIViewController*)createRootViewController
{
	NSMutableArray* colors = [NSMutableArray array];
	[colors addObject:JFColorWithRGBAHexString(@"FF")];
	[colors addObject:JFColorWithRGBAHexString(@"5F50")];
	[colors addObject:JFColorWithRGBAHexString(@"0FFFF")];
	self.colors = colors;
	
	UIViewController* retObj = [UIViewController new];
	retObj.view.backgroundColor = [UIColor whiteColor];
	CGRect frame = retObj.view.bounds;
	frame.origin.y = 20;
	UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[retObj.view addSubview:tableView];
	return retObj;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.colors count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell* retObj = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if(!retObj)
	{
		retObj = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		retObj.textLabel.font = [UIFont fontWithName:@"Menlo" size:16];
		retObj.textLabel.textAlignment = NSTextAlignmentCenter;
		retObj.textLabel.textColor = [UIColor whiteColor];
	}
	
	UIColor* color = self.colors[indexPath.row];
	
	retObj.backgroundColor = color;
	retObj.textLabel.backgroundColor = JFColorAlpha(128);
	retObj.textLabel.text = [color.jf_colorRGBAHexString uppercaseString];
	
	return retObj;
}

@end

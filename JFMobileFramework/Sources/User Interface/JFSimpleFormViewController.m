//
//  JFSimpleFormViewController.m
//  JFMobileFramework
//
//  Created by Jacopo Filié on 07/04/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFSimpleFormViewController.h"

#import "JFUtilities.h"



static UIEdgeInsets labelInsets = {0.0f, 5.0f, 0.0f, 5.0f};



typedef NS_ENUM(NSUInteger, JFSimpleFormViewCellStyle) {
	JFSimpleFormViewCellStyleField,
	JFSimpleFormViewCellStyleLabel,
	JFSimpleFormViewCellStyleImage,
	JFSimpleFormViewCellStyleText,
};



@interface JFObject : NSObject

// Attributes
@property (assign, nonatomic)	JFSimpleFormViewCellStyle	style;

// Data
@property (copy, nonatomic)	NSString*	text;
@property (copy, nonatomic)	NSString*	title;

@end



@implementation JFObject

#pragma mark - Properties

// Attributes
@synthesize style	= _style;

// Data
@synthesize text	= _text;
@synthesize title	= _title;


#pragma mark - Memory management

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Attributes
		_style = JFSimpleFormViewCellStyleLabel;
    }
	return self;
}

@end



@interface JFSimpleFormViewController ()

// Data
@property (strong, nonatomic, readonly)	NSMutableArray*	tableData;

// Table view management
- (UILabel*)			createSimpleFormViewCellLabelWithFrame:(CGRect)frame;
- (UITableViewCell*)	createSimpleFormViewCellWithStyle:(JFSimpleFormViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
- (void)				fillSimpleFormViewCell:(UITableViewCell*)cell withInfoForObject:(JFObject*)object;

@end



@implementation JFSimpleFormViewController

#pragma mark - Properties

// Data
@synthesize tableData	= _tableData;


#pragma mark - Memory management

- (void)commonInit
{
	// Data
	_tableData = [NSMutableArray new];
}

- (instancetype)init
{
	return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if(self)
	{
		[self commonInit];
    }
	return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
	{
		[self commonInit];
    }
    return self;
}


#pragma mark - User interface delegate

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	JFObject* o1 = [JFObject new];
	o1.title = @"Ingredienti";
	o1.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed quam dui. Ut imperdiet lacus sed rutrum mattis. Fusce ut facilisis mi. Nullam a sagittis ligula. Nunc dictum diam nec luctus dapibus. Vestibulum ac ultricies nibh. Etiam id risus convallis, sollicitudin sem a, consectetur leo. Etiam purus mi, fermentum ut euismod sit amet, cursus nec dui. Donec consectetur sem vel justo dignissim dapibus.";
	JFObject* o2 = [JFObject new];
	o2.title = @"Istruzioni";
	o2.text = @"Integer vel ornare ante. In id leo sit amet tellus feugiat varius vitae vel nulla. Nullam laoreet tortor quam, sed rutrum tellus aliquet vitae. Mauris et orci risus. Vestibulum in neque lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse vitae consectetur quam. Pellentesque vel imperdiet elit, nec posuere enim. Praesent hendrerit metus arcu, at semper diam vulputate in. Fusce in urna turpis. Nullam luctus mollis nisi non consectetur. Mauris vel lacus ut arcu rutrum feugiat nec nec elit.";
	[self.tableData setArray:@[o1, o2]];
	[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFObject* object = [self.tableData objectAtIndex:indexPath.section];
	
	NSString* const CellIdentifier = NSUIntegerToString(object.style);
	
    UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!retVal)
		retVal = [self createSimpleFormViewCellWithStyle:object.style reuseIdentifier:CellIdentifier];
	
	[self fillSimpleFormViewCell:retVal withInfoForObject:object];
    
    return retVal;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	JFObject* object = [self.tableData objectAtIndex:section];
	return object.title;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFObject* object = [self.tableData objectAtIndex:indexPath.section];
	
	CGFloat retVal = UITableViewAutomaticDimension;
	switch(object.style)
	{
		case JFSimpleFormViewCellStyleLabel:
		{
			CGRect frame = self.tableView.bounds;
			frame.size.height -= labelInsets.top + labelInsets.bottom;
			frame.size.width -= labelInsets.left + labelInsets.right;
			
			UILabel* label = [self createSimpleFormViewCellLabelWithFrame:frame];
			label.text = object.text;
			
			CGSize limits = CGSizeMake(self.view.bounds.size.width - (labelInsets.left + labelInsets.right), CGFLOAT_MAX);
			CGSize size = [label sizeThatFits:limits];
			size.height += (iOS6 ? 0.0f : 1.0f);
			
			retVal = size.height + labelInsets.top + labelInsets.bottom;
			break;
		}
		default:
			break;
	}
	
	return retVal;
}


#pragma mark - Table view management

- (UILabel*)createSimpleFormViewCellLabelWithFrame:(CGRect)frame
{
	UILabel* retVal = [[UILabel alloc] initWithFrame:frame];
	retVal.backgroundColor = [UIColor cyanColor];
	retVal.font = [UIFont systemFontOfSize:16.0f];
	retVal.lineBreakMode = NSLineBreakByWordWrapping;
	retVal.numberOfLines = 0;
	return retVal;
}

- (UITableViewCell*)createSimpleFormViewCellWithStyle:(JFSimpleFormViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	UITableViewCell* retVal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if(!retVal)
		return nil;
	
	CGRect frame = retVal.contentView.bounds;
	UIView* view = nil;
	switch(style)
	{
		case JFSimpleFormViewCellStyleField:
		{
			UITextField* textField = [[UITextField alloc] initWithFrame:frame];
			view = textField;
			break;
		}
		case JFSimpleFormViewCellStyleImage:
		{
			UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
			view = imageView;
			break;
		}
		case JFSimpleFormViewCellStyleLabel:
		{
			frame.origin.x += labelInsets.left;
			frame.origin.y += labelInsets.top;
			frame.size.height -= labelInsets.top + labelInsets.bottom;
			frame.size.width -= labelInsets.left + labelInsets.right;
			view = [self createSimpleFormViewCellLabelWithFrame:frame];
			break;
		}
		case JFSimpleFormViewCellStyleText:
		{
			UITextView* textView = [[UITextView alloc] initWithFrame:frame];
			view = textView;
			break;
		}
		default:
			break;
	}
	
	if(view)
	{
		view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		view.tag = 1;
		
		[retVal.contentView addSubview:view];
	}
	
	return retVal;
}

- (void)fillSimpleFormViewCell:(UITableViewCell*)cell withInfoForObject:(JFObject*)object
{
	UIView* view = [cell viewWithTag:1];
	switch(object.style)
	{
		case JFSimpleFormViewCellStyleField:
		{
			//UITextField* textField = (UITextField*)view;
			break;
		}
		case JFSimpleFormViewCellStyleImage:
		{
			//UIImageView* imageView = (UIImageView*)view;
			break;
		}
		case JFSimpleFormViewCellStyleLabel:
		{
			UILabel* label = (UILabel*)view;
			label.text = object.text;
			break;
		}
		case JFSimpleFormViewCellStyleText:
		{
			//UITextView* textView = (UITextView*)view;
			break;
		}
		default:
			break;
	}
}

@end

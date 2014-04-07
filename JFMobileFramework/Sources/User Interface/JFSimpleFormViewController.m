//
//  JFSimpleFormViewController.m
//  JFMobileFramework
//
//  Created by Jacopo Filié on 07/04/14.
//  Copyright (c) 2014 Jacopo Filié. All rights reserved.
//



#import "JFSimpleFormViewController.h"

#import "JFUtilities.h"



// Default insets
UIEdgeInsets const fieldInsets	= {0.0f, 0.0f, 0.0f, 0.0f};
UIEdgeInsets const labelInsets	= {0.0f, 10.0f, 0.0f, 10.0f};
UIEdgeInsets const imageInsets	= {0.0f, 0.0f, 0.0f, 0.0f};
UIEdgeInsets const textInsets	= {0.0f, 0.0f, 0.0f, 0.0f};



@interface JFSimpleFormViewController ()

// Data
@property (strong, nonatomic, readonly)	NSMutableArray*	tableData;

// User interface management
- (UITextField*)	createSimpleFormViewCellField;
- (UIImageView*)	createSimpleFormViewCellImage;
- (UILabel*)		createSimpleFormViewCellLabel;
- (UITextView*)		createSimpleFormViewCellText;

// Table view management
- (UITableViewCell*)	createSimpleFormViewCellWithStyle:(JFSimpleFormViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
- (void)				fillSimpleFormViewCell:(UITableViewCell*)cell withInfo:(JFSimpleFormViewCellInfo*)info;

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
	
	JFSimpleFormViewCellInfo* o1 = [JFSimpleFormViewCellInfo new];
	o1.title = @"Ingredienti";
	o1.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed quam dui. Ut imperdiet lacus sed rutrum mattis. Fusce ut facilisis mi. Nullam a sagittis ligula. Nunc dictum diam nec luctus dapibus. Vestibulum ac ultricies nibh. Etiam id risus convallis, sollicitudin sem a, consectetur leo. Etiam purus mi, fermentum ut euismod sit amet, cursus nec dui. Donec consectetur sem vel justo dignissim dapibus.";
	JFSimpleFormViewCellInfo* o2 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleLabel];
	o2.title = @"Istruzioni";
	o2.text = @"Integer vel ornare ante. In id leo sit amet tellus feugiat varius vitae vel nulla. Nullam laoreet tortor quam, sed rutrum tellus aliquet vitae. Mauris et orci risus. Vestibulum in neque lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse vitae consectetur quam. Pellentesque vel imperdiet elit, nec posuere enim. Praesent hendrerit metus arcu, at semper diam vulputate in. Fusce in urna turpis. Nullam luctus mollis nisi non consectetur. Mauris vel lacus ut arcu rutrum feugiat nec nec elit.";
	JFSimpleFormViewCellInfo* o3 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleImage];
	o3.title = @"Immagine";
	[self.tableData setArray:@[o1, o2, o3]];
	[self.tableView reloadData];
}


#pragma mark - User interface management

- (UITextField*)createSimpleFormViewCellField
{
	UITextField* retVal = [[UITextField alloc] init];
	return retVal;
}

- (UIImageView*)createSimpleFormViewCellImage
{
	UIImageView* retVal = [[UIImageView alloc] init];
	return retVal;
}

- (UILabel*)createSimpleFormViewCellLabel
{
	UILabel* retVal = [[UILabel alloc] init];
	retVal.backgroundColor = [UIColor cyanColor];
	retVal.font = [UIFont systemFontOfSize:16.0f];
	retVal.lineBreakMode = NSLineBreakByWordWrapping;
	retVal.numberOfLines = 0;
	return retVal;
}

- (UITextView*)createSimpleFormViewCellText
{
	UITextView* retVal = [[UITextView alloc] init];
	return retVal;
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
	JFSimpleFormViewCellInfo* info = [self.tableData objectAtIndex:indexPath.section];
	
	NSString* const CellIdentifier = NSUIntegerToString(info.style);
	
    UITableViewCell* retVal = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!retVal)
		retVal = [self createSimpleFormViewCellWithStyle:info.style reuseIdentifier:CellIdentifier];
	
	[self fillSimpleFormViewCell:retVal withInfo:info];
    
    return retVal;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	JFSimpleFormViewCellInfo* info = [self.tableData objectAtIndex:section];
	return info.title;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	JFSimpleFormViewCellInfo* info = [self.tableData objectAtIndex:indexPath.section];
	
	CGFloat retVal = UITableViewAutomaticDimension;
	switch(info.style)
	{
		case JFSimpleFormViewCellStyleLabel:
		{
			CGRect frame = self.tableView.bounds;
			frame.size.height -= info.insets.top + info.insets.bottom;
			frame.size.width -= info.insets.left + info.insets.right;
			
			UILabel* label = [self createSimpleFormViewCellLabel];
			label.frame = frame;
			label.text = info.text;
			
			CGSize limits = CGSizeMake(frame.size.width, CGFLOAT_MAX);
			CGSize size = [label sizeThatFits:limits];
			size.height += (iOS6 ? 0.0f : 1.0f); // Seems to fix an error in the "sizeThatFits:" method of the iOS7+ SDK.
			
			retVal = size.height + info.insets.top + info.insets.bottom;
			break;
		}
		default:
			break;
	}
	
	return retVal;
}


#pragma mark - Table view management

- (UITableViewCell*)createSimpleFormViewCellWithStyle:(JFSimpleFormViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	UITableViewCell* retVal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if(!retVal)
		return nil;
	
	UIView* view = nil;
	switch(style)
	{
		case JFSimpleFormViewCellStyleField:
		{
			UITextField* textField = [[UITextField alloc] init];
			view = textField;
			break;
		}
		case JFSimpleFormViewCellStyleImage:	view = [self createSimpleFormViewCellImage];	break;
		case JFSimpleFormViewCellStyleLabel:	view = [self createSimpleFormViewCellLabel];	break;
		case JFSimpleFormViewCellStyleText:
		{
			UITextView* textView = [[UITextView alloc] init];
			view = textView;
			break;
		}
		default:
			break;
	}
	
	if(view)
	{
		view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		view.frame = retVal.contentView.bounds;
		view.tag = 1;
		
		[retVal.contentView addSubview:view];
	}
	
	return retVal;
}

- (void)fillSimpleFormViewCell:(UITableViewCell*)cell withInfo:(JFSimpleFormViewCellInfo*)info
{
	UIView* view = [cell viewWithTag:1];
	CGRect frame = view.superview.bounds;
	frame.origin.x += info.insets.left;
	frame.origin.y += info.insets.top;
	frame.size.width -= info.insets.left + info.insets.right;
	frame.size.height -= info.insets.top + info.insets.bottom;
	view.frame = frame;
	
	switch(info.style)
	{
		case JFSimpleFormViewCellStyleField:
		{
			//UITextField* textField = (UITextField*)view;
			break;
		}
		case JFSimpleFormViewCellStyleImage:
		{
			NSString* format = [NSString stringWithFormat:@"%gx%g", frame.size.width, frame.size.height];
			NSString* urlString = [NSString stringWithFormat:@"http://placehold.it/%@/", format];
			NSURL* url = [NSURL URLWithString:urlString];
			NSData* data = [NSData dataWithContentsOfURL:url];
			UIImageView* imageView = (UIImageView*)view;
			imageView.image = [UIImage imageWithData:data];
			break;
		}
		case JFSimpleFormViewCellStyleLabel:
		{
			UILabel* label = (UILabel*)view;
			label.text = info.text;
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



@implementation JFSimpleFormViewCellInfo

#pragma mark - Properties

// Attributes
@synthesize insets	= _insets;
@synthesize style	= _style;

// Data
@synthesize text	= _text;
@synthesize title	= _title;


#pragma mark - Memory management

- (instancetype)init
{
	return [self initWithStyle:JFSimpleFormViewCellStyleLabel];
}

- (instancetype)initWithStyle:(JFSimpleFormViewCellStyle)style
{
	UIEdgeInsets insets = UIEdgeInsetsZero;
	switch(style)
	{
		case JFSimpleFormViewCellStyleField:	insets = fieldInsets;	break;
		case JFSimpleFormViewCellStyleImage:	insets = imageInsets;	break;
		case JFSimpleFormViewCellStyleLabel:	insets = labelInsets;	break;
		case JFSimpleFormViewCellStyleText:		insets = textInsets;	break;
			
		default:
			break;
	}
	
	self = [super init];
	if(self)
	{
		// Attributes
		_insets = insets;
		_style = style;
    }
	return self;
}

@end

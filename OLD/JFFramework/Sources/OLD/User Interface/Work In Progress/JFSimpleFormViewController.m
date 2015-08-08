//
//  JFSimpleFormViewController.m
//  Copyright (C) 2014  Jacopo Filié
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//



#import "JFSimpleFormViewController.h"

#import "JFGalleryView.h"
#import "JFUtilities.h"



// Default insets
UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsField	= {13.0f, 8.0f, 13.0f, 8.0f};
UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsGallery	= {0.0f, 0.0f, 0.0f, 0.0f};
UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsLabel	= {4.0f, 8.0f, 4.0f, 8.0f};
UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsImage	= {0.0f, 0.0f, 0.0f, 0.0f};
UIEdgeInsets const JFSimpleFormViewCellDefaultInsetsText	= {0.0f, 0.0f, 0.0f, 0.0f};



@interface JFSimpleFormViewController () <UITextViewDelegate>

// Data
@property (strong, nonatomic, readonly)	NSMutableArray*	tableData;

// User interface management
- (UITextField*)	createSimpleFormViewCellContentField;
- (JFGalleryView*)	createSimpleFormViewCellContentGallery;
- (UIImageView*)	createSimpleFormViewCellContentImage;
- (UILabel*)		createSimpleFormViewCellContentLabel;
- (UITextView*)		createSimpleFormViewCellContentText;

// Table view management
- (UITableViewCell*)	createSimpleFormViewCellWithStyle:(JFSimpleFormViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;
- (void)				fillSimpleFormViewCell:(UITableViewCell*)cell withInfo:(JFSimpleFormViewCellInfo*)info;

// Debug management
- (void)	loadDebugData;

@end



@implementation JFSimpleFormViewController

#pragma mark - Properties

// Data
@synthesize tableData		= _tableData;
@synthesize tableDataInfo	= _tableDataInfo;


#pragma mark - Properties accessors (Data)

- (void)setTableDataInfo:(NSArray*)tableDataInfo
{
	if(_tableDataInfo == tableDataInfo)
		return;
	
	NSMutableArray* acceptableDataInfo = [NSMutableArray arrayWithCapacity:[tableDataInfo count]];
	for(id info in tableDataInfo)
	{
		if([info isKindOfClass:[JFSimpleFormViewCellInfo class]])
			[acceptableDataInfo addObject:info];
	}
	
	_tableDataInfo = [acceptableDataInfo copy];
	
	[self.tableData setArray:_tableDataInfo];
	
	if([self isViewLoaded])
		[self.tableView reloadData];
}


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
	
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
	
	[self loadDebugData];
}


#pragma mark - User interface management

- (UITextField*)createSimpleFormViewCellContentField
{
	UITextField* retVal = [[UITextField alloc] init];
	retVal.borderStyle = UITextBorderStyleNone;
	retVal.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	retVal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	retVal.font = [UIFont systemFontOfSize:14.0f];
	return retVal;
}

- (JFGalleryView*)createSimpleFormViewCellContentGallery
{
	JFGalleryView* retVal = [[JFGalleryView alloc] init];
	return retVal;
}

- (UIImageView*)createSimpleFormViewCellContentImage
{
	UIImageView* retVal = [[UIImageView alloc] init];
	return retVal;
}

- (UILabel*)createSimpleFormViewCellContentLabel
{
	UILabel* retVal = [[UILabel alloc] init];
	retVal.font = [UIFont systemFontOfSize:14.0f];
	retVal.lineBreakMode = NSLineBreakByWordWrapping;
	retVal.numberOfLines = 0;
	return retVal;
}

- (UITextView*)createSimpleFormViewCellContentText
{
	UITextView* retVal = [[UITextView alloc] init];
	retVal.bounces = NO;
	retVal.font = [UIFont systemFontOfSize:14.0f];
	retVal.scrollEnabled = NO;
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
	BOOL isGroupedStyle = (tableView.style == UITableViewStyleGrouped);
	
	JFSimpleFormViewCellInfo* info = [self.tableData objectAtIndex:indexPath.section];
	if(!info)
		return UITableViewAutomaticDimension;
	
	UIView* view = nil;
	switch(info.style)
	{
		case JFSimpleFormViewCellStyleField:
		{
			static UITextField* textField = nil;
			if(!textField)
				textField = [self createSimpleFormViewCellContentField];
			
			textField.font = info.font;
			
			view = textField;
			break;
		}
		case JFSimpleFormViewCellStyleGallery:
		{
			static JFGalleryView* galleryView = nil;
			if(!galleryView)
				galleryView = [self createSimpleFormViewCellContentGallery];
			
			view = galleryView;
			break;
		}
		case JFSimpleFormViewCellStyleImage:
		{
			static UIImageView* imageView = nil;
			if(!imageView)
				imageView = [self createSimpleFormViewCellContentImage];
			
			imageView.image = info.image;
			
			view = imageView;
			break;
		}
		case JFSimpleFormViewCellStyleLabel:
		{
			static UILabel* label = nil;
			if(!label)
				label = [self createSimpleFormViewCellContentLabel];
			
			label.font = info.font;
			label.text = info.text;
			
			view = label;
			break;
		}
		case JFSimpleFormViewCellStyleText:
		{
			static UITextView* textView = nil;
			if(!textView)
				textView = [self createSimpleFormViewCellContentText];

			textView.font = info.font;
			textView.text = info.text;
			
			view = textView;
			break;
		}
		default:
			break;
	}
	if(!view)
		return UITableViewAutomaticDimension;
	
	CGRect frame = tableView.bounds;
	frame.size.width -= info.insets.left + info.insets.right + (isGroupedStyle ? 20.0f : 0.0f);
	CGSize limits = CGSizeMake(frame.size.width, CGFLOAT_MAX);
	CGSize size = [view sizeThatFits:limits];
	size.height += (iOS6 ? 0.0f : 1.0f); // Seems to fix an error in the "sizeThatFits:" method of the iOS7+ SDK.
	
	return (size.height + info.insets.top + info.insets.bottom);
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
		case JFSimpleFormViewCellStyleField:	view = [self createSimpleFormViewCellContentField];		break;
		case JFSimpleFormViewCellStyleGallery:	view = [self createSimpleFormViewCellContentGallery];	break;
		case JFSimpleFormViewCellStyleImage:	view = [self createSimpleFormViewCellContentImage];		break;
		case JFSimpleFormViewCellStyleLabel:	view = [self createSimpleFormViewCellContentLabel];		break;
		case JFSimpleFormViewCellStyleText:		view = [self createSimpleFormViewCellContentText];		break;
			
		default:
			break;
	}
	
	if(view)
	{
		view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		view.backgroundColor = [UIColor clearColor];
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
			UITextField* textField = (UITextField*)view;
			textField.font = info.font;
			textField.placeholder = info.placeholder;
			textField.text = info.text;
			break;
		}
		case JFSimpleFormViewCellStyleGallery:
		{
			break;
		}
		case JFSimpleFormViewCellStyleImage:
		{
			UIImageView* imageView = (UIImageView*)view;
			imageView.image = info.image;
			break;
		}
		case JFSimpleFormViewCellStyleLabel:
		{
			UILabel* label = (UILabel*)view;
			label.font = info.font;
			label.text = info.text;
			break;
		}
		case JFSimpleFormViewCellStyleText:
		{
			UITextView* textView = (UITextView*)view;
			textView.font = info.font;
			textView.text = info.text;
			break;
		}
		default:
			break;
	}
}


#pragma mark - Debug management

- (void)loadDebugData
{
	NSString* urlString = [NSString stringWithFormat:@"http://placehold.it/320x400/"];
	NSURL* url = [NSURL URLWithString:urlString];
	NSData* data = [NSData dataWithContentsOfURL:url];
	UIImage* image = [UIImage imageWithData:data];
	
	JFSimpleFormViewCellInfo* o1 = [JFSimpleFormViewCellInfo new];
	o1.title = @"New";
	o1.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed quam dui. Ut imperdiet lacus sed rutrum mattis. Fusce ut facilisis mi. Nullam a sagittis ligula. Nunc dictum diam nec luctus dapibus. Vestibulum ac ultricies nibh. Etiam id risus convallis, sollicitudin sem a, consectetur leo. Etiam purus mi, fermentum ut euismod sit amet, cursus nec dui. Donec consectetur sem vel justo dignissim dapibus.";
	JFSimpleFormViewCellInfo* o2 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleLabel];
	o2.title = @"Label";
	o2.text = @"Integer vel ornare ante. In id leo sit amet tellus feugiat varius vitae vel nulla. Nullam laoreet tortor quam, sed rutrum tellus aliquet vitae. Mauris et orci risus. Vestibulum in neque lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse vitae consectetur quam. Pellentesque vel imperdiet elit, nec posuere enim. Praesent hendrerit metus arcu, at semper diam vulputate in. Fusce in urna turpis. Nullam luctus mollis nisi non consectetur. Mauris vel lacus ut arcu rutrum feugiat nec nec elit.";
	JFSimpleFormViewCellInfo* o3 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleImage];
	o3.title = @"Image";
	o3.image = image;
	JFSimpleFormViewCellInfo* o4 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleField];
	o4.title = @"Field";
	o4.placeholder = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
	JFSimpleFormViewCellInfo* o5 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleText];
	o5.title = @"Text";
	o5.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed quam dui. Ut imperdiet lacus sed rutrum mattis. Fusce ut facilisis mi. Nullam a sagittis ligula. Nunc dictum diam nec luctus dapibus. Vestibulum ac ultricies nibh. Etiam id risus convallis, sollicitudin sem a, consectetur leo. Etiam purus mi, fermentum ut euismod sit amet, cursus nec dui. Donec consectetur sem vel justo dignissim dapibus.";
	
	JFSimpleFormViewCellInfo* o6 = [[JFSimpleFormViewCellInfo alloc] initWithStyle:JFSimpleFormViewCellStyleGallery];
	o6.title = @"Gallery";
	o3.image = image;
	
	[self.tableData setArray:@[o5, o6, o4, o2, o1, o3]];
	
	if([self isViewLoaded])
		[self.tableView reloadData];
}

@end



@implementation JFSimpleFormViewCellInfo

#pragma mark - Properties

// Attributes
@synthesize font	= _font;
@synthesize insets	= _insets;
@synthesize style	= _style;

// Data
@synthesize image		= _image;
@synthesize placeholder	= _placeholder;
@synthesize text		= _text;
@synthesize title		= _title;


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
		case JFSimpleFormViewCellStyleField:	insets = JFSimpleFormViewCellDefaultInsetsField;	break;
		case JFSimpleFormViewCellStyleGallery:	insets = JFSimpleFormViewCellDefaultInsetsGallery;	break;
		case JFSimpleFormViewCellStyleImage:	insets = JFSimpleFormViewCellDefaultInsetsImage;	break;
		case JFSimpleFormViewCellStyleLabel:	insets = JFSimpleFormViewCellDefaultInsetsLabel;	break;
		case JFSimpleFormViewCellStyleText:		insets = JFSimpleFormViewCellDefaultInsetsText;		break;
			
		default:
			break;
	}
	
	self = [super init];
	if(self)
	{
		// Attributes
		_font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		_insets = insets;
		_style = style;
    }
	return self;
}

@end

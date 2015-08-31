//
//  JFTextView.m
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



#import "JFTextView.h"

#import "JFLabel.h"
#import "JFUtilities.h"



@interface JFTextView ()

// User interface
@property (strong, nonatomic, readonly)	JFLabel*	placeholderLabel;

// User interface management
- (void)	hidePlaceholderLabel;
- (void)	prepareUserInterface;
- (void)	showPlaceholderLabel;
- (void)	updatePlaceholderVisibility;

// Notifications management (UITextView)
- (void)	notifiedThatTextDidChange:(NSNotification*)notification;

@end



@implementation JFTextView

#pragma mark - Properties

// Data
@synthesize placeholder	= _placeholder;

// User interface
@synthesize placeholderLabel	= _placeholderLabel;


#pragma mark - Properties accessors (Data)

- (void)setPlaceholder:(NSString*)placeholder
{
	if(JFAreObjectsEqual(_placeholder, placeholder))
		return;
	
	_placeholder = [placeholder copy];
	
	self.placeholderLabel.text = [_placeholder copy];
	
	[self setNeedsDisplay];
}


#pragma mark - Properties accessors (Inherited)

- (void)setFont:(UIFont*)font
{
	[super setFont:font];
	self.placeholderLabel.font = font;
}

- (void)setText:(NSString*)text
{
	[super setText:text];
	[self updatePlaceholderVisibility];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
	[super setTextAlignment:textAlignment];
	self.placeholderLabel.textAlignment = textAlignment;
}


#pragma mark - Memory management

- (void)dealloc
{
	[MainNotificationCenter removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self prepareUserInterface];
		
		// Begins to listen for interesting notifications.
		[MainNotificationCenter addObserver:self selector:@selector(notifiedThatTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self prepareUserInterface];
		
		// Begins to listen for interesting notifications.
		[MainNotificationCenter addObserver:self selector:@selector(notifiedThatTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
	}
	return self;
}


#pragma mark - User interface management

- (void)hidePlaceholderLabel
{
	if(self.placeholderLabel.hidden)
		return;
	
	self.placeholderLabel.hidden = YES;
}

- (void)prepareUserInterface
{
	JFLabel* label = [JFLabel new];
	label.backgroundColor = [UIColor clearColor];
	label.font = self.font;
	label.lineBreakMode = NSLineBreakByTruncatingTail;
	label.numberOfLines = 0;
	label.textAlignment = self.textAlignment;
	label.textColor = [UIColor lightGrayColor];
	
	label.text = self.placeholder;
	
	[self addSubview:label];
	
	_placeholderLabel = label;
	
	[self updatePlaceholderVisibility];
}

- (void)showPlaceholderLabel
{
	if(!self.placeholderLabel.hidden)
		return;
	
	self.placeholderLabel.hidden = NO;
}

- (void)updatePlaceholderVisibility
{
	if([self.text length] == 0)
		[self showPlaceholderLabel];
	else
		[self hidePlaceholderLabel];
}


#pragma mark - User interface management (Inherited)

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	BOOL shouldUseFallbackSolution = !iOS7Plus;
	
	float linePadding = (shouldUseFallbackSolution ? 5.0f : self.textContainer.lineFragmentPadding);
	UIEdgeInsets insets = (shouldUseFallbackSolution ? UIEdgeInsetsMake(8.0f, 4.0f, 8.0f, 4.0) : self.textContainerInset);
	
	CGRect frame = CGRectZero;
	frame.origin.x = insets.left + linePadding;
	frame.origin.y = insets.top;
	frame.size.width = CGRectGetWidth(rect) - (insets.left + insets.right + 2 * linePadding);
	frame.size.height = CGFLOAT_MAX;
	
	CGSize size = [self.placeholderLabel sizeThatFits:frame.size];
	frame.size.height = MIN(size.height, CGRectGetHeight(frame));
	
	self.placeholderLabel.frame = frame;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setNeedsDisplay];
}


#pragma mark - Notifications management (UITextView)

- (void)notifiedThatTextDidChange:(NSNotification*)notification
{
	[self updatePlaceholderVisibility];
}

@end

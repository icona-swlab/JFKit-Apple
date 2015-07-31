//
//  JFActivityIndicatorView.m
//  Copyright (C) 2015  Jacopo Filié
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



#import "JFActivityIndicatorView.h"

#import "JFLabel.h"



@interface JFActivityIndicatorView ()

#pragma mark Properties

// Constraints
@property (strong, nonatomic, readonly)	NSMutableArray*	addedConstraints;
@property (strong, nonatomic, readonly)	NSMutableArray*	containerViewAddedConstraints;
@property (strong, nonatomic, readonly)	NSMutableArray*	imageViewAddedConstraints;

// Flags
@property (assign, nonatomic)										BOOL	shouldShowActionButton;
@property (assign, nonatomic)										BOOL	shouldShowMessageLabel;
@property (assign, nonatomic)										BOOL	shouldUseIndicatorView;
@property (assign, nonatomic, getter = isUserInterfaceInitialized)	BOOL	userInterfaceInitialized;

// User interface
@property (strong, nonatomic)	UIButton*					actionButton;
@property (strong, nonatomic)	UIView*						containerView;
@property (strong, nonatomic)	UIImageView*				imageView;
@property (strong, nonatomic)	UIActivityIndicatorView*	indicatorView;
@property (strong, nonatomic)	JFLabel*					messageLabel;


#pragma mark Methods

// User interface management
- (void)	toggleIndicatorsAnimation;
- (void)	updateComponentsVisibility;

@end



#pragma mark



@implementation JFActivityIndicatorView

#pragma mark Properties

// Attributes
@synthesize animationDuration	= _animationDuration;
@synthesize animationSize		= _animationSize;

// Constraints
@synthesize addedConstraints			= _addedConstraints;
@synthesize containerViewAddedConstraints	= _containerViewAddedConstraints;
@synthesize imageViewAddedConstraints	= _imageViewAddedConstraints;

// Data
@synthesize animationImages	= _animationImages;
@synthesize buttonBlock		= _buttonBlock;
@synthesize buttonTitle		= _buttonTitle;
@synthesize message			= _message;

// Flags
@synthesize shouldShowActionButton		= _shouldShowActionButton;
@synthesize shouldShowMessageLabel		= _shouldShowMessageLabel;
@synthesize shouldUseIndicatorView		= _shouldUseIndicatorView;
@synthesize userInterfaceInitialized	= _userInterfaceInitialized;

// User interface
@synthesize actionButton	= _actionButton;
@synthesize containerView	= _containerView;
@synthesize imageView		= _imageView;
@synthesize indicatorView	= _indicatorView;
@synthesize messageLabel	= _messageLabel;


#pragma mark Properties accessors (Attributes)

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
	if(_animationDuration == animationDuration)
		return;
	
	_animationDuration = animationDuration;
	
	self.imageView.animationDuration = _animationDuration;
}

- (void)setAnimationSize:(CGSize)animationSize
{
	if(CGSizeEqualToSize(_animationSize, animationSize))
		return;
	
	_animationSize = animationSize;
	
	if([self isUserInterfaceInitialized])
		[self setNeedsUpdateConstraints];
}


#pragma mark Properties accessors (Data)

- (void)setAnimationImages:(NSArray*)animationImages
{
	if(JFAreObjectsEqual(_animationImages, animationImages))
		return;
	
	_animationImages = [animationImages copy];
	
	self.shouldUseIndicatorView = !_animationImages;
	
	if([self isUserInterfaceInitialized])
		self.imageView.animationImages = _animationImages;
}

- (void)setButtonBlock:(JFButtonBlock)buttonBlock
{
	if(_buttonBlock == buttonBlock)
		return;
	
	_buttonBlock = buttonBlock;
	
	self.shouldShowActionButton = (_buttonBlock && self.buttonTitle);
	
	if([self isUserInterfaceInitialized])
		self.actionButton.actionBlock = buttonBlock;
}

- (void)setButtonTitle:(NSString*)buttonTitle
{
	if(JFAreObjectsEqual(_buttonTitle, buttonTitle))
		return;
	
	_buttonTitle = [buttonTitle copy];
	
	self.shouldShowActionButton = (self.buttonBlock && _buttonTitle);
	
	if([self isUserInterfaceInitialized])
		[self.actionButton setTitle:_buttonTitle forState:UIControlStateNormal];
}

- (void)setMessage:(NSString*)message
{
	if(JFAreObjectsEqual(_message, message))
		return;
	
	_message = [message copy];
	
	self.shouldShowMessageLabel = (BOOL)_message;
	
	if([self isUserInterfaceInitialized])
		self.messageLabel.text = _message;
}


#pragma mark Properties accessors (Flags)

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	[self toggleIndicatorsAnimation];
}

- (void)setShouldShowActionButton:(BOOL)shouldShowActionButton
{
	if(_shouldShowActionButton == shouldShowActionButton)
		return;
	
	_shouldShowActionButton = shouldShowActionButton;
	
	if([self isUserInterfaceInitialized])
		[self updateComponentsVisibility];
}

- (void)setShouldShowMessageLabel:(BOOL)shouldShowMessageLabel
{
	if(_shouldShowMessageLabel == shouldShowMessageLabel)
		return;
	
	_shouldShowMessageLabel = shouldShowMessageLabel;
	
	if([self isUserInterfaceInitialized])
		[self updateComponentsVisibility];
}

- (void)setShouldUseIndicatorView:(BOOL)shouldUseIndicatorView
{
	if(_shouldUseIndicatorView == shouldUseIndicatorView)
		return;
	
	_shouldUseIndicatorView = shouldUseIndicatorView;
	
	if([self isUserInterfaceInitialized])
		[self updateComponentsVisibility];
}


#pragma mark Memory management

- (void)initializeProperties
{
	// Constraints
	_addedConstraints				= [NSMutableArray new];
	_containerViewAddedConstraints	= [NSMutableArray new];
	_imageViewAddedConstraints		= [NSMutableArray new];
	
	// Flags
	_shouldShowActionButton		= NO;
	_shouldShowMessageLabel		= NO;
	_shouldUseIndicatorView		= YES;
	_userInterfaceInitialized	= NO;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self initializeProperties];
	}
	return self;
}


#pragma mark User interface management

- (void)initializeUserInterface
{
	// Prepares itself.
	self.backgroundColor = ColorAlpha(80.0f);
	self.opaque = NO;
	self.userInteractionEnabled = YES;
	
	// Prepares the container view.
	UIView* containerView = [UIView new];
	containerView.backgroundColor = ColorAlpha(192.0f);
	containerView.layer.cornerRadius = 8.0f;
	containerView.opaque = NO;
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:containerView];
	self.containerView = containerView;
	
	[self updateComponentsVisibility];
}

- (void)toggleIndicatorsAnimation
{
	if([self shouldUseIndicatorView])
	{
		[self.imageView stopAnimating];
		
		if([self isHidden])
			[self.indicatorView stopAnimating];
		else
			[self.indicatorView startAnimating];
	}
	else
	{
		[self.indicatorView stopAnimating];
		
		if([self isHidden])
			[self.imageView stopAnimating];
		else
			[self.imageView startAnimating];
	}
}

- (void)updateComponentsVisibility
{
	UIView* containerView = self.containerView;
	
	if([self shouldShowActionButton])
	{
		UIButton* button = self.actionButton;
		if(!button)
		{
			button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.actionBlock = self.buttonBlock;
			button.translatesAutoresizingMaskIntoConstraints = NO;
			[button setTitle:self.buttonTitle forState:UIControlStateNormal];
			self.actionButton = button;
		}
		[containerView addSubview:button];
	}
	else
		[self.actionButton removeFromSuperview];
	
	if([self shouldShowMessageLabel])
	{
		JFLabel* label = self.messageLabel;
		if(!label)
		{
			label = [[JFLabel alloc] init];
			label.backgroundColor = [UIColor clearColor];
			label.numberOfLines = 0;
			label.opaque = NO;
			label.text = self.message;
			label.textAlignment = NSTextAlignmentCenter;
			label.textColor = [UIColor whiteColor];
			label.translatesAutoresizingMaskIntoConstraints = NO;
			[containerView addSubview:label];
			self.messageLabel = label;
		}
		[containerView addSubview:label];
	}
	else
		[self.messageLabel removeFromSuperview];
	
	if([self shouldUseIndicatorView])
	{
		[self.imageView removeFromSuperview];
		
		UIActivityIndicatorView* indicatorView = self.indicatorView;
		if(!indicatorView)
		{
			indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
			self.indicatorView = indicatorView;
		}
		[containerView addSubview:indicatorView];
	}
	else
	{
		[self.indicatorView removeFromSuperview];
		
		UIImageView* imageView = self.imageView;
		if(!imageView)
		{
			imageView = [UIImageView new];
			imageView.animationDuration = self.animationDuration;
			imageView.animationImages = self.animationImages;
			imageView.translatesAutoresizingMaskIntoConstraints = NO;
			[containerView addSubview:imageView];
			self.imageView = imageView;
		}
		[containerView addSubview:imageView];
	}
	
	[self toggleIndicatorsAnimation];
	
	[self.containerView setNeedsUpdateConstraints];
}


#pragma mark User interface management (Constraints)

- (void)updateConstraints
{
	UIView* containerView = self.containerView;
	
	// Removes the old constraints.
	[self removeConstraints:self.addedConstraints];
	[containerView removeConstraints:self.containerViewAddedConstraints];
	
	// Prepares some constraint shortcuts.
	__unused NSLayoutAttribute ab = NSLayoutAttributeBottom;
	__unused NSLayoutAttribute al = NSLayoutAttributeLeft;
	__unused NSLayoutAttribute ar = NSLayoutAttributeRight;
	__unused NSLayoutAttribute at = NSLayoutAttributeTop;
	__unused NSLayoutAttribute ah = NSLayoutAttributeHeight;
	__unused NSLayoutAttribute aw = NSLayoutAttributeWidth;
	__unused NSLayoutAttribute an = NSLayoutAttributeNotAnAttribute;
	__unused NSLayoutAttribute ax = NSLayoutAttributeCenterX;
	__unused NSLayoutAttribute ay = NSLayoutAttributeCenterY;
	__unused NSLayoutRelation re = NSLayoutRelationEqual;
	__unused NSLayoutRelation rg = NSLayoutRelationGreaterThanOrEqual;
	__unused NSLayoutRelation rl = NSLayoutRelationLessThanOrEqual;
	
	// Prepares the margin offset value.
	CGFloat offset = 10.0f;
	
	// Creates the container view constraints.
	UIView* v1 = containerView;
	UIView* v2 = self;

	NSMutableArray* constraints = [NSMutableArray array];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:rg toItem:v2 attribute:at multiplier:1.0f constant:offset]];	// Top
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:rl toItem:v2 attribute:ab multiplier:1.0f constant:-offset]];	// Bottom
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:rg toItem:v2 attribute:al multiplier:1.0f constant:offset]];	// Left
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:rl toItem:v2 attribute:ar multiplier:1.0f constant:-offset]];	// Right
	for(NSLayoutConstraint* constraint in constraints)
		constraint.priority = UILayoutPriorityDefaultHigh;
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]];	// Center X
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ay relatedBy:re toItem:v2 attribute:ay multiplier:1.0f constant:0.0f]];	// Center Y
	[self addConstraints:constraints];
	[self.addedConstraints setArray:constraints];
	[constraints removeAllObjects];
	
	// Prepares the indicator view.
	UIView* indicatorView = ([self shouldUseIndicatorView] ? self.indicatorView : self.imageView);
	
	if(![self shouldUseIndicatorView])
	{
		CGSize size = self.animationSize;
		[indicatorView removeConstraints:self.imageViewAddedConstraints];
		[constraints addObject:[NSLayoutConstraint constraintWithItem:indicatorView attribute:aw relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:size.width]];
		[constraints addObject:[NSLayoutConstraint constraintWithItem:indicatorView attribute:ah relatedBy:re toItem:nil attribute:an multiplier:1.0f constant:size.height]];
		[indicatorView addConstraints:constraints];
		[constraints removeAllObjects];
	}
	
	// Prepares the padding offset value.
	offset = 15.0f;
	
	// Creates the indicator view constraints.
	v1 = indicatorView;
	v2 = containerView;
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:at multiplier:1.0f constant:offset]];	// Top
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:rg toItem:v2 attribute:al multiplier:1.0f constant:offset]];	// Left
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:rl toItem:v2 attribute:ar multiplier:1.0f constant:-offset]];	// Right
	[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]];		// Center X
	if(![self shouldShowActionButton] && ![self shouldShowMessageLabel])
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:-offset]];	// Bottom
	[containerView addConstraints:constraints];
	[self.containerViewAddedConstraints setArray:constraints];
	[constraints removeAllObjects];
	
	if([self shouldShowMessageLabel])
	{
		// Creates the message label constraints.
		v1 = self.messageLabel;
		v2 = indicatorView;
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:20.0f]];	// Top
		
		v2 = containerView;
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:re toItem:v2 attribute:al multiplier:1.0f constant:offset]];	// Left
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:re toItem:v2 attribute:ar multiplier:1.0f constant:-offset]];	// Right
		if(![self shouldShowActionButton])
			[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:-offset]];	// Bottom
		[containerView addConstraints:constraints];
		[self.containerViewAddedConstraints addObjectsFromArray:constraints];
		[constraints removeAllObjects];
	}
	
	if([self shouldShowActionButton])
	{
		// Creates the action button constraints.
		v1 = self.actionButton;
		v2 = ([self shouldShowMessageLabel] ? self.messageLabel : indicatorView);
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:at relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:25.0f]];	// Top
		v2 = containerView;
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:al relatedBy:rg toItem:v2 attribute:al multiplier:1.0f constant:offset]];	// Left
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ar relatedBy:rl toItem:v2 attribute:ar multiplier:1.0f constant:-offset]];	// Right
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ax relatedBy:re toItem:v2 attribute:ax multiplier:1.0f constant:0.0f]];		// Center X
		[constraints addObject:[NSLayoutConstraint constraintWithItem:v1 attribute:ab relatedBy:re toItem:v2 attribute:ab multiplier:1.0f constant:-offset]];	// Bottom
		[self.containerViewAddedConstraints addObjectsFromArray:constraints];
		[containerView addConstraints:constraints];
		[constraints removeAllObjects];
	}
	
	[super updateConstraints];
}


#pragma mark User interface management (Lifecycle)

- (void)didMoveToWindow
{
	[super didMoveToWindow];
	
	if(![self isUserInterfaceInitialized])
	{
		[self initializeUserInterface];
		self.userInterfaceInitialized = YES;
	}
}

@end

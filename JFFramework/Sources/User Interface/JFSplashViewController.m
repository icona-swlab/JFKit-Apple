//
//  JFSplashViewController.m
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



#import "JFSplashViewController.h"



@interface JFSplashViewController ()

#pragma mark Properties

// Gestures
@property (strong, nonatomic)	UITapGestureRecognizer*	tapGestureRecognizer;

// Timings
@property (strong, nonatomic)	NSTimer*	timer;

// User interface
@property (strong, nonatomic, readwrite)	UIImageView*	imageView;


#pragma mark Methods

// Timings management
- (void)	initializeTimer;
- (void)	invalidateTimer;
- (void)	timerDidFire:(NSTimer*)timer;

@end



#pragma mark



@implementation JFSplashViewController

#pragma mark Properties

// Flags
@synthesize userInteractionEnabled	= _userInteractionEnabled;

// Gestures
@synthesize tapGestureRecognizer	= _tapGestureRecognizer;

// Relationships
@synthesize delegate	= _delegate;

// Timings
@synthesize timeout	= _timeout;
@synthesize timer	= _timer;

// User interface
@synthesize imageView	= _imageView;


#pragma mark Properties accessors (Flags)

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
	if(_userInteractionEnabled == userInteractionEnabled)
		return;
	
	_userInteractionEnabled = userInteractionEnabled;
	
	if([self isViewLoaded])
		self.tapGestureRecognizer.enabled = userInteractionEnabled;
}


#pragma mark Properties accessors (Timing)

- (void)setTimeout:(NSTimeInterval)timeout
{
	if(_timeout == timeout)
		return;
	
	_timeout = timeout;
	
	if([self isViewLoaded])
		[self initializeTimer];
}


#pragma mark Properties accessors (User interface)

- (UIImageView*)imageView
{
	if(!_imageView)
	{
		_imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		_imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		_imageView.translatesAutoresizingMaskIntoConstraints = YES;
		[self.view addSubview:_imageView];
	}
	
	return _imageView;
}


#pragma mark Memory management

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil logger:(JFLogger*)logger
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil logger:logger];
	if(self)
	{
		// Flags
		_userInteractionEnabled = YES;
		
		// Timings
		_timeout = 5.0;
	}
	return self;
}


#pragma mark Timings management

- (void)initializeTimer
{
	[self invalidateTimer];
	
	NSTimeInterval timeout = self.timeout;
	self.timer = ((timeout > 0.0) ? [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timerDidFire:) userInfo:nil repeats:NO] : nil);
}

- (void)invalidateTimer
{
	if([self.timer isValid])
		[self.timer invalidate];
}

- (void)timerDidFire:(NSTimer*)timer
{
	if([self.delegate respondsToSelector:@selector(splashViewControllerTimedOut:)])
		[self.delegate splashViewControllerTimedOut:self];
}


#pragma mark User interface management (Actions)

- (IBAction)tapGestureRecognized:(UITapGestureRecognizer*)sender
{
	if([self.delegate respondsToSelector:@selector(splashViewControllerTapGestureRecognized:)])
		[self.delegate splashViewControllerTapGestureRecognized:self];
}


#pragma mark User interface management (View lifecycle)

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self initializeTimer];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Creates the tap gesture recognizer.
	UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
	recognizer.enabled = self.userInteractionEnabled;
	self.tapGestureRecognizer = recognizer;
	[self.view addGestureRecognizer:recognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self invalidateTimer];
}

@end

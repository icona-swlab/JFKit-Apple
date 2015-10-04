//
//  JFSliderController.h
//  Copyright (C) 2014 Jacopo Filié
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



#import "JFUtilities.h"



@class JFSliderController;



#pragma mark - Typedefs

typedef NS_ENUM(UInt8, JFSliderControllerPanel)
{
	JFSliderControllerPanelLeft,
	JFSliderControllerPanelRight,
	JFSliderControllerPanelRoot,
};

typedef NS_ENUM(UInt8, JFSliderControllerTransition)
{
	JFSliderControllerTransitionNone,
	JFSliderControllerTransitionLeftToRoot,
	JFSliderControllerTransitionRightToRoot,
	JFSliderControllerTransitionRootToLeft,
	JFSliderControllerTransitionRootToRight,
};



#pragma mark



@protocol JFSliderControllerDelegate <NSObject>

@optional

- (void)	sliderController:(JFSliderController*)sliderController didActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didCancelDeactivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didCancelActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didDeactivatePanel:(JFSliderControllerPanel)panel;
- (BOOL)	sliderController:(JFSliderController*)sliderController shouldActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController willActivatePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController willDeactivatePanel:(JFSliderControllerPanel)panel;

@end



#pragma mark



@interface JFSliderController : UIViewController

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	NSTimeInterval	slideInDuration;
@property (assign, nonatomic)	UIEdgeInsets	slideInsets;
@property (assign, nonatomic)	NSTimeInterval	slideOutDuration;

// Flags
@property (assign, nonatomic, readonly)	JFSliderControllerPanel			currentActivePanel;
@property (assign, nonatomic, readonly)	JFSliderControllerTransition	currentTransition;

// Relationships
@property (weak, nonatomic)	id<JFSliderControllerDelegate>	delegate;

// User interface
@property (strong, nonatomic, readonly)	UIViewController*	activeViewController;
@property (strong, nonatomic)			UIViewController*	leftViewController;
@property (strong, nonatomic)			UIViewController*	rightViewController;
@property (strong, nonatomic)			UIViewController*	rootViewController;


#pragma mark Methods

// User interface management
- (BOOL)				activatePanel:(JFSliderControllerPanel)panel;
- (BOOL)				activatePanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(JFBlockWithBOOL)completion;
- (UIViewController*)	viewControllerForPanel:(JFSliderControllerPanel)panel;

// Utilities management (Debug)
+ (NSString*)	debugStringFromPanel:(JFSliderControllerPanel)panel;
+ (NSString*)	debugStringFromTransition:(JFSliderControllerTransition)transition;
- (NSString*)	debugStringFromPanel:(JFSliderControllerPanel)panel;
- (NSString*)	debugStringFromTransition:(JFSliderControllerTransition)transition;

@end

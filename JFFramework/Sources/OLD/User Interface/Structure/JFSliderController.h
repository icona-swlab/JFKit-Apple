//
//  JFSliderController.h
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



#import "JFUtilities.h"



@class JFSliderController;



// List of slider panels.
typedef NS_ENUM(UInt8, JFSliderControllerPanel)
{
	JFSliderControllerPanelLeft,
	JFSliderControllerPanelRight,
	JFSliderControllerPanelRoot,
};



@protocol JFSliderControllerDelegate <NSObject>

@optional

- (UIInterfaceOrientation)	sliderControllerPreferredInterfaceOrientationForPresentation:(JFSliderController*)sliderController;
- (BOOL)					sliderControllerShouldAutorotate:(JFSliderController*)sliderController;
- (NSUInteger)				sliderControllerSupportedInterfaceOrientations:(JFSliderController*)sliderController;

- (BOOL)	sliderController:(JFSliderController*)sliderController shouldShowPanel:(JFSliderControllerPanel)panel;

- (void)	sliderController:(JFSliderController*)sliderController didCancelHidePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didCancelShowPanel:(JFSliderControllerPanel)panel;

- (void)	sliderController:(JFSliderController*)sliderController didHidePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController didShowPanel:(JFSliderControllerPanel)panel;

- (void)	sliderController:(JFSliderController*)sliderController willHidePanel:(JFSliderControllerPanel)panel;
- (void)	sliderController:(JFSliderController*)sliderController willShowPanel:(JFSliderControllerPanel)panel;

@end



@interface JFSliderController : UIViewController

// Attributes
@property (assign, nonatomic)	NSTimeInterval	slideInDuration;
@property (assign, nonatomic)	UIEdgeInsets	slideInsets;
@property (assign, nonatomic)	NSTimeInterval	slideOutDuration;

// Flags
@property (assign, nonatomic, readonly)	JFSliderControllerPanel	currentFocalPanel;

// User interface
@property (strong, nonatomic)	UIViewController*	leftPanel;
@property (strong, nonatomic)	UIViewController*	rightPanel;
@property (strong, nonatomic)	UIViewController*	rootPanel;

// Relationships
@property (weak, nonatomic)	id<JFSliderControllerDelegate>	delegate;

// User interface management
- (BOOL)	showPanel:(JFSliderControllerPanel)panel;
- (BOOL)	showPanel:(JFSliderControllerPanel)panel animated:(BOOL)animated completion:(BlockWithBool)completion;

// Utilities
+ (NSString*)	convertPanelToString:(JFSliderControllerPanel)panel;
- (NSString*)	convertPanelToString:(JFSliderControllerPanel)panel;

@end

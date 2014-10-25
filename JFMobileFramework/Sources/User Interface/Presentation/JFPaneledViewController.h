//
//  JFPaneledViewController.h
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



#import <UIKit/UIKit.h>

#import "JFUtilities.h"



@class JFPaneledViewController;



@protocol JFPaneledViewControllerDelegate <NSObject>

@optional

- (BOOL)	paneledViewController:(JFPaneledViewController*)paneledViewController shouldShowLeftPanel:(UIViewController*)leftPanel;
- (BOOL)	paneledViewController:(JFPaneledViewController*)paneledViewController shouldShowRightPanel:(UIViewController*)rightPanel;
- (BOOL)	paneledViewController:(JFPaneledViewController*)paneledViewController shouldShowRootPanel:(UIViewController*)rootPanel;

- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController didCancelHidePanel:(UIViewController*)panel;
- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController didCancelShowPanel:(UIViewController*)panel;

- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController didHidePanel:(UIViewController*)panel;
- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController didShowPanel:(UIViewController*)panel;

- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController willHidePanel:(UIViewController*)panel;
- (void)	paneledViewController:(JFPaneledViewController*)paneledViewController willShowPanel:(UIViewController*)panel;

@end



// Custom types
typedef NS_ENUM(UInt8, JFPaneledViewControllerState)
{
	JFPaneledViewControllerStateIsShowingLeftPanel,
	JFPaneledViewControllerStateIsShowingRightPanel,
	JFPaneledViewControllerStateIsShowingRootPanel,
};



@interface JFPaneledViewController : UIViewController

// Attributes
@property (assign, nonatomic)	NSTimeInterval	slideInDuration;
@property (assign, nonatomic)	CGFloat			slideOffset;
@property (assign, nonatomic)	NSTimeInterval	slideOutDuration;

// Flags
@property (assign, nonatomic, readonly)	JFPaneledViewControllerState	state;

// User interface
@property (strong, nonatomic)	UIViewController*	leftPanel;
@property (strong, nonatomic)	UIViewController*	rightPanel;
@property (strong, nonatomic)	UIViewController*	rootPanel;

// Relationships
@property (weak, nonatomic)	id<JFPaneledViewControllerDelegate>	delegate;

// User interface management
- (BOOL)	showLeftPanel;
- (BOOL)	showLeftPanel:(BOOL)animated completion:(BlockWithBool)completion;
- (BOOL)	showRightPanel;
- (BOOL)	showRightPanel:(BOOL)animated completion:(BlockWithBool)completion;
- (BOOL)	showRootPanel;
- (BOOL)	showRootPanel:(BOOL)animated completion:(BlockWithBool)completion;

@end

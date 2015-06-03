//
//  JFBadge.h
//  JFFramework
//
//  Created by Jacopo Filié on 03/06/15.
//  Copyright (c) 2015 Jacopo Filié. All rights reserved.
//



@interface JFBadge : UIView

#pragma mark Properties

// Relationships
@property (weak, nonatomic, readonly)	UIView*	attachedView;


#pragma mark Methods

// User interface management
- (void)	attachToView:(UIView*)view;

@end

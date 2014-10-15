//
//  JFAttributes.h
//  ADR
//
//  Created by Jacopo Filié on 15/10/14.
//  Copyright (c) 2014 Interlem s.r.l. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface JFViewAttributes : NSObject <NSCopying>

// Background
@property (strong, nonatomic)	UIColor*	backgroundColor;

// Text
@property (strong, nonatomic)	UIColor*	textColor;
@property (strong, nonatomic)	UIFont*		textFont;

@end

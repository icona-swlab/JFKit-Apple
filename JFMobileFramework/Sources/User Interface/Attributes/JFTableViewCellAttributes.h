//
//  JFCellAttributes.h
//  ADR
//
//  Created by Jacopo Filié on 15/10/14.
//  Copyright (c) 2014 Interlem s.r.l. All rights reserved.
//



#import "JFViewAttributes.h"



@interface JFTableViewCellAttributes : JFViewAttributes

// Indentation
@property (assign, nonatomic)	NSInteger	indentationLevel;
@property (assign, nonatomic)	CGFloat		indentationWidth;

// Selection
@property (assign, nonatomic)	UITableViewCellSelectionStyle	selectionStyle;

// Text
@property (strong, nonatomic)	UIColor*	detailTextColor;
@property (strong, nonatomic)	UIFont*		detailTextFont;
@property (strong, nonatomic)	UIColor*	highlightedDetailTextColor;
@property (strong, nonatomic)	UIColor*	highlightedTextColor;


@end

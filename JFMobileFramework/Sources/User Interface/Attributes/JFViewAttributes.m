//
//  JFAttributes.m
//  ADR
//
//  Created by Jacopo Filié on 15/10/14.
//  Copyright (c) 2014 Interlem s.r.l. All rights reserved.
//



#import "JFViewAttributes.h"



@implementation JFViewAttributes

#pragma mark - Properties

// Background
@synthesize backgroundColor	= _backgroundColor;

// Text
@synthesize textColor	= _textColor;
@synthesize textFont	= _textFont;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFViewAttributes* retVal = [[[self class] allocWithZone:zone] init];
	if(retVal)
	{
		// Background
		retVal->_backgroundColor = _backgroundColor;
		
		// Text
		retVal->_textColor = _textColor;
		retVal->_textFont = _textFont;
	}
	return retVal;
}

@end

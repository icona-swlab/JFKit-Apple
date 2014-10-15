//
//  JFCellAttributes.m
//  ADR
//
//  Created by Jacopo Filié on 15/10/14.
//  Copyright (c) 2014 Interlem s.r.l. All rights reserved.
//



#import "JFTableViewCellAttributes.h"



@implementation JFTableViewCellAttributes

#pragma mark - Properties

// Indentation
@synthesize indentationLevel	= _indentationLevel;
@synthesize indentationWidth	= _indentationWidth;

// Selection
@synthesize selectionStyle	= _selectionStyle;

// Text
@synthesize detailTextColor				= _detailTextColor;
@synthesize detailTextFont				= _detailTextFont;
@synthesize highlightedDetailTextColor	= _highlightedDetailTextColor;
@synthesize highlightedTextColor		= _highlightedTextColor;


#pragma mark - Memory management

- (instancetype)copyWithZone:(NSZone*)zone
{
	JFTableViewCellAttributes* retVal = [super copyWithZone:zone];
	if(retVal)
	{
		// Indentation
		retVal->_indentationLevel = _indentationLevel;
		retVal->_indentationWidth = _indentationWidth;
		
		// Selection
		retVal->_selectionStyle = _selectionStyle;
		
		// Text
		retVal->_detailTextColor = _detailTextColor;
		retVal->_detailTextFont = _detailTextFont;
		retVal->_highlightedDetailTextColor = _highlightedDetailTextColor;
		retVal->_highlightedTextColor = _highlightedTextColor;
	}
	return retVal;
}

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		// Indentation
		_indentationLevel = 0;
		_indentationWidth = 10.0f;
		
		// Selection
		_selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	return self;
}

@end

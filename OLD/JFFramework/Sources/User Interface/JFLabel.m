//
//  JFLabel.m
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



#import "JFLabel.h"

#import "JFUtilities.h"



@interface JFLabel ()

@end



#pragma mark



@implementation JFLabel

#pragma mark Properties accessors (Data)

- (void)setText:(NSString*)text
{
	// FIX: Whitespaces and newline characters may corrupt the text drawing up to iOS6.
	if(!iOS7Plus)
	{
		NSCharacterSet* set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		text = [text stringByTrimmingCharactersInSet:set];
	}
	
	[super setText:text];
}


#pragma mark User interface management (Lifecycle)

- (void)layoutSubviews
{
	[super layoutSubviews];
 
	// Updates the 'preferredMaxLayoutWidth' property if this is a multiline label.
	if(self.numberOfLines != 1)
	{
		CGFloat width = CGRectGetWidth(self.frame);
		if(self.preferredMaxLayoutWidth != width)
		{
			self.preferredMaxLayoutWidth = width; // FIX: if the frame of the label changes, this property is not automatically updated.
			[self setNeedsUpdateConstraints];
		}
	}
}


#pragma mark User interface management (Metrics)

- (CGSize)intrinsicContentSize
{
	CGSize retVal = [super intrinsicContentSize];
 
	// Applys the fix if this is a multiline label.
	if(self.numberOfLines != 1)
		retVal.height += 1; // FIX: sometimes the intrinsic content size is 1 point too short.
 
	return retVal;
}

@end

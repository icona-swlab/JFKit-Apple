//
//  JFColor.m
//  Copyright (C) 2015 Jacopo Filié
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



#import "JFColor.h"



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

UInt8 const JFColor8ComponentMaxValue	= 0x3;
UInt8 const JFColor16ComponentMaxValue	= 0xF;
UInt8 const JFColor32ComponentMaxValue	= 0xFF;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

JFColor* JFColorWithComponents(JFColor32Components components)
{
	return JFColorWithComponents32(components);
}

JFColor* JFColorWithComponents8(JFColor8Components components)
{
	UInt8 red	= components.red;
	UInt8 green	= components.green;
	UInt8 blue	= components.blue;
	UInt8 alpha	= components.alpha;
	
	return JFColorWithRGBA(red, green, blue, alpha);
}

JFColor* JFColorWithComponents16(JFColor16Components components)
{
	UInt8 red	= components.red;
	UInt8 green	= components.green;
	UInt8 blue	= components.blue;
	UInt8 alpha	= components.alpha;
	
	return JFColorWithRGBA(red, green, blue, alpha);
}

JFColor* JFColorWithComponents32(JFColor32Components components)
{
	UInt8 red	= components.red;
	UInt8 green	= components.green;
	UInt8 blue	= components.blue;
	UInt8 alpha	= components.alpha;
	
	return JFColorWithRGBA(red, green, blue, alpha);
}

JFColor* JFColorWithHex(unsigned int value)
{
	JFColor32 color;
	color.value = value;
	
	return JFColorWithComponents(color.components);
}

JFColor* JFColorWithHexString(NSString* string)
{
	if(JFStringIsNullOrEmpty(string))
		return nil;
	
	NSScanner* scanner = [NSScanner scannerWithString:string];
	scanner.scanLocation = ([string hasPrefix:@"#"] ? 1 : 0);
	
	unsigned int value;
	if(![scanner scanHexInt:&value])
		return nil;
	
	return JFColorWithHex(value);
}

JFColor* JFColorWithRGB(UInt8 r, UInt8 g, UInt8 b)
{
	return JFColorWithRGBA(r, g, b, UCHAR_MAX);
}

JFColor* JFColorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a)
{
	CGFloat maxValue = UCHAR_MAX;
	
	CGFloat red		= (CGFloat)r / maxValue;
	CGFloat green	= (CGFloat)g / maxValue;
	CGFloat blue	= (CGFloat)b / maxValue;
	CGFloat alpha	= (CGFloat)a / maxValue;
	
#if TARGET_OS_IPHONE
	return [JFColor colorWithRed:red green:green blue:blue alpha:alpha];
#else
	return [JFColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
#endif
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

@implementation JFColor (JFFramework)

#pragma mark Utilities management

#if TARGET_OS_IPHONE

- (BOOL)isEqualToColor:(UIColor*)color
{
	if(!color)
		return NO;
	
	if(self == color)
		return YES;
	
	// TODO: implement color conversion to compare colors that differ in spaces or models.
	//	UIColor* (^convertToRGBSpace)(UIColor*) = ^UIColor*(UIColor* color)
	//	{
	//		if(!color)
	//			return nil;
	//
	//		CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
	//		if(colorSpaceModel == kCGColorSpaceModelRGB)
	//			return color;
	//
	//		CGFloat red, green, blue, alpha;
	//		if(![color getRed:&red green:&green blue:&blue alpha:&alpha])
	//			return nil;
	//
	//		return [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
	//	};
	//
	//	UIColor* cColor1 = convertToRGBSpace(self);
	//	UIColor* cColor2 = convertToRGBSpace(color);
	
	UIColor* cColor1 = self;
	UIColor* cColor2 = color;
	
	return CGColorEqualToColor(cColor1.CGColor, cColor2.CGColor);
}

#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

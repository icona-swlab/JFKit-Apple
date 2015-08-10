//
//  JFColor.h
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



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Macros

#define JFColorAlpha(_val)		JFColorWithRGBA(0, 0, 0, _val)
#define JFColorBlue(_val)		JFColorWithRGB(0, 0, _val)
#define JFColorCyan(_val)		JFColorWithRGB(0, _val, _val)
#define JFColorGray(_val)		JFColorWithRGB(_val, _val, _val)
#define JFColorGreen(_val)		JFColorWithRGB(0, _val, 0)
#define JFColorMagenta(_val)	JFColorWithRGB(_val, 0, _val)
#define JFColorRed(_val)		JFColorWithRGB(_val, 0, 0)
#define JFColorYellow(_val)		JFColorWithRGB(_val, _val, 0)

#if TARGET_OS_IPHONE
#define JFColor	UIColor
#else
#define JFColor	NSColor
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Typedefs

typedef struct {
	UInt8	red		: 2;
	UInt8	green	: 2;
	UInt8	blue	: 2;
	UInt8	alpha	: 2;
} JFColor8Components;

typedef struct {
	UInt8	red		: 4;
	UInt8	green	: 4;
	UInt8	blue	: 4;
	UInt8	alpha	: 4;
} JFColor16Components;

typedef struct {
	UInt8	red		: 8;
	UInt8	green	: 8;
	UInt8	blue	: 8;
	UInt8	alpha	: 8;
} JFColor32Components;

typedef union {
	JFColor8Components	components;
	UInt8				value;
} JFColor8;

typedef union {
	JFColor16Components	components;
	UInt16				value;
} JFColor16;

typedef union {
	JFColor32Components	components;
	UInt32				value;
} JFColor32;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Constants

FOUNDATION_EXPORT UInt8 const JFColor8ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColor16ComponentMaxValue;
FOUNDATION_EXPORT UInt8 const JFColor32ComponentMaxValue;

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Functions

FOUNDATION_EXPORT JFColor*	JFColorWithComponents(JFColor32Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithComponents8(JFColor8Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithComponents16(JFColor16Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithComponents32(JFColor32Components components);
FOUNDATION_EXPORT JFColor*	JFColorWithHex(unsigned int value);
FOUNDATION_EXPORT JFColor*	JFColorWithHexString(NSString* string);
FOUNDATION_EXPORT JFColor*	JFColorWithRGB(UInt8 r, UInt8 g, UInt8 b);
FOUNDATION_EXPORT JFColor*	JFColorWithRGBA(UInt8 r, UInt8 g, UInt8 b, UInt8 a);

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark

@interface JFColor (JFFramework)

#pragma mark Methods

// Utilities management
#if TARGET_OS_IPHONE
- (BOOL)	isEqualToColor:(UIColor*)color;
#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

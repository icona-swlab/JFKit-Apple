//
//  JFRatingView.h
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



@class JFRatingView;



@protocol JFRatingViewDelegate <NSObject>

@required

- (void)	ratingView:(JFRatingView*)ratingView didChangeValue:(CGFloat)value;

@end



#pragma mark



@interface JFRatingView : UIView

#pragma mark Properties

// Attributes
@property (assign, nonatomic)	CGFloat	maximumValue;
@property (assign, nonatomic)	CGFloat	minimumValue;

// Attributes (Images)
@property (assign, nonatomic)	UIEdgeInsets		contentInsets;
@property (assign, nonatomic)	UIViewContentMode	imageContentMode;
@property (assign, nonatomic)	CGSize				imageMaximumSize;	// Ignored if set to "CGSizeZero".
@property (assign, nonatomic)	CGSize				imageMinimumSize;	// Ignored if set to "CGSizeZero".
@property (assign, nonatomic)	CGFloat				imagesDistance;
@property (assign, nonatomic)	NSUInteger			numberOfImages;

// Data
@property (assign, nonatomic)	CGFloat	value;

// Data (Images)
@property (strong, nonatomic)	UIImage*	emptyImage;
@property (strong, nonatomic)	UIImage*	fullImage;
@property (strong, nonatomic)	UIImage*	halfImage;

// Flags
@property (assign, nonatomic, readonly)				BOOL	allowsHalfRatings;
@property (assign, nonatomic, getter = isEditable)	BOOL	editable;

// Relationships
@property (weak, nonatomic)	id<JFRatingViewDelegate>	delegate;


#pragma mark Methods

// User interface management
- (void)	initializeUserInterface;

@end

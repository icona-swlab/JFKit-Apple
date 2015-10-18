//
//  JFRatingView.h
//  JFFramework
//
//  Created by Jacopo Filié on 17/10/15.
//
//



@class JFRatingView;



@protocol JFRatingViewDelegate <NSObject>

@optional

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

// Data
@property (assign, nonatomic)	CGFloat	value;

// Data (Images)
@property (strong, nonatomic)	UIImage*	emptyImage;
@property (strong, nonatomic)	UIImage*	fullImage;
@property (strong, nonatomic)	UIImage*	halfImage;	// Ignored if "allowsHalfRatings" is "NO".

// Flags
@property (assign, nonatomic)						BOOL	allowsHalfRatings;
@property (assign, nonatomic, getter = isEditable)	BOOL	editable;

// Relationships
@property (weak, nonatomic)	id<JFRatingViewDelegate>	delegate;

@end

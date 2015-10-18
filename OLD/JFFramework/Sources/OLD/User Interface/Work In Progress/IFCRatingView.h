//
//  IFCRatingView.h
//  Rockol
//
//  Created by Jacopo Filié on 20/11/12.
//  Copyright (c) 2012 Icona s.r.l. All rights reserved.
//



@class IFCRatingView;



@protocol IFCRateViewDelegate <NSObject>

@optional

- (void)	rateView:(IFCRatingView*)rateView ratingDidChange:(float)rating;

@end



typedef enum {
	IFCRateViewStyleDefault,
	IFCRateViewStyleCustom
} IFCRateViewStyle;


@interface IFCRatingView : UIView

// Attributes
@property (assign, nonatomic)	BOOL				allowsHalfVotes;
@property (assign, nonatomic)	BOOL				editable;
@property (assign, nonatomic)	CGFloat				minRating;
@property (assign, nonatomic)	NSUInteger			maxRating;
@property (assign, nonatomic)	IFCRateViewStyle	style;

// Data
@property (assign, nonatomic)	float	rating;

// Layout
@property (assign, nonatomic)	NSInteger	imageContentMode;
@property (retain, nonatomic)	UIImage*	imageFullSelected;	// Used only if the style is set to 'custom'.
@property (retain, nonatomic)	UIImage*	imageHalfSelected;	// Used only if the style is set to 'custom'.
@property (retain, nonatomic)	UIImage*	imageNotSelected;	// Used only if the style is set to 'custom'.
@property (assign, nonatomic)	CGSize		imagesMaxSize;		// Setting CGSizeZero removes the limit.
@property (assign, nonatomic)	CGFloat		imagesMiddleMargins;
@property (assign, nonatomic)	CGSize		imagesMinSize;		// Setting CGSizeZero removes the limit.
@property (assign, nonatomic)	CGFloat		imagesSideMargins;

// Targets
@property (assign, nonatomic)	IBOutlet id<IFCRateViewDelegate>	delegate;

@end

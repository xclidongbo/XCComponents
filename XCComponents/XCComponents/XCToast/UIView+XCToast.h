//
//  UIView+XCToast.h
//  Test_UPTextField
//
//  Created by 李东波 on 13/6/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCToastStyle;
@interface UIView (XCToast)

extern const NSString * XCToastPositionTop;
extern const NSString * XCToastPositionCenter;
extern const NSString * XCToastPositionBottom;



- (void)xc_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title style:(XCToastStyle *)style completion:(void(^)(BOOL didTap))completion;


- (void)xc_makeToastActivity:(id)position style:(XCToastStyle *)style;

- (void)xc_hideToastActivity;

@end


@class XCToastStyle;
@interface XCToastManager : NSObject


+ (instancetype)sharedManager;

+ (void)setSharedStyle:(XCToastStyle *)sharedStyle ;

+ (XCToastStyle *)sharedStyle ;

+ (void)setTapToDismissEnabled:(BOOL)TapToDismissEnabled ;

+ (BOOL)isTapToDismissEnabled ;

+ (void)setDefaultDuration:(NSTimeInterval)defaultDuration ;

+ (NSTimeInterval)defaultDuration ;


+ (void)setDefaultPosition:(id)defaultPosition ;
+ (id)defaultPosition ;
@end


@interface XCToastStyle : NSObject

@property (nonatomic, strong) UIColor * backgroundColor;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * messageColor;
@property (nonatomic, assign) CGFloat maxWidthPercentage;
@property (nonatomic, assign) CGFloat maxHeightPercentage;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIFont * messageFont;
@property (nonatomic, assign) NSTextAlignment titleAlignment;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
@property (nonatomic, assign) NSInteger titleNumberOfLines;
@property (nonatomic, assign) NSInteger messageNumberOfLines;
@property (nonatomic, assign) BOOL displayShadow;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGSize activitySize;
@property (nonatomic, assign) CGFloat fadeDuration;

@property (nonatomic, assign) BOOL displayGradient;
@property (nonatomic, strong) NSArray * grdientColors;
@property (nonatomic, strong) NSArray <NSNumber *>* locations;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

//    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
//    UIColor * startColor = [UIColor colorWithRed:234/255.0 green:131/255.0 blue:109/255.0 alpha:1];
//    UIColor * endColor = [UIColor colorWithRed:240/255.0 green:154/255.0 blue:125/255.0 alpha:1];
//    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
//    gradientLayer.locations = @[@0.0, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);;
//    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
//    gradientLayer.frame = wrapperView.bounds;
//    [wrapperView.layer addSublayer: gradientLayer];

- (instancetype)initWithDefaultStyle NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

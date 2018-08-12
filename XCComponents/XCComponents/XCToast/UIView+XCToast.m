//
//  UIView+XCToast.m
//  Test_UPTextField
//
//  Created by 李东波 on 13/6/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "UIView+XCToast.h"
#import <objc/runtime.h>

static char  CSToastCompletionKey;
static char CSToastTimerKey;

// Positions
NSString * XCToastPositionTop                       = @"XCToastPositionTop";
NSString * XCToastPositionCenter                    = @"XCToastPositionCenter";
NSString * XCToastPositionBottom                    = @"XCToastPositionBottom";
NSString * CSToastActivityViewKey                   = @"CSToastActivityViewKey";


@implementation UIView (XCToast)


- (void)xc_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title style:(XCToastStyle *)style completion:(void(^)(BOOL didTap))completion {
    UIView *toast = [self xc_toastViewForMessage:message title:title style:style];
    [self xc_showToast:toast duration:duration position:position completion:completion];
}

- (UIView *)xc_toastViewForMessage:(NSString *)message title:(NSString *)title style:(XCToastStyle*)style {
    
    if (message == nil && title == nil ) return nil;
    
    if (style == nil) {
        style = [XCToastManager sharedStyle];
    }
    
    UILabel * messageLabel = nil;
    UILabel * titleLabel = nil;
    UIView * wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = style.cornerRadius;
//    wrapperView.layer.masksToBounds = YES;
    
    if (style.displayShadow) {
        wrapperView.layer.shadowColor = style.shadowColor.CGColor;
        wrapperView.layer.shadowOpacity = style.shadowOpacity;
        wrapperView.layer.shadowRadius = style.shadowRadius;
        wrapperView.layer.shadowOffset = style.shadowOffset;
    }
    
    wrapperView.backgroundColor = style.backgroundColor;
    
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = style.titleNumberOfLines;
        titleLabel.font = style.titleFont;
        titleLabel.textAlignment = style.titleAlignment;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = style.titleColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        CGSize maxSizeTitle = CGSizeMake(self.bounds.size.width * style.maxWidthPercentage, self.bounds.size.height * style.maxHeightPercentage);
        CGSize expectedSizeTitle = [titleLabel sizeThatFits:maxSizeTitle];
        expectedSizeTitle = CGSizeMake(MIN(maxSizeTitle.width, expectedSizeTitle.width), MIN(maxSizeTitle.height, expectedSizeTitle.height));
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = style.messageNumberOfLines;
        messageLabel.font = style.messageFont;
        messageLabel.textAlignment = style.messageAlignment;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        messageLabel.textColor = style.messageColor;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        CGSize maxSizeMessage = CGSizeMake(self.bounds.size.width * style.maxWidthPercentage, self.bounds.size.height * style.maxHeightPercentage);
        CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    CGRect titleRect = CGRectZero;
    
    if (titleLabel != nil) {
        titleRect.origin.x = style.horizontalPadding;
        titleRect.origin.y = style.verticalPadding;
        titleRect.size.width = titleLabel.bounds.size.width;
        titleRect.size.height = titleLabel.bounds.size.height;
    }
    
    CGRect messageRect = CGRectZero;
    if (messageLabel != nil) {
        messageRect.origin.x = style.horizontalPadding;
        messageRect.origin.y = titleRect.origin.y +titleRect.size.height+style.verticalPadding;
        messageRect.size.width = messageLabel.bounds.size.width;
        messageRect.size.height = messageLabel.bounds.size.height;
    }
    
    CGFloat longerWidth = MAX(titleRect.size.width, messageRect.size.width);
    CGFloat longerX = MAX(titleRect.origin.x, messageRect.origin.x);
    CGFloat wrapperWidth = longerX + longerWidth + style.horizontalPadding;//水平宽度
    CGFloat wrapperHeight = messageRect.origin.y + messageRect.size.height + style
    .verticalPadding;//垂直长度.
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    
    if (style.displayGradient) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
//        UIColor * startColor = [UIColor colorWithRed:234/255.0 green:131/255.0 blue:109/255.0 alpha:1];
//        UIColor * endColor = [UIColor colorWithRed:240/255.0 green:154/255.0 blue:125/255.0 alpha:1];
//        gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        gradientLayer.colors = style.grdientColors;
        gradientLayer.locations = style.locations;
        gradientLayer.startPoint = style.startPoint;
        gradientLayer.endPoint = style.endPoint;
        gradientLayer.frame = wrapperView.bounds;
        [wrapperView.layer addSublayer: gradientLayer];
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:wrapperView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(style.cornerRadius/2.0, style.cornerRadius/2.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.frame = wrapperView.bounds;
        wrapperView.layer.mask = maskLayer;
    }
    
    if (titleLabel != nil) {
        titleLabel.frame = titleRect;
        [wrapperView addSubview:titleLabel];
    }
    if (messageLabel != nil) {
        messageLabel.frame = messageRect;
        [wrapperView addSubview:messageLabel];
    }
    
    
    
    return wrapperView;
}


- (void)xc_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position completion:(void(^)(BOOL didTap))completion {
    if (toast == nil) return;
    
    objc_setAssociatedObject(toast, &CSToastCompletionKey, completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self xc_showToast:toast duration:duration position:position];
    
}


#pragma mark - Position
- (void)xc_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    toast.center = [self xc_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    
    if ([XCToastManager isTapToDismissEnabled]) {
        //支持tap隐藏
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xc_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    [self addSubview:toast];
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                        toast.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                        NSTimer * timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(xc_toastTimerDidFinish:) userInfo:toast repeats:NO];
                        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                        objc_setAssociatedObject(toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }];
    
}


- (CGPoint)xc_centerPointForPosition:(id)point withToast:(UIView *)toast {
    XCToastStyle * style = [XCToastManager sharedStyle];
    
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeInsets = self.safeAreaInsets;
    }
    CGFloat topPadding = style.verticalPadding + safeInsets.top;
    CGFloat bottomPadding = style.verticalPadding + safeInsets.bottom;
    
    if([point caseInsensitiveCompare:XCToastPositionTop] == NSOrderedSame) {
        return CGPointMake(self.bounds.size.width / 2.0, (toast.frame.size.height / 2.0) + topPadding);
    } else if([point caseInsensitiveCompare:XCToastPositionCenter] == NSOrderedSame) {
        return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    }
    // default to bottom
    return CGPointMake(self.bounds.size.width / 2.0, (self.bounds.size.height - (toast.frame.size.height / 2.0)) - bottomPadding);
}

- (void)xc_handleToastTapped: (UITapGestureRecognizer *)sender {
    UIView *toast = sender.view;
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(toast, &CSToastTimerKey);
    [timer invalidate];
    
    [self xc_hideToast:toast fromTap:YES];
}

- (void)xc_toastTimerDidFinish: (NSTimer *)timer {
    [self xc_hideToast:(UIView *)timer.userInfo];
}

- (void)xc_hideToast:(UIView *)toast {
    [self xc_hideToast:toast fromTap:NO];
}
- (void)xc_hideToast:(UIView *)toast fromTap:(BOOL)fromTap {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(toast, &CSToastTimerKey);
    [timer invalidate];
    
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                         // execute the completion block, if necessary
                         void (^completion)(BOOL didTap) = objc_getAssociatedObject(toast, &CSToastCompletionKey);
                         if (completion) {
                             completion(fromTap);
                         }
                     }];
}

#pragma mark - Gradientlayer

//- (void)addGradientLayerWithColors:(NSArray *)colors
//                         locations:(NSArray <NSNumber *>*)locations
//                        startPoint:(CGPoint)startPoint
//                          endPoint:(CGPoint)endPoint {
//    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = colors;
//    gradientLayer.locations = locations;
//    gradientLayer.startPoint = startPoint;
//    gradientLayer.endPoint = endPoint;
//    gradientLayer.frame = self.bounds;
//    [self.layer addSublayer: gradientLayer];
//}




- (void)xc_makeToastActivity:(id)position style:(XCToastStyle *)style {
    UIView * existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    if (style == nil) {
        style = [XCToastManager sharedStyle];
    }
//    XCToastStyle *style = [XCToastManager sharedStyle];
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, style.activitySize.width, style.activitySize.height)];
    activityView.center = [self xc_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = style.backgroundColor;
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin);
    activityView.layer.cornerRadius = style.cornerRadius;
    
    if (style.displayShadow) {
        activityView.layer.shadowColor = style.shadowColor.CGColor;
        activityView.layer.shadowOpacity = style.shadowOpacity;
        activityView.layer.shadowRadius = style.shadowRadius;
        activityView.layer.shadowOffset = style.shadowOffset;
    }
    if (style.displayGradient) {
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        //        UIColor * startColor = [UIColor colorWithRed:234/255.0 green:131/255.0 blue:109/255.0 alpha:1];
        //        UIColor * endColor = [UIColor colorWithRed:240/255.0 green:154/255.0 blue:125/255.0 alpha:1];
        //        gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        gradientLayer.colors = style.grdientColors;
        gradientLayer.locations = style.locations;
        gradientLayer.startPoint = style.startPoint;
        gradientLayer.endPoint = style.endPoint;
        gradientLayer.frame = activityView.bounds;
        [activityView.layer addSublayer: gradientLayer];
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:activityView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(style.cornerRadius/2.0, style.cornerRadius/2.0)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.frame = activityView.bounds;
        activityView.layer.mask = maskLayer;
    }
    
    
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width/2, activityView.bounds.size.height/2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    objc_setAssociatedObject(self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:activityView];
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        activityView.alpha = 1.0;
    } completion:nil];
}

- (void)xc_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView !=nil) {
        [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
            existingActivityView.alpha = 0;
        } completion:^(BOOL finished) {
            [existingActivityView removeFromSuperview];
            objc_setAssociatedObject(self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    }
}


@end





#pragma mark -
#pragma mark - XCToastManager
@interface XCToastManager ()

@property (nonatomic, strong) XCToastStyle * sharedStyle;
@property (nonatomic, assign, getter=isTapToDismissEnabled)BOOL TapToDismissEnabled;
//@property (nonatomic, assign, getter=isQueueEnabled)BOOL QueueEnabled;
@property (nonatomic, assign) NSTimeInterval defaultDuration;
@property (nonatomic, strong) id defaultPosition;

@end


@implementation XCToastManager

#pragma mark - constructor
+ (instancetype)sharedManager {
    static XCToastManager * _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sharedStyle = [[XCToastStyle alloc] initWithDefaultStyle];
        self.TapToDismissEnabled = YES;
        self.defaultDuration = 3.0;
        self.defaultPosition = XCToastPositionBottom;
    }
    return self;
}

#pragma mark - methods

+ (void)setSharedStyle:(XCToastStyle *)sharedStyle {
    [[self sharedManager] setSharedStyle:sharedStyle];
}

+ (XCToastStyle *)sharedStyle {
    return [[self sharedManager] sharedStyle];
}

+ (void)setTapToDismissEnabled:(BOOL)TapToDismissEnabled {
    [[self sharedManager] setTapToDismissEnabled:TapToDismissEnabled];
}

+ (BOOL)isTapToDismissEnabled {
    return [[self sharedManager] isTapToDismissEnabled];
}

+ (void)setDefaultDuration:(NSTimeInterval)defaultDuration {
    [[self sharedManager] setDefaultDuration:defaultDuration];
}

+ (NSTimeInterval)defaultDuration {
    return [[self sharedManager] defaultDuration];
}


+ (void)setDefaultPosition:(id)defaultPosition {
    if ([defaultPosition isKindOfClass:[NSString class]]) {
        [[self sharedManager] setDefaultPosition:defaultPosition];
    }
    
}
+ (id)defaultPosition {
    return [[self sharedManager] defaultPosition];
}


@end

#pragma mark -
#pragma mark - XCToastStyle

@interface XCToastStyle ()

@end

@implementation XCToastStyle

- (instancetype)initWithDefaultStyle {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.titleColor = [UIColor whiteColor];
        self.messageColor = [UIColor whiteColor];
        self.maxWidthPercentage = 0.8;
        self.maxHeightPercentage = 0.8;
        self.horizontalPadding = 10.0;
        self.verticalPadding = 10.0;
        self.cornerRadius = 10.0;
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.messageFont = [UIFont systemFontOfSize:16.0];
        self.titleAlignment = NSTextAlignmentLeft;
        self.messageAlignment = NSTextAlignmentLeft;
        self.titleNumberOfLines = 0;
        self.messageNumberOfLines = 0;
        self.displayShadow = NO;
        self.shadowOpacity = 0.8;
        self.shadowRadius = 6.0;
        self.shadowOffset = CGSizeMake(4.0, 4.0);
//        self.imageSize = CGSizeMake(80.0, 80.0);
        self.activitySize = CGSizeMake(100.0, 100.0);
        self.fadeDuration = 0.2;
        self.displayGradient = NO;
        
        UIColor * startColor = [UIColor colorWithRed:234/255.0 green:131/255.0 blue:109/255.0 alpha:1];
        UIColor * endColor = [UIColor colorWithRed:240/255.0 green:154/255.0 blue:125/255.0 alpha:1];
        self.grdientColors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        self.locations = @[@0.0,@1.0];
        self.startPoint = CGPointMake(0.0, 0.0);
        self.endPoint = CGPointMake(1.0, 1.0);
    }
    return self;
}

- (void)setMaxWidthPercentage:(CGFloat)maxWidthPercentage {
    _maxWidthPercentage = MAX(MIN(maxWidthPercentage, 1.0), 0);
}

- (void)setMaxHeightPercentage:(CGFloat)maxHeightPercentage {
    _maxHeightPercentage = MAX(MIN(maxHeightPercentage, 1.0), 0);
}
- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

@end


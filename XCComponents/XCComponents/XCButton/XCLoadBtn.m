//
//  XCLoadBtn.m
//  Test_LoadingBtn
//
//  Created by 李东波 on 9/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "XCLoadBtn.h"

@interface XCLoadBtn()
//@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong)CAShapeLayer * shapeLayer;
@property (nonatomic, assign)BOOL hasLayout;
@end

@implementation XCLoadBtn


//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
////    NSLog(@"%@", NSStringFromCGRect(self.bounds));
//    CGFloat centerX = CGRectGetWidth(self.bounds)/2;
//    CGFloat centerY = CGRectGetHeight(self.bounds)/2;
//    CGFloat radius = MIN(centerX, centerY)-20;//圆的半径 开始角度 结束角度
//
//    CGContextSetLineWidth(context, 5);
//    CGContextSetLineCap(context,kCGLineCapRound);
//    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
//    CGContextAddArc(context, centerX, centerY, radius, -M_PI_4, M_PI_2, 1);
//    CGContextDrawPath(context, kCGPathStroke);
//
//}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        if(!_displayLink){
//            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
//            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        }
//
////        CABasicAnimation* rotationAnimation;
////        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
////        rotationAnimation.duration = 2;
////        rotationAnimation.cumulative = YES;
////        rotationAnimation.repeatCount = MAXFLOAT;
////        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    }
//    return self;
//}
//
//- (void)rotate {
//
//    NSLog(@"111");
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//
//
//}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat centerX = CGRectGetWidth(self.bounds)/2;
    CGFloat centerY = CGRectGetHeight(self.bounds)/2;
    CGFloat radius = MIN(centerX, centerY)/2;
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        self.shapeLayer.frame = CGRectMake(centerX-radius, centerY-radius, 2*radius, 2*radius);
        if (_lineWidth) self.shapeLayer.lineWidth = _lineWidth;
        if (_strokeColor) self.shapeLayer.strokeColor = _strokeColor.CGColor;
    }
    if (_hasLayout) {
        return;
    }
    _hasLayout = YES;
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
//    CGFloat centerX = CGRectGetWidth(self.bounds)/2;
//    CGFloat centerY = CGRectGetHeight(self.bounds)/2;
//    CGFloat radius = MIN(centerX, centerY)/2;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_4 endAngle:M_PI clockwise:YES];
//    [bezierPath stroke];
    
    CAShapeLayer * subLayer = [[CAShapeLayer alloc] init];
    subLayer.path = bezierPath.CGPath;
    subLayer.strokeColor = [UIColor whiteColor].CGColor;
    subLayer.fillColor = [UIColor clearColor].CGColor;
    subLayer.lineWidth = 5;
    subLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:subLayer];
    subLayer.frame = CGRectMake(centerX-radius, centerY-radius, 2*radius, 2*radius);
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    if (!self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    self.shapeLayer = subLayer;

    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = LONG_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [subLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    self.showLoading = NO;
}




- (void)setShowLoading:(BOOL)showLoading {
    if (showLoading) {
        self.shapeLayer.opacity = 1;
        self.titleLabel.layer.opacity = 0;
        self.enabled = NO;
        self.alpha = 0.5;
    } else {
        self.shapeLayer.opacity = 0;
        self.titleLabel.layer.opacity = 1;
        self.enabled = YES;
        self.alpha = 1;
    }
    _showLoading = showLoading;
}

//- (void)setLineWidth:(CGFloat)lineWidth {
//    self.shapeLayer.lineWidth = lineWidth;
//    _lineWidth = lineWidth;
//}

@end

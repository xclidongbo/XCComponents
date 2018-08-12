//
//  GUStyles.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "GUStyles.h"

@implementation GUStyles

- (instancetype)initWithDefaultStyle
{
    self = [super init];
    if (self) {
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSString * resourcePath = [frameworkBundle pathForResource:@"GestureUnlock" ofType:@"bundle"];
        NSBundle * resourceBundle = [NSBundle bundleWithPath:resourcePath];
        
        //设置
        self.normalImg = [UIImage imageNamed:@"gesture_default" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        self.connectImg = [UIImage imageNamed:@"gesture_through" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        self.errorImg = [UIImage imageNamed:@"gesture_error" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        
        self.lineNormalColor = [UIColor colorWithRed:8/255.0 green:163/255.0 blue:238/255.0 alpha:1];
        self.lineErrorColor = [UIColor redColor];
        self.lineWidth = 2.0;
        self.row = 3;
        self.column = 3;
    }
    return self;
}


- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}


@end

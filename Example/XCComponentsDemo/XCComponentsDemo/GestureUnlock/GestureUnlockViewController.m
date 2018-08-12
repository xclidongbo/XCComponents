//
//  GestureUnlockViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "GestureUnlockViewController.h"
#import "UIColor+XCAdd.h"
#import <XCComponents/XCComponents.h>

@interface GestureUnlockViewController ()

@property (nonatomic, strong)GestureUnlockView * unlockView;

@end

@implementation GestureUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWithHex(0xEEEEEE);
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.unlockView = [[GestureUnlockView alloc] init];
    self.unlockView.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:_unlockView];
    self.unlockView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 300, 100, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"显示轨迹" forState:UIControlStateNormal];
    [btn setTitle:@"隐藏轨迹" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = [GUManager showGestureTrack];
    
    
    [GUManager gestureUnlockComplete:^(GestureUnlockView *sender, NSString *gesturePwd) {
        NSLog(@"密码: %@", gesturePwd);
    }];
    
    
}

- (void)btnClick:(UIButton *)sender {
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    [GUManager setGestureTrackStatus:btn.selected];
}


@end

//
//  ButtonViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "ButtonViewController.h"
#import "UIColor+XCAdd.h"
#import <XCComponents/XCComponents.h>

@interface ButtonViewController ()



@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWithHex(0xEEEEEE);
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    XCLoadBtn *btn = [[XCLoadBtn alloc] init];
    [self.view addSubview:btn];
    
    btn.translatesAutoresizingMaskIntoConstraints =false;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"模拟请求" forState:UIControlStateNormal];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btn]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btn(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)btnClick:(XCLoadBtn *)sender {
    sender.showLoading = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.showLoading = NO;
    });
}



@end

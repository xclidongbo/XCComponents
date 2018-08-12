//
//  ToastViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "ToastViewController.h"
#import "UIColor+XCAdd.h"
#import <XCComponents/XCComponents.h>

@interface ToastViewController ()

@end

@implementation ToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWithHex(0xEEEEEE);
    
    UIButton * delayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:delayBtn];
    
    UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:showBtn];
    
    UIButton * hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:hideBtn];
    
    [delayBtn setTitle:@"延迟消失" forState:UIControlStateNormal];
    [showBtn setTitle:@"显示" forState:UIControlStateNormal];
    [hideBtn setTitle:@"消失" forState:UIControlStateNormal];
    delayBtn.backgroundColor = [UIColor blueColor];
    showBtn.backgroundColor = [UIColor blueColor];
    hideBtn.backgroundColor = [UIColor blueColor];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    delayBtn.translatesAutoresizingMaskIntoConstraints = false;
    showBtn.translatesAutoresizingMaskIntoConstraints = false;
    hideBtn.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[delayBtn]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delayBtn,showBtn,hideBtn)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[showBtn]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delayBtn,showBtn,hideBtn)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[hideBtn]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delayBtn,showBtn,hideBtn)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[delayBtn(30)]-(20)-[showBtn(delayBtn)]-(20)-[hideBtn(delayBtn)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(delayBtn,showBtn,hideBtn)]];
    
    [delayBtn addTarget:self action:@selector(delayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [hideBtn addTarget:self action:@selector(hideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)delayBtnClick {
    [self.view xc_makeToast:@"message" duration:2.0 position:XCToastPositionTop title:@"title" style:nil completion:^(BOOL didTap) {
        NSLog(@"完成结束");
    }];
}
- (void)showBtnClick {
    [self.view xc_makeToastActivity:XCToastPositionTop style:nil];
}
- (void)hideBtnClick {
    [self.view xc_hideToastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

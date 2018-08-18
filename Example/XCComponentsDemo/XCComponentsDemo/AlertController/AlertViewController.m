//
//  AlertViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "AlertViewController.h"
#import "UIColor+XCAdd.h"
#import <XCComponents/XCComponents.h>

@interface AlertViewController ()

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = UIColorWithHex(0xEEEEEE);
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn1];
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn2];
    
    btn1.backgroundColor = [UIColor blueColor];
    btn2.backgroundColor = [UIColor blueColor];
    
    [btn1 setTitle:@"alert" forState:UIControlStateNormal];
    [btn2 setTitle:@"sheet" forState:UIControlStateNormal];
    
    btn1.translatesAutoresizingMaskIntoConstraints = false;
    btn2.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[btn1(btn2)]-[btn2]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn1,btn2)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btn1(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn1,btn2)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btn2(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn1,btn2)]];
    
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btn1Click:(UIButton *)sender {
    
    
    XCAlertViewController * alertVC = [XCAlertViewController alertControllerWithTitle:@"标题" message:@"message" preferredStyle:XCAlertControllerStyleAlert];
    
    XCAlertAction * action = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    
    XCAlertAction * action1 = [XCAlertAction actionWithTitle:@"破坏" style:XCAlertActionStyleDestructive handler:^(XCAlertAction *action) {
        NSLog(@"破坏");
    }];
    XCAlertAction * action2 = [XCAlertAction actionWithTitle:@"取消" style:XCAlertActionStyleCancel handler:^(XCAlertAction *action) {
        NSLog(@"取消");
    }];
    XCAlertAction * action3 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action4 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action5 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action6 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    
    [alertVC addAction:action2];
    [alertVC addAction:action];
    [alertVC addAction:action1];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    [alertVC addAction:action6];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"取消");
//    }];
//    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"默认");
//    }];
//
//    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action6 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    action2.enabled = NO;
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController addAction:action3];
//    [alertController addAction:action4];
//    [alertController addAction:action5];
//    [alertController addAction:action6];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)btn2Click:(UIButton *)sender {
    
    XCAlertViewController * alertVC = [XCAlertViewController alertControllerWithTitle:@"标题" message:@"message" preferredStyle:XCAlertControllerStyleActionSheet];
    
    XCAlertAction * action = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    
    XCAlertAction * action1 = [XCAlertAction actionWithTitle:@"破坏" style:XCAlertActionStyleDestructive handler:^(XCAlertAction *action) {
        NSLog(@"破坏");
    }];
    XCAlertAction * action2 = [XCAlertAction actionWithTitle:@"取消" style:XCAlertActionStyleCancel handler:^(XCAlertAction *action) {
        NSLog(@"取消");
    }];
    XCAlertAction * action3 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action4 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action5 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    XCAlertAction * action6 = [XCAlertAction actionWithTitle:@"默认" style:XCAlertActionStyleDefault handler:^(XCAlertAction *action) {
        NSLog(@"默认");
    }];
    
    [alertVC addAction:action2];
    [alertVC addAction:action];
    [alertVC addAction:action1];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    [alertVC addAction:action6];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"取消");
//    }];
//    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"默认");
//    }];
//
//    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    UIAlertAction * action6 = [UIAlertAction actionWithTitle:@"破坏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"破坏");
//    }];
//    action2.enabled = NO;
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [alertController addAction:action3];
//    [alertController addAction:action4];
//    [alertController addAction:action5];
//    [alertController addAction:action6];
//    [self presentViewController:alertController animated:YES completion:nil];
}

@end
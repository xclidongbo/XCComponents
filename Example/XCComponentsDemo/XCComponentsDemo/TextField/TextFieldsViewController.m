//
//  TextFieldsViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "TextFieldsViewController.h"
#import <XCComponents/FloatTextField.h>
#import <XCComponents/AutoCompleteFloatTextField.h>
@interface TextFieldsViewController ()

@property (nonatomic, strong)UITextField * textField;

@end

@implementation TextFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    switch (_textFieldType) {
        case NSTextFieldTypeFloat:
        {
            FloatTextField * textField = [[FloatTextField alloc] init];
            textField.animationText = @"密码";
            textField.placeholder = @"请输入密码";
            _textField = textField;
        }
            break;
        case NSTextFieldTypeAutoComplete:
        {
            AutoCompleteFloatTextField *textField = [[AutoCompleteFloatTextField alloc] init];
            textField.animationText = @"手机号";
            textField.placeholder = @"请输入手机号";
            textField.sourceData = @[
                                     @"13500000001",
                                     @"13500000002",
                                     @"13500000003",
                                     @"15000000001",
                                     @"15100000001"
                                     ];
            _textField = textField;
        }
            break;
        default:
            break;
    }
    
    _textField.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:_textField];
    self.textField.translatesAutoresizingMaskIntoConstraints = false;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:30].active = YES;
    [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10].active = YES;
    [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10].active = YES;
    [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30].active = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"view: %@", NSStringFromCGRect(self.view.frame));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

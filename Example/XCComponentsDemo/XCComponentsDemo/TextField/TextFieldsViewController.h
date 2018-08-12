//
//  TextFieldsViewController.h
//  XCComponentsDemo
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NSTextFieldType) {
    NSTextFieldTypeFloat,
    NSTextFieldTypeAutoComplete,
};

@interface TextFieldsViewController : UIViewController

@property (nonatomic, assign)NSTextFieldType textFieldType;

@end

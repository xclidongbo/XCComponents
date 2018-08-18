//
//  XCComponents.h
//  XCComponents
//
//  Created by 李东波 on 11/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<XCComponents/XCComponents.h>)
//! Project version number for XCComponents.
FOUNDATION_EXPORT double XCComponentsVersionNumber;

//! Project version string for XCComponents.
FOUNDATION_EXPORT const unsigned char XCComponentsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <XCComponents/PublicHeader.h>
#import <XCComponents/FloatTextField.h>
#import <XCComponents/AutoCompleteFloatTextField.h>
#import <XCComponents/XCLoadBtn.h>
#import <XCComponents/UIView+XCToast.h>
#import <XCComponents/GestureUnlockView.h>
#import <XCComponents/XCAlertViewController.h>
#else
#import "FloatTextField.h"
#import "AutoCompleteFloatTextField.h"
#import "XCLoadBtn.h"
#import "UIView+XCToast.h"
#import "GestureUnlockView.h"
#import "XCAlertViewController.h"
#endif

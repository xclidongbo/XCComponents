//
//  XCAlertViewController.h
//  XCComponents
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XCAlertActionStyle) {
    XCAlertActionStyleDefault = 0,
    XCAlertActionStyleCancel,
    XCAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, XCAlertControllerStyle) {
    XCAlertControllerStyleActionSheet = 0,
    XCAlertControllerStyleAlert
};

@interface XCAlertAction: NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XCAlertActionStyle)style handler:(void (^ __nullable)(XCAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) XCAlertActionStyle style;
//@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface XCAlertViewController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XCAlertControllerStyle)preferredStyle;
- (void)addAction:(XCAlertAction *)action;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) XCAlertControllerStyle preferredStyle;

@end






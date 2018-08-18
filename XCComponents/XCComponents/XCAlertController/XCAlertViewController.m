//
//  XCAlertViewController.m
//  XCComponents
//
//  Created by 李东波 on 12/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "XCAlertViewController.h"
#import <objc/runtime.h>


static char kActionHandleKey;
static char kActionBtnClckKey;
static char kActionBtnClckBlockKey;

static char kActionBtnLeftClckKey;
static char kActionBtnLeftClckBlockKey;
static char kActionBtnRightClckKey;
static char kActionBtnRightClckBlockKey;


@interface UIImage (XCAdd)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end


@implementation UIImage (XCAdd)
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@interface UIColor (XCAdd)
+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
@end

@implementation UIColor (XCAdd)

+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue {
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

@end



@interface ActionItem: UIButton

@property (nonatomic, readwrite) XCAlertActionStyle style;
@property (nonatomic, readwrite) NSString * title;

@end


@implementation ActionItem
@dynamic title;

- (void)setStyle:(XCAlertActionStyle)style {
    UIColor * normalColor;
    switch (style) {
        case XCAlertActionStyleCancel:
            {
                normalColor = [UIColor blueColor];
            }
            break;
        case XCAlertActionStyleDestructive:
            {
                normalColor = [UIColor redColor];
            }
            break;
        default:
            {
                normalColor = [UIColor blackColor];
            }
            break;
    }
    [self setTitleColor:normalColor forState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}


@end



@interface XCAlertAction ()

@property (nullable, nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) XCAlertActionStyle style;
@end

@implementation XCAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XCAlertActionStyle)style handler:(void (^ __nullable)(XCAlertAction *action))handler {
    XCAlertAction * alertAction = [[XCAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    objc_setAssociatedObject(alertAction, &kActionHandleKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return alertAction;
}


@end


#pragma mark - tableView cell

@interface SignleItemCell: UITableViewCell

@property (nonatomic, strong)ActionItem * actionItem;
@property (nonatomic, strong)UIView * lineView;
@property (nonatomic, strong)NSLayoutConstraint *lineHeightConst;

- (void)btnClickWithBlock:(void(^)(ActionItem * sender))senderBlock;
- (void)actionSheetLastCell:(BOOL)isLast;
@end

@implementation SignleItemCell
static CGFloat const lineViewHeight = 0.5;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubView];
    }
    return self;
}

- (void)configureSubView {
    _actionItem = [ActionItem buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_actionItem];
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    
    [_actionItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionItem setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xEEEEEE alpha:1]] forState:UIControlStateNormal];
    [_actionItem setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xDDDDDD alpha:1]] forState:UIControlStateHighlighted];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    
    _actionItem.translatesAutoresizingMaskIntoConstraints = false;
    _lineView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_actionItem]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_actionItem)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lineView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_lineView]-(0)-[_actionItem]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_actionItem,_lineView)]];
    [NSLayoutConstraint constraintWithItem:_actionItem attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44].active = YES;
    _lineHeightConst = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:lineViewHeight];
    _lineHeightConst.active = YES;
    
    [_actionItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionSheetLastCell:(BOOL)isLast {
    if (isLast) {
        _lineHeightConst.constant = 5;
    } else {
        _lineHeightConst.constant = lineViewHeight;
    }
}

- (void)setValueWithItem:(XCAlertAction *)action {
    _actionItem.title = action.title;
    _actionItem.style = action.style;
    objc_setAssociatedObject(self, &kActionBtnClckKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)btnClick:(ActionItem *)sender {
    XCAlertAction * action = objc_getAssociatedObject(self, &kActionBtnClckKey);
    void((^actionBlock)(XCAlertAction *action)) = objc_getAssociatedObject(action, &kActionHandleKey);
    if (actionBlock)actionBlock(action);
    
    void(^senderBlock)(ActionItem *sender) = objc_getAssociatedObject(self, &kActionBtnClckBlockKey);
    if (senderBlock) senderBlock(sender);
    
}

- (void)btnClickWithBlock:(void(^)(ActionItem * sender))senderBlock {
    objc_setAssociatedObject(self, &kActionBtnClckBlockKey, senderBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end




@interface DoubleItemsCell: UITableViewCell

@property (nonatomic, strong)ActionItem * actionItemLeft;
@property (nonatomic, strong)ActionItem * actionItemRight;
@property (nonatomic, strong)UIView * lineView;

- (void)btnLeftClickWithBlock:(void(^)(ActionItem * sender))senderBlock;
- (void)btnRightClickWithBlock:(void(^)(ActionItem * sender))senderBlock;
@end

@implementation DoubleItemsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubView];
    }
    return self;
}

- (void)configureSubView {
    _actionItemLeft = [ActionItem buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_actionItemLeft];
    _actionItemRight = [ActionItem buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_actionItemRight];
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
    
    [_actionItemLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionItemLeft setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xEEEEEE alpha:1]] forState:UIControlStateNormal];
    [_actionItemLeft setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xDDDDDD alpha:1]] forState:UIControlStateHighlighted];
    
    [_actionItemRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionItemRight setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xEEEEEE alpha:1]] forState:UIControlStateNormal];
    [_actionItemRight setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xDDDDDD alpha:1]] forState:UIControlStateHighlighted];
    
    
    _lineView.backgroundColor = [UIColor lightGrayColor];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    _actionItemLeft.translatesAutoresizingMaskIntoConstraints = false;
    _actionItemRight.translatesAutoresizingMaskIntoConstraints = false;
    _lineView.translatesAutoresizingMaskIntoConstraints = false;
    
    [NSLayoutConstraint constraintWithItem:_actionItemLeft attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44].active = YES;
    [NSLayoutConstraint constraintWithItem:_actionItemRight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44].active = YES;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_actionItemLeft]-(1)-[_actionItemRight(_actionItemLeft)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_actionItemLeft,_actionItemRight)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lineView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lineView(1)]-0-[_actionItemLeft]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_actionItemLeft,_lineView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lineView(1)]-0-[_actionItemRight]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_actionItemRight,_lineView)]];
    
    
    [_actionItemLeft addTarget:self action:@selector(btnLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionItemRight addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setValueWithItems:(NSArray<XCAlertAction *> *)actions {
    XCAlertAction * leftItem = [actions firstObject];
    XCAlertAction * rightItem = [actions lastObject];
    
    _actionItemLeft.title = leftItem.title;
    _actionItemLeft.style = leftItem.style;
    _actionItemRight.title = rightItem.title;
    _actionItemRight.style = rightItem.style;
    objc_setAssociatedObject(self, &kActionBtnLeftClckKey, leftItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kActionBtnRightClckKey, rightItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)btnLeftClick:(ActionItem *)sender {
    XCAlertAction * action = objc_getAssociatedObject(self, &kActionBtnLeftClckKey);
    void((^actionBlock)(XCAlertAction *action)) = objc_getAssociatedObject(action, &kActionHandleKey);
    if (actionBlock)actionBlock(action);
    
    void(^senderBlock)(ActionItem *sender) = objc_getAssociatedObject(self, &kActionBtnLeftClckBlockKey);
    if (senderBlock) senderBlock(sender);
}
- (void)btnRightClick:(ActionItem *)sender {
    XCAlertAction * action = objc_getAssociatedObject(self, &kActionBtnRightClckKey);
    void((^actionBlock)(XCAlertAction *action)) = objc_getAssociatedObject(action, &kActionHandleKey);
    if (actionBlock)actionBlock(action);
    
    void(^senderBlock)(ActionItem *sender) = objc_getAssociatedObject(self, &kActionBtnRightClckBlockKey);
    if (senderBlock) senderBlock(sender);
}

- (void)btnLeftClickWithBlock:(void(^)(ActionItem * sender))senderBlock {
    objc_setAssociatedObject(self, &kActionBtnLeftClckBlockKey, senderBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)btnRightClickWithBlock:(void(^)(ActionItem * sender))senderBlock {
    objc_setAssociatedObject(self, &kActionBtnRightClckBlockKey, senderBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark -


@interface XCAlertViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSLayoutConstraint* alertHeightConst;
@property (nonatomic, readwrite) XCAlertControllerStyle preferredStyle;

@property (nonatomic, strong)NSMutableArray <XCAlertAction *>* dataArray;

@end

@implementation XCAlertViewController
static dispatch_semaphore_t semaphore;
@synthesize title = _title;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_preferredStyle == XCAlertControllerStyleAlert) {
        self.tableView.transform = CGAffineTransformScale(self.tableView.transform, 2, 2);
        self.tableView.alpha = 0;
        [UIView animateWithDuration:.2 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
            //
        }];
    } else {
        [self.tableView layoutIfNeeded];
        CGFloat height = CGRectGetHeight(self.tableView.bounds);
        self.tableView.transform = CGAffineTransformMakeTranslation(0, height);
        self.tableView.alpha = 0;
        [UIView animateWithDuration:.2 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_preferredStyle == XCAlertControllerStyleActionSheet) {
        [self.tableView layoutIfNeeded];
        CGFloat height = CGRectGetHeight(self.tableView.bounds);
//        self.tableView.transform = CGAffineTransformIdentity;
//        self.tableView.alpha = 1;
        [UIView animateWithDuration:.2 animations:^{
            self.tableView.transform = CGAffineTransformMakeTranslation(0, height);
        } completion:^(BOOL finished) {
            self.tableView.alpha = 0;
        }];
    }

}

- (void)configureSubView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = false;
    [self.tableView registerClass:[SignleItemCell class] forCellReuseIdentifier:identifier];
    [self.tableView registerClass:[DoubleItemsCell class] forCellReuseIdentifier:identifierDouble];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.dataArray = [NSMutableArray array];
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertController)];
    [self.view addGestureRecognizer:tapGR];
    semaphore = dispatch_semaphore_create(1);
    
    
}
- (void)setPreferredStyle:(XCAlertControllerStyle)preferredStyle {
    _preferredStyle = preferredStyle;
    if (self.preferredStyle == XCAlertControllerStyleAlert) {
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0].active = true;
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = true;
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:MIN(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) *0.7].active = true;
    } else {
        if (@available(iOS 11.0, *)) {
            UILayoutGuide *safeGuide = self.view.safeAreaLayoutGuide;
            [self.tableView.leadingAnchor constraintEqualToAnchor:safeGuide.leadingAnchor constant:8].active = YES;
            [self.tableView.trailingAnchor constraintEqualToAnchor:safeGuide.trailingAnchor constant:-8].active = YES;;
            [self.tableView.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor constant:0].active = YES;;
            
        } else {
            [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:8].active = YES;
            [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8].active = YES;
            [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
        }
    }
    
    _alertHeightConst = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:200];
    _alertHeightConst.active = true;
    self.tableView.tableHeaderView = [self headerView];
}

- (void)dismissAlertController {
    if (self.preferredStyle == XCAlertControllerStyleActionSheet) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIView *)headerView {
    
    UIView * baseView = [UIView new];
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * messageLabel = [[UILabel alloc] init];
    
    [baseView addSubview:titleLabel];
    [baseView addSubview:messageLabel];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    messageLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    messageLabel.text = self.message;
    titleLabel.numberOfLines = 0;
    messageLabel.numberOfLines = 0;

//    titleLabel.text = @"title";
//    messageLabel.text = @"message";
    
    CGFloat offsetY = 0, gap = 8;
    
    [self.tableView layoutIfNeeded];
    CGRect tableFrame = self.tableView.frame;
    
    if (titleLabel.text) {
        offsetY += 2*gap;
        CGSize titleLabelSize = [titleLabel sizeThatFits:tableFrame.size];
        titleLabel.frame = CGRectMake(0, offsetY, CGRectGetWidth(tableFrame), titleLabelSize.height);
        offsetY += titleLabelSize.height;
    }
    if (messageLabel.text){
        offsetY += gap;
        CGSize messageLabelSize = [messageLabel sizeThatFits:tableFrame.size];
        messageLabel.frame = CGRectMake(0, offsetY, CGRectGetWidth(tableFrame), messageLabelSize.height);
        offsetY += messageLabelSize.height;
    }
    offsetY += 2*gap;
    baseView.frame = CGRectMake(0, 0, CGRectGetWidth(tableFrame), offsetY);
    return baseView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureSubView];
    }
    return self;
}


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XCAlertControllerStyle)preferredStyle {
    XCAlertViewController *alertVC = [[XCAlertViewController alloc] init];
    alertVC.title = title;
    alertVC.message = message;
    alertVC.preferredStyle = preferredStyle;
    
    return alertVC;
}

- (void)addAction:(XCAlertAction *)action {
    [self.dataArray addObject:action];
    
    if (self.dataArray.count>0) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        __block BOOL isHave ;
        __block NSInteger count = 0;
        NSMutableArray * mArr = [NSMutableArray arrayWithArray:self.dataArray];
        [mArr enumerateObjectsUsingBlock:^(XCAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style == UIAlertActionStyleCancel) {
                ++count;
                if (count>1) {
                    *stop = YES;
                    isHave = YES;
                }
            }
        }];
        NSAssert(isHave == NO, @"action不能包含多个UIAlertActionStyleCancel");
        
        [mArr enumerateObjectsUsingBlock:^(XCAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style == UIAlertActionStyleCancel) {
                [mArr removeObject:obj];
                [mArr insertObject:obj atIndex:mArr.count];
            }
        }];
        self.dataArray = mArr;
        dispatch_semaphore_signal(semaphore);
    }
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.alertHeightConst.constant = self.tableView.contentSize.height;
}
#pragma mark - getter setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.tableView.tableHeaderView = [self headerView];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.tableView.tableHeaderView = [self headerView];
}




#pragma mark - tableView dataSource & delegate

static NSString * const identifier = @"cell";
static NSString * const identifierDouble = @"cell2";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 2) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.preferredStyle == XCAlertControllerStyleAlert) {
        if (self.dataArray.count == 2) {
            DoubleItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDouble forIndexPath:indexPath];
            [cell setValueWithItems:self.dataArray];
            [cell btnLeftClickWithBlock:^(ActionItem *sender) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [cell btnRightClickWithBlock:^(ActionItem *sender) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            return cell;
        } else {
            SignleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            XCAlertAction *action = [self.dataArray objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //    cell.lineView.alpha = (indexPath.row==self.dataArray.count-1)? 0:1;
            [cell btnClickWithBlock:^(ActionItem * sender) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [cell setValueWithItem:action];
            return cell;
        }
    }else{
        SignleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        XCAlertAction *action = [self.dataArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell btnClickWithBlock:^(ActionItem * sender) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [cell actionSheetLastCell:(indexPath.row == self.dataArray.count-1)?YES:NO];
        [cell setValueWithItem:action];
        return cell;
    }
}

@end


#pragma mark -

@interface UIViewController (SecondViewController)

@end

@implementation UIViewController (SecondViewController)

+ (void)load {
    Method oldPresent = class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:));
    Method newPresent = class_getInstanceMethod([self class], @selector(presentSecondViewController:animated:completion:));
    method_exchangeImplementations(oldPresent, newPresent);
    
    
    Method oldDismiss = class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:));
    Method newDismiss = class_getInstanceMethod([self class], @selector(dismissSecondViewControllerAnimated:completion:));
    method_exchangeImplementations(oldDismiss, newDismiss);
}

- (void)presentSecondViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[XCAlertViewController class]]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        viewControllerToPresent.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self presentSecondViewController:viewControllerToPresent animated:flag completion:completion];
}


- (void)dismissSecondViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if ([self isKindOfClass:[XCAlertViewController class]]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self dismissSecondViewControllerAnimated:flag completion:completion];
}

@end






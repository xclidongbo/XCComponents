//
//  AutoCompleteFloatTextField.m
//  XCFloatTextField
//
//  Created by 李东波 on 1/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "AutoCompleteFloatTextField.h"

@interface AutoCompleteFloatTextField ()<UITableViewDelegate,UITableViewDataSource>
{
    dispatch_semaphore_t semaphone;
}
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray * dataArray;

@property (nonatomic, strong)NSLayoutConstraint * tableHeightConst;

@end

static NSString * const cellIdentfily = @"cell";
@implementation AutoCompleteFloatTextField


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureSubView];
    }
    return self;
}

- (void)configureSubView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 100) style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    [self bringSubviewToFront:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AutoTableViewCell class] forCellReuseIdentifier:cellIdentfily];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.hidden = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 30;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-10)-[_tableView]-(-10)-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tableView)]];
    
    _tableHeightConst = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:100];
    [self.tableView addConstraint:_tableHeightConst];

    
    [self addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    semaphone = dispatch_semaphore_create(1);
}

- (void)setSourceData:(NSArray<NSString *> *)sourceData {
    if (sourceData) {
        _dataArray = [NSMutableArray arrayWithArray:sourceData];
        _sourceData = [sourceData mutableCopy];
        _tableHeightConst.constant = sourceData.count *30;
        [self.tableView reloadData];
    }
}

- (void)textFieldTextEditingChanged:(UITextField *)textField {
//    [super textFieldTextEditingChanged:textField];
    dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", textField.text];

    NSArray *arr = [self.sourceData filteredArrayUsingPredicate:pre];
//    NSLog(@"%d", arr.count);
    if (arr.count==0||textField.text.length == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
//    NSLog(@"%@",arr);
    self.dataArray = [NSMutableArray arrayWithArray:arr];
    _tableHeightConst.constant = self.dataArray.count *30;
    [self.tableView reloadData];
    dispatch_semaphore_signal(semaphone);
}



#pragma mark - tableView dataSource delegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AutoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfily forIndexPath:indexPath];
    cell.label.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.lineView.alpha = (indexPath.row==self.dataArray.count-1)? 0:1;
    return cell;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 30;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.text = [self.dataArray objectAtIndex:indexPath.row];
    self.tableView.hidden = YES;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (result == nil) {
        CGPoint myPoint = [self.tableView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.tableView.bounds, myPoint)) {
            return self.tableView;
        }
    }

    return result;
}

- (BOOL)resignFirstResponder {
    self.tableView.hidden = YES;
    return [super resignFirstResponder];
}


@end


@interface AutoTableViewCell ()

@end

@implementation AutoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
        _label = [[UILabel alloc] init];
        [self.contentView addSubview:_label];
        _label.font = [UIFont systemFontOfSize:15];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        self.label.translatesAutoresizingMaskIntoConstraints = false;
        self.lineView.translatesAutoresizingMaskIntoConstraints = false;
//        _label.frame = CGRectMake(10, 5, CGRectGetWidth(self.bounds)-10, 20);
//        _lineView.frame = CGRectMake(0, 29, CGRectGetWidth(self.bounds)+40, 1);
        
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0].active = YES;
//
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;

        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30].active = YES;
        
        
        [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:10].active = YES;
        [NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10].active = YES;
        
        [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1].active = YES;
        
        
        
        
    }
    return self;
}




@end




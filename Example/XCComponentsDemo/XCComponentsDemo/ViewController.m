//
//  ViewController.m
//  XCComponentsDemo
//
//  Created by 李东波 on 11/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "ViewController.h"
#import "TextFieldsViewController.h"
#import "ToastViewController.h"
#import "ButtonViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSDictionary * dataDic;
@property (nonatomic, strong)NSArray * titleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString * const identifier = @"cell";

static NSString * const kTextFiledConst = @"TextField";
static NSString * const kToastConst = @"Toast";
static NSString * const kButtonConst = @"Button";
static NSString * const kUnlockConst = @"Unlock";

static NSDictionary * textFieldDic = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    textFieldDic = @{
                     @"FloatTextField": @(NSTextFieldTypeFloat),
                     @"AutoCompleteFloatTextField": @(NSTextFieldTypeAutoComplete),
                     };
    
    _dataDic = @{
                 kToastConst: @[
                         @"XCToast",
                         ],
                 kButtonConst: @[
                         @"XCLoadButton"
                         ],
                 kTextFiledConst: @[
                         @"FloatTextField",
                         @"AutoCompleteFloatTextField",
                         ],
                 kUnlockConst: @[],
                 };
    NSArray *sortArr = [[self.dataDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    self.titleArray = sortArr;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    NSLog(@"view: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"tableView: %@", NSStringFromCGRect(self.tableView.frame));
//}

#pragma mark -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = [self.dataDic objectForKey:[self.titleArray objectAtIndex:section]];
    return rows.count;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titleArray objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray * contentArr = [self.dataDic objectForKey:[self.titleArray objectAtIndex:indexPath.section]];
    cell.textLabel.text=[contentArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"行%ld 列%ld", (long)indexPath.section,indexPath.row);
    NSString * titleKey = [self.titleArray objectAtIndex:indexPath.section];
    NSArray * contentArr = [self.dataDic objectForKey:titleKey];
    NSString * componentName = [contentArr objectAtIndex:indexPath.row];
    NSLog(@"%@, %@", titleKey, componentName);
    
    if ([titleKey isEqualToString:kTextFiledConst]) {
        TextFieldsViewController * vc = [[TextFieldsViewController alloc] init];
        vc.title = componentName;
        vc.textFieldType = [[textFieldDic objectForKey:componentName] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleKey isEqualToString:kToastConst]) {
        ToastViewController * vc = [[ToastViewController alloc] init];
        vc.title = componentName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleKey isEqualToString:kButtonConst]) {
        ButtonViewController * vc = [[ButtonViewController alloc] init];
        vc.title = componentName;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleKey isEqualToString:kUnlockConst]) {
        
    }
    
}




@end

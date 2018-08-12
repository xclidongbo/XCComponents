//
//  AutoCompleteFloatTextField.h
//  XCFloatTextField
//
//  Created by 李东波 on 1/8/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "FloatTextField.h"

@interface AutoCompleteFloatTextField : FloatTextField

@property (nonatomic, strong)NSArray <NSString *>*sourceData;

@end


@interface AutoTableViewCell: UITableViewCell
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIView *lineView;

@end

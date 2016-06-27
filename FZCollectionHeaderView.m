//
//  FZCollectionHeaderView.m
//  FZCalenderPickerDemo
//
//  Created by zhangxue on 16/6/22.
//  Copyright © 2016年 zhangxue. All rights reserved.
//

#import "FZCollectionHeaderView.h"

@implementation FZCollectionHeaderView

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}



@end

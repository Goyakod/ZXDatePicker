//
//  FZCalendarCell.m
//  FZCalenderPickerDemo
//
//  Created by Goyakod on 16/6/22.
//  Copyright © 2016年 . All rights reserved.
//

#import "FZCalendarCell.h"

@implementation FZCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setBackgroundColor:[UIColor whiteColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}


@end

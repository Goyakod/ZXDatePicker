//
//  ZXCalendarCell.m
//  
//
//  Created by Goyakod on 16/6/22.
//  Copyright © 2016年 Goyakod. All rights reserved.
//

#import "ZXCalendarCell.h"

@implementation ZXCalendarCell

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

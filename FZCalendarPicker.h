//
//  FZCalendarPicker.h
//  FZCalenderPickerDemo
//
//  Created by Goyakod on 16/6/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZCalendarPicker;

@protocol FZCalendarDelegate <NSObject>

/**
 *  返回选择的时间
 *
 *  @param picker     时间选择选择器
 *  @param dateString 格式为yyyy-MM-dd
 */
- (void)picker:(FZCalendarPicker *)picker didSelectedDate:(NSString *)dateString;


@end


@interface FZCalendarPicker : UIView

/**
 *  最多可以显示距今多少天的有效日期, 默认20天
 */
@property (nonatomic, assign) NSInteger validDays;
/**
 *  选中日期的背景颜色, 默认是60,160,255
 */
@property (nonatomic, strong) UIColor *selectBgColor;
/**
 *  选中后的日期字体颜色, 默认是whiteColor
 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/**
 *  可选的日期颜色, 默认是80
 */
@property (nonatomic, strong) UIColor *validColor;
/**
 *  不可选的日期颜色, 默认是216
 */
@property (nonatomic, strong) UIColor *invalidColor;
/**
 *  显示月份的表头的背景颜色, 默认是216
 */
@property (nonatomic, strong) UIColor *headerBgColor;

/**
 *  选中日期后的代理,返回日期字符串，格式为：yyyy-MM-dd
 */
@property (nonatomic, assign) id<FZCalendarDelegate> delegate;


/**
 *  重新刷新时间选择器，取消选中当前选中的日期
 */
- (void)reloadDatePicker;

@end

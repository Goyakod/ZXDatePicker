# ZXDatePicker
一个简单的日历控件

##How to use?

**支持属性**

```

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

```

###代码创建：
```
FZCalendarPicker *picker = [[FZCalendarPicker alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:picker];
    //从今天算起有效日期100天
    picker.validDays = 100;

```
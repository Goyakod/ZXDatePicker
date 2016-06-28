//
//  ZXCalendarPicker.m
//  
//
//  Created by Goyakod on 16/6/22.
//  Copyright © 2016年 Goyakod. All rights reserved.
//

#import "ZXCalendarPicker.h"

#import "ZXCalendarCell.h"
#import "ZXCollectionHeaderView.h"


static NSString * const reuseIdentifier = @"ChooseTimeCell";
static NSString * const headerIdentifier = @"headerIdentifier";

@interface ZXCalendarPicker() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSDateFormatter  *formatter;
@property (nonatomic, strong) NSDateComponents *comps;
@property (nonatomic, strong) NSCalendar       *calender;
@property (nonatomic, strong) NSArray          * weekdays;
@property (nonatomic, strong) NSTimeZone       *timeZone;
@property (nonatomic, strong) NSDate           *date;

@property (nonatomic, copy) NSString *selectedTime;

@end

@implementation ZXCalendarPicker

#pragma mark --- 初始化
- (NSTimeZone*)timeZone
{
    if (_timeZone == nil) {
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}

- (NSArray*)weekdays
{
    if (_weekdays == nil) {
        
        _weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
        
    }
    return _weekdays;
}

- (NSCalendar*)calender
{
    if (_calender == nil) {
        
        _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    return _calender;
}

- (NSDateComponents*)comps
{
    if (_comps == nil) {
        _comps = [[NSDateComponents alloc] init];
    }
    
    return _comps;
}
- (NSDateFormatter*)formatter
{
    
    if (_formatter == nil) {
        
        _formatter =[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

- (UIColor *)selectBgColor
{
    if (_selectBgColor == nil) {
        _selectBgColor = [UIColor colorWithRed:60.0/255.0 green:160.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    return _selectBgColor;
}

- (UIColor *)selectedTextColor
{
    if (_selectedTextColor == nil) {
        _selectedTextColor = [UIColor whiteColor];
    }
    
    return _selectedTextColor;
}

- (UIColor *)invalidColor
{
    if (_invalidColor == nil) {
        _invalidColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    }
    return _invalidColor;
}

- (UIColor *)validColor
{
    if (_validColor == nil) {
        _validColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
    }
    
    return _validColor;
}

- (UIColor *)headerBgColor
{
    if (_headerBgColor == nil) {
        _headerBgColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    }
    return _headerBgColor;
}

- (NSInteger)validDays
{
    if (_validDays == 0) {
        _validDays = 20;
    }
    return _validDays;
}


#pragma mark - lifeCtycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.date = [NSDate date];
    
    CGFloat itemWidth  = self.frame.size.width / 7.0;
    CGFloat itemHeight = itemWidth;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setHeaderReferenceSize:CGSizeMake( self.frame.size.width, 50)];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,  self.bounds.size.width,  self.bounds.size.height) collectionViewLayout:layout];
    _collectionView.delegate        = self;
    _collectionView.dataSource      = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setCollectionViewLayout:layout animated:YES];
    [_collectionView registerClass:[ZXCalendarCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_collectionView registerClass:[ZXCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    [self addSubview:_collectionView];
}

- (void)layoutSubviews
{
    self.collectionView.frame = CGRectMake(0, 0,  self.bounds.size.width,  self.bounds.size.height);
}

#pragma mark - reloadPicker
- (void)reloadDatePicker
{
    self.selectedTime = nil;
    [self.collectionView reloadData];
}

#pragma mark - 时间计算：

/**
 *  根据当前月获取有多少天
 *
 *  @param dayDate 当前时间
 *
 *  @return 天数
 */
- (NSInteger)getNumberOfMonth:(NSDate *)dayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dayDate];
    
    return range.length;
}

/**
 *  根据前几月获取时间
 *
 *  @param date  当前时间
 *  @param month 第几个月 正数为前  负数为后
 *
 *  @return 获得时间
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month

{
    [self.comps setMonth:month];
    
    NSDate *mDate = [self.calender dateByAddingComponents:self.comps toDate:date options:0];
    return mDate;
}


/**
 *  根据时间获取周几
 *
 *  @param inputDate 输入参数是NSDate，
 *
 *  @return 输出结果是星期几的字符串。
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    [self.calender setTimeZone: self.timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [self.calender components:calendarUnit fromDate:inputDate];
    
    return [self.weekdays objectAtIndex:theComponents.weekday];
}

/**
 *  获取第N个月的时间
 *
 *  @param currentDate 当前时间
 *  @param index 第几个月 正数为前  负数为后
 *
 *  @return @[2016, 6, 22]
 */
- (NSArray*)timeString:(NSDate*)currentDate many:(NSInteger)index;
{
    NSDate *getDate =[self getPriousorLaterDateFromDate:currentDate withMonth:index];
    
    NSString  *str =  [self.formatter stringFromDate:getDate];
    
    return [str componentsSeparatedByString:@"-"];
}

/**
 *  根据时间获取第一天周几
 *
 *  @param dateStr 时间
 *
 *  @return 周几
 */
- (NSString*)getMonthBeginAndEndWith:(NSDate *)dateStr{
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//设定周日为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:dateStr];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    
    return   [self weekdayStringFromDate:beginDate];
}

/**
 *  判断当前时间是否为可选的有效日期
 *
 *  @param time 传入的时间字符串格式：yyyy-MM-dd
 *
 *  @return 如果传入的时间距今的时间范围在validDays内返回yes
 */
- (BOOL)isValidDate:(NSString *)time
{
    NSDate *inputDate = [self.formatter dateFromString:time];
    NSComparisonResult result = [inputDate compare:_date];
    if (result == NSOrderedAscending) {
        //输入的时间是过去式
        return NO;
    }else{
        NSTimeInterval interval = [inputDate timeIntervalSinceNow];
        if (interval < self.validDays*24*60*60) {
            return YES;
        }else{
            return NO;
        }
    }
}


#pragma mark - UICollection DataSource
/**
 *  要显示的月份数量：
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    /**
     *  要根据传进来的日期计算出显示多少个月，每个月有多少个有效日期
     */
    NSDate  *deadline  = [NSDate dateWithTimeInterval:self.validDays*24*60*60 sinceDate:_date];
    NSArray *currentArr = [self timeString:_date many:0];
    NSArray *deadlineArr = [self timeString:deadline many:0];
    NSString *currentStr = currentArr[1];
    NSString *deadlineStr = deadlineArr[1];
    
    if ((deadlineStr.integerValue - currentStr.integerValue)>=0) {//跨月
        return deadlineStr.integerValue - currentStr.integerValue + 1;
    }else{//没跨月
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSDate *dateList = [self getPriousorLaterDateFromDate:_date withMonth:section];
    
    NSString *timerNsstring = [self getMonthBeginAndEndWith:dateList];
    NSInteger p_0 = [timerNsstring integerValue];
    NSInteger p_1 = [self getNumberOfMonth:dateList] + p_0;
    
    return p_1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXCalendarCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDate *dateList = [self getPriousorLaterDateFromDate:_date withMonth:indexPath.section];
    
    NSArray *array = [self timeString:_date many:indexPath.section];
    
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    
    NSString *str;
    
    str = p > 0 ? [NSString stringWithFormat:@"%ld",p]:@"";
    
    NSArray *list = @[ array[0], array[1], str];
    NSString *timeString = [list componentsJoinedByString:@"-"];
    
    if ([self isValidDate:timeString]) {
        [cell.dateLabel setTextColor:self.validColor];
    }else{
        [cell.dateLabel setTextColor:self.invalidColor];
    }
    
    if ([self.selectedTime isEqualToString:timeString]) {
        cell.dateLabel.layer.masksToBounds = YES;
        cell.dateLabel.layer.cornerRadius = cell.dateLabel.bounds.size.width/2.0;
        cell.dateLabel.backgroundColor = self.selectBgColor;
        cell.dateLabel.textColor = self.selectedTextColor;
    }else{
        cell.dateLabel.backgroundColor = [UIColor whiteColor];
    }

    [cell.dateLabel setText:str];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ZXCollectionHeaderView * headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        NSArray *dateArry = [self timeString:_date many:indexPath.section];
        [headerCell.titleLabel setText:[NSString stringWithFormat:@"%@年%@月",dateArry[0],dateArry[1]]];
        [headerCell.titleLabel setBackgroundColor:self.headerBgColor];
        return headerCell;
    }
    return nil;
}

#pragma mark - UICollection Delegate
/**
 *  表头的大小：
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 30);
}
/**
 *  在有效日期内的日期设置可选的
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *dateList = [self getPriousorLaterDateFromDate:_date withMonth:indexPath.section];
    
    NSArray *array = [self timeString:_date many:indexPath.section];
    
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    
    NSString *str;
    
    str = p > 0 ? [NSString stringWithFormat:@"%ld",p]:@"";
    
    NSArray *list = @[ array[0], array[1], str];
    NSString *timeString = [list componentsJoinedByString:@"-"];
    
    return  [self isValidDate:timeString];

}

/**
 *  选择日期后回调
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDate*dateList = [self getPriousorLaterDateFromDate:_date withMonth:indexPath.section];
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    NSArray *array = [self timeString:_date many:indexPath.section];
    
    NSString *str = [NSString stringWithFormat:@"%ld",p];
    self.selectedTime = [NSString stringWithFormat:@"%@-%@-%@",array[0],array[1],str];
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(picker:didSelectedDate:)]) {
        NSString *callBackStr = p < 10 ? [NSString stringWithFormat:@"0%ld",p]:[NSString stringWithFormat:@"%ld",p];
        [self.delegate picker:self didSelectedDate:[NSString stringWithFormat:@"%@-%@-%@",array[0],array[1],callBackStr]];
    }
}

@end

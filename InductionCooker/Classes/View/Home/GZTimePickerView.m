//
//  GZTimePickerView.m
//  TimePickerView
//
//  Created by gz on 2017/10/13.
//  Copyright © 2017年 gz. All rights reserved.
//

#import "GZTimePickerView.h"

#define ConstScreenWidth [UIScreen mainScreen].bounds.size.width
#define ConstScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GZTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
/// pickerView
@property (nonatomic, strong) UIPickerView *myPickerView;
/// 数组-->天/点/分钟
@property (nonatomic, strong) NSMutableArray *dayArray, *hourArray, *minutesArray;
/// 选择后的时间字符串-->格式(今天/几点/几分)
@property (nonatomic,   copy) NSString *dayString, *hourString, *minutesString;
/// 当前时间/时/分
@property (nonatomic, strong) NSMutableArray *nowHourArray, *nowMinutesArray;
/// 当前时间的小时/分钟
@property (nonatomic, assign) NSInteger day, hour, minute;

@property (nonatomic,retain) UIToolbar *actionToolbar;
@end

@implementation GZTimePickerView

- (instancetype)initWithFrame:(CGRect)frame AddHours:(NSInteger)addHours {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatPickerViewUIWithAddHours:addHours];
    }
    return self;
}

- (void)creatPickerViewUIWithAddHours:(NSInteger)addHours {
    self.dayArray = [[NSMutableArray alloc] initWithObjects:@"今天", @"明天", @"后天", nil];
    self.nowHourArray = [NSMutableArray array];
    self.nowMinutesArray = [NSMutableArray array];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    self.day = dateComponents.day;
    self.hour = dateComponents.hour + addHours;
    self.minute = dateComponents.minute;
    
    if (self.minute <= 30) {
        for (NSInteger i = self.hour; i < 24; i++) {
            [self.nowHourArray addObject:[NSString stringWithFormat:@"%ld点", i]];
        }
        for (NSInteger i = (self.minute + 29) / 15; i < 4; i++) {
            [self.nowMinutesArray addObject:[NSString stringWithFormat:@"%02ld分", i * 15]];
        }
    } else {
        if (self.hour == 23) {
            for (NSInteger i = 0; i < 24; i++) {
                [self.nowHourArray addObject:[NSString stringWithFormat:@"%ld点", i]];
            }
            [self.dayArray removeObjectAtIndex:0];
        } else {
            for (NSInteger i = self.hour + 1; i < 24; i++) {
                [self.nowHourArray addObject:[NSString stringWithFormat:@"%ld点", i]];
            }
        }
        for (NSInteger i = (self.minute + 29 - 60) / 15; i < 4; i++) {
            [self.nowMinutesArray addObject:[NSString stringWithFormat:@"%02ld分", i * 15]];
        }
    }
    self.hourArray = self.nowHourArray;
    self.minutesArray = self.nowMinutesArray;
    self.dayString = [self.dayArray objectAtIndex:0];
    self.hourString = [self.nowHourArray objectAtIndex:0];
    self.minutesString = [self.minutesArray objectAtIndex:0];
    
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, ConstScreenWidth, 300)];
    self.myPickerView.showsSelectionIndicator = YES;
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    [self addSubview:self.myPickerView];
    [self.myPickerView selectRow:0 inComponent:0 animated:YES];
    [self.myPickerView selectRow:0 inComponent:1 animated:YES];
    [self.myPickerView selectRow:0 inComponent:2 animated:YES];
    
    self.actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ConstScreenWidth, 44)];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(pickerCancelClicked:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(pickerDoneClicked:)];
    [self.actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,flexSpace,doneBtn, nil] animated:YES];
    self.actionToolbar.backgroundColor = [UIColor whiteColor];
    [self.actionToolbar sizeToFit];
    [self addSubview:self.actionToolbar];
}

#pragma mark - 点击事件
- (void)pickerCancelClicked:(UIBarButtonItem*)barButton {
    [self removeFromSuperview];
}

- (void)pickerDoneClicked:(UIBarButtonItem*)barButton {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    if (dateComponents.day == self.day) {
        NSString *currentDateStr = [self putinDayStr:self.dayString hourStr:self.hourString minuteStr:self.minutesString];
        NSLog(@"%@", currentDateStr);
        [self removeFromSuperview];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前时间已过期,请重新选择!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"重新选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.actionToolbar removeFromSuperview];
            [self.myPickerView removeFromSuperview];
            [self creatPickerViewUIWithAddHours:0];
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:sureAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSString *)putinDayStr:(NSString *)dayString hourStr:(NSString *)hourStr minuteStr:(NSString *)minuteStr {
    NSString *hour = [[hourStr componentsSeparatedByString:@"点"] firstObject];
    NSString *minute = [[minuteStr componentsSeparatedByString:@"分"] firstObject];
    NSString *dateStr = [self dayStr:dayString];
    dateStr = [NSString stringWithFormat:@"%@ %@:%@:00", dateStr,hour,minute];
    return dateStr;
}

// 传入天返回字符串
- (NSString *)dayStr:(NSString *)dayString {
    NSDate *finalDate;
    if ([dayString isEqualToString:@"今天"]) {
        // 今天
        finalDate = [NSDate date];
    } else if ([dayString isEqualToString:@"明天"]) {
        // 明天
        finalDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:[NSDate date]];
    } else if ([dayString isEqualToString:@"后天"]) {
        // 后天
        finalDate = [NSDate dateWithTimeInterval:2 * 24 * 60 * 60 sinceDate:[NSDate date]];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:finalDate];
    return dateStr;
}


#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    } else {
        return 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.dayArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.hourArray objectAtIndex:row];
    } else {
        return [self.minutesArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.dayString = [self.dayArray objectAtIndex:row];
        if (row == 0) {
            // 今天
            self.hourArray = self.nowHourArray;
            self.minutesArray = self.nowMinutesArray;
            self.hourString = [self.hourArray objectAtIndex:row];
            self.minutesString = [self.minutesArray objectAtIndex:row];
        } else {
            self.hourArray = [NSMutableArray array];
            self.minutesArray = [NSMutableArray array];
            for (NSInteger i = 0; i < 24; i++) {
                [self.hourArray addObject:[NSString stringWithFormat:@"%ld点", i]];
            }
            for (NSInteger i = 0; i < 4; i++) {
                [self.minutesArray addObject:[NSString stringWithFormat:@"%02ld分", i * 15]];
            }
        }
    } else if (component == 1) {
        self.hourString = [self.hourArray objectAtIndex:row];
        if ([self.hourString isEqualToString:[self.hourArray objectAtIndex:0]]) {
            self.minutesArray = self.nowMinutesArray;
        } else {
            self.minutesArray = [NSMutableArray array];
            for (NSInteger i = 0; i < 4; i++) {
                [self.minutesArray addObject:[NSString stringWithFormat:@"%02ld分", i * 15]];
            }
        }
    } else {
        self.minutesString = [self.minutesArray objectAtIndex:row];
    }
    [self.myPickerView reloadAllComponents];
    if ([self.hourArray indexOfObject:self.hourString] != NSIntegerMax) {
        [self.myPickerView selectRow:[self.hourArray indexOfObject:self.hourString] inComponent:1 animated:NO];
    }
    if ([self.minutesArray indexOfObject:self.minutesString] != NSIntegerMax) {
        [self.myPickerView selectRow:[self.minutesArray indexOfObject:self.minutesString] inComponent:2 animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dayArray.count;
    } else if (component == 1) {
        return self.hourArray.count;
    } else {
        return self.minutesArray.count;
    }
}

@end

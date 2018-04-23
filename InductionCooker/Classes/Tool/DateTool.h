//
//  DateTool.h
//  InductionCooker
//
//  Created by csl on 2017/7/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTool : NSObject


/**
 将date的秒数设置为0

 @param date date
 @return date
 */
+ (NSDate *) secondToZeroWithDate:(NSDate *)date;


/**
 判断时间是否过期,今天,明天

 @param date 日期
 @return 状态 -1 过期 0今天 1明天
 */
+ (int) stateDate:(NSDate *)date;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

@end

//
//  GCModen.h
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCModen : NSObject

//aotuWork = 1;
//defaultStalls =
//);
//defaultTime = 0;
//isTiming = 1;
//reservation = 1;
//showTemperature = 0;
//stalls =         (
//);
//timeCancel = 0;
//type = "\U7172\U7ca5";


/**
 是否自动模式
 */
@property (nonatomic,assign) int modenId;

/**
 是否自动模式
 */
@property (nonatomic,assign) BOOL aotuWork;


/**
 默认档位
 */
@property (nonatomic,strong) NSArray *defaultStalls;


/**
 默认时间
 */
@property (nonatomic,assign) int defaultTime;


/**
 是否支持预约
 */
@property (nonatomic,assign) BOOL reservation;


/**
 是否支持定时
 */
@property (nonatomic,assign) BOOL isTiming;


/**
 是否需要显示温度
 */
@property (nonatomic,assign) BOOL showTemperature;


/**
 档位
 */
@property (nonatomic,strong) NSArray *stalls;


/**
 是否支持定时取消
 */
@property (nonatomic,assign) BOOL timeCancel;



/**
 模式名字
 */
@property (nonatomic,copy) NSString *type;


/**
  预约日期
 */
@property (nonatomic,strong) NSDate *reservationStartDate;


/**
 预约工作时间
 */
@property (nonatomic,assign) int reservationWorkTime;

/**
 当前档位
 */
@property (nonatomic,assign) int currentStall;


+(instancetype)createModelWithDict:(NSDictionary *)dict;















@end

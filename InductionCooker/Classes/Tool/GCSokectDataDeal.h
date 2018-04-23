//
//  GCSokectDataDeal.h
//  InductionCooker
//
//  Created by csl on 2017/7/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KAppFirstByte         @"1"

#define KAppType              2

#define KHeartbeatType        [NSNumber numberWithInt:-1]

#define KMsgtype              [NSNumber numberWithInt:1]

#define KRectype              [NSNumber numberWithInt:1]

#define KUserId               @"13763085121"

#define KDeviceId             @"123456789"

#define KSokectOrder                @"order"

@interface GCSokectDataDeal : NSObject

+(NSData *)heartbeat;

+(NSData *)getStateDataWithModen:(int)deviecId;


//+ (NSData *) getStateDataWithModen:(int)moden device:(int) deviecId;

/**
 获取调节模式的协议
 
 @param moden 模式
 @param deviecId 炉号
 @return 协议
 */
+ (NSData *) getDataWithModen:(int)moden device:(int) deviecId;

/**
 获取设备的状态
 
 @param deviecId 模式
 @return 协议
 */
+ (NSData *) getDataWithdevice:(int) deviecId;


/**
 获取调节档位的协议
 
 @param deviceId 炉号
 @param stall 档位
 @return 协议
 */
+ (NSData *)getBytesWithDeviceId:(int)deviceId Stalls:(int) stall;

/**
 获取开/关机协议
 
 @param status 开/关机状态
 @return 协议
 */
+ (NSData *) getRootBytesWithDeviceId:(int)deviceId status:(int) status;



/**
 不同模式,档位对应显示的功率
 
 @param deviceId 炉号
 @param moden 模式
 @param stalls 档位
 @return 功率
 */
+ (NSString *) getPowerWhithDeivce:(int) deviceId moden:(int)moden stalls:(int) stalls;



/**
 获取预约协议

 @param deviceId deviceId description
 @param isSetting isSetting description
 @param moden moden description
 @param bootTime bootTime description
 @param time time description
 @return return value description
 */
+ (NSData *)getReservationBytesWithDeviceId:(int)deviceId setting:(BOOL)isSetting moden:(int)moden bootTime:(long)bootTime appointment:(int)time stall:(int)stall;


/**
 获取预约信息协议
 
 @param deviceId deviceId description

 */
+ (NSData *) getReservationInfoBytesWithDeviceId:(int)deviceId;



/**
 获取工作时间

 @param deviceId deviceId description
 @param mod mod description
 @return return value description
 */
+ (NSData *) getWorkTimeWithDeviceId:(int)deviceId moden:(int)mod;


+ (NSData *)getTimingBytesWithDeviceId:(int)deviceId setting:(BOOL)isSetting moden:(int)moden timing:(long)timing;



/**
  获取故障码回复数据

 @param deviceId deviceId
 @return data
 */
+(NSData *)getErorrBackDataWithDeviceId:(int)deviceId;

+ (NSData *) test;


















@end

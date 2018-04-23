//
//  GCAgreementHelper.h
//  InductionCooker
//
//  Created by csl on 2017/7/7.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCModen;

@interface GCAgreementHelper : NSObject



/**
 获取调节模式的协议

 @param moden 模式
 @param deviecId 炉号
 @return 协议
 */
+ (NSData *) getDataWithModen:(int)moden device:(int) deviecId;



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
 反校验和验证校验码

 @param data 接收到的数据
 @return 经过反校验的数组
 */
+ (NSData *) BCCCheck:(NSData *)data;



/**
 不同模式,档位对应显示的功率

 @param deviceId 炉号
 @param moden 模式
 @param stalls 档位
 @return 功率
 */
+ (NSString *) getPowerWhithDeivce:(int) deviceId moden:(int)moden stalls:(int) stalls;

+ (NSDictionary *) getStallsDictWith:(int) deviceId moden:(int) moden;


+ (GCModen *)getLeftModenWithModenId:(int)modenId;

+ (GCModen *)getRightModenWithModenId:(int)modenId;

@end

//
//  GCSokectDataDeal.m
//  InductionCooker
//
//  Created by csl on 2017/7/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCSokectDataDeal.h"

#import "GCUser.h"
#import "GCAgreementHelper.h"
#import "GCStringAndBytesConversion.h"



@implementation GCSokectDataDeal

+ (NSData *) getDataWithdevice:(int) deviecId
{
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",1] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviecId] forKey:@"deviceId"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;

}

+ (NSData *) test
{
    NSString *phone=[GCUser getInstance].mobile?[GCUser getInstance].mobile:@"";
    
    // NSString *deviceId=[GCUser getInstance].device.deviceId?[GCUser getInstance].device.deviceId:@"";
    
    
    NSDictionary *d=@{
                         @"code":@"100"
                         };
    
    NSDictionary *dict=@{
                         @"type":[NSNumber numberWithInt:KAppType],
                         @"id":phone,
                         @"msgtype":@1,
                         @"rectype":KHeartbeatType,
                         @"target":@"",
                         KSokectOrder:d
                         };
    
    NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return  data;

}

+(NSData *)heartbeat
{
//    * type=客户端类型; （1=设备(电磁炉)；2=手机app；3=服务器）
//    * id=客户端标识ID；（APP：用户账号，主机：设备ID）
//    * msgtype=消息类型；（-1=心跳; 1=指令；2=推送）
//    * rectype=消息接收方类型；（-1=心跳; 1=发给设备；2=发给app; 3=发给所有（设备和app））
//    * target=消息接收方ID(多个用逗号分隔);
//    * order=指令内容；（主机与APP交换的数据，第二部分协议主要针对该参数）

    NSString *phone=[GCUser getInstance].mobile?[GCUser getInstance].mobile:@"";
    
   // NSString *deviceId=[GCUser getInstance].device.deviceId?[GCUser getInstance].device.deviceId:@"";
    
    
    NSDictionary *dict=@{
                         @"type":[NSNumber numberWithInt:KAppType],
                         @"id":phone,
                         @"msgtype":KHeartbeatType,
                         @"rectype":KHeartbeatType,
                         @"target":@"",
                         KSokectOrder:@""
                        };
    
    NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return  data;
    
}


+(NSData *)getStateDataWithModen:(int)deviecId
{
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",1] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviecId] forKey:@"deviceId"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;
}


/**
 获取调节模式的协议
 
 @param moden 模式
 @param deviecId 炉号
 @return 协议
 */
+ (NSData *) getDataWithModen:(int)moden device:(int) deviecId
{
    
//    "code":3,
//    "deviceId":0,  //炉号 左炉 0 右炉 1
//    "moden":1, //设置模式

    
    
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",3] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviecId] forKey:@"deviceId"];
    
    [order setObject:[NSString stringWithFormat:@"%d",moden] forKey:@"moden"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;
}



/**
 获取调节档位的协议
 
 @param deviceId 炉号
 @param stall 档位
 @return 协议
 */
+ (NSData *)getBytesWithDeviceId:(int)deviceId Stalls:(int) stall
{
    
//    "code":4,
//    "deviceId":0,  //炉号 左炉 0 右炉 1
//    "stall":1,    //功率档位

    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",4] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];

    [order setObject:[NSString stringWithFormat:@"%d",stall] forKey:@"stall"];

    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;
}

/**
 获取开/关机协议
 
 @param status 开/关机状态
 @return 协议
 */
+ (NSData *) getRootBytesWithDeviceId:(int)deviceId status:(int) status
{
    
//    "code":2,
//    "deviceId":0,  //炉号 左炉 0 右炉 1
//    "power":0,  //开关机状态 开机1 关机 0

    
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",2] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    
    [order setObject:[NSString stringWithFormat:@"%d",status] forKey:@"power"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;

  
    
    
}




/**
 不同模式,档位对应显示的功率
 
 @param deviceId 炉号
 @param moden 模式
 @param stalls 档位
 @return 功率
 */
+ (NSString *) getPowerWhithDeivce:(int) deviceId moden:(int)moden stalls:(int) stalls
{
    return nil;
}

+ (NSData *) stringAppendByData:(NSData *)data
{
    NSString *hexStr=[GCStringAndBytesConversion hexDataToListHexString:data];
    
    NSString *str=[NSString stringWithFormat:@"%@%@%@%@%@",KAppFirstByte,KSokectFlagString,[GCUser getInstance].device.deviceId,KSokectFlagString,hexStr];
    
    NSLog(@"getDataWithModen: %@",str);
    
    return [str dataUsingEncoding:NSUTF8StringEncoding];

}

+ (NSData *)getReservationBytesWithDeviceId:(int)deviceId setting:(BOOL)isSetting moden:(int)moden bootTime:(long)bootTime appointment:(int)time stall:(int)stall
{
    //"code":6,
    //"setting":true, //设置预约时间 true  取消预约时间false
    //"deviceId":0,  //炉号 左炉 0 右炉 1
    //"moden":1, //模式
    //"bootTime":1, //预约开机时间(时间戳)
    //"Appointment":1 //预约工作时间
    
    bootTime=bootTime*60*1000;
    
    time=time<0?time:time*60*1000;
    
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",6] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    
    [order setObject:[NSString stringWithFormat:@"%d",isSetting] forKey:@"setting"];
    
    [order setObject:[NSString stringWithFormat:@"%d",moden] forKey:@"moden"];
    
    [order setObject:[NSString stringWithFormat:@"%ld",bootTime] forKey:@"bootTime"];
    
    [order setObject:[NSString stringWithFormat:@"%d",time] forKey:@"appointment"];
    
    [order setObject:[NSString stringWithFormat:@"%d",stall] forKey:@"stall"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;

}


+ (NSData *)getTimingBytesWithDeviceId:(int)deviceId setting:(BOOL)isSetting moden:(int)moden timing:(long)timing
{

//    "code":8,
//    "setting":true, //设置预约时间 true  取消预约时间false
//    "deviceId":0,  //炉号 左炉 0 右炉 1
//    "moden":1, //模式
//    "worktime":1, //工作时间 long(类型)

    
    
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",8] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    
    [order setObject:[NSString stringWithFormat:@"%d",isSetting] forKey:@"setting"];
    
    [order setObject:[NSString stringWithFormat:@"%d",moden] forKey:@"moden"];
    
    [order setObject:[NSString stringWithFormat:@"%ld",timing] forKey:@"worktime"];
    
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;
    
}


+(NSData *)getReservationInfoBytesWithDeviceId:(int)deviceId
{
    
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",7] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    

    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;

}

+(NSData *)getWorkTimeWithDeviceId:(int)deviceId moden:(int)mod
{
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",5] forKey:@"code"];
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    
    [order setObject:[NSString stringWithFormat:@"%d",mod] forKey:@"moden"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;

}

+(NSData *)getErorrBackDataWithDeviceId:(int)deviceId
{
    NSDictionary *dict=[self textAppending];
    
    NSMutableDictionary *order=dict[KSokectOrder];
    
    [order setObject:[NSString stringWithFormat:@"%d",9] forKey:@"code"];
    
    
    [order setObject:[NSString stringWithFormat:@"%d",deviceId] forKey:@"deviceId"];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    return data;
    
}


+ (NSDictionary *) textAppending
{
    NSMutableDictionary *order=[NSMutableDictionary dictionary];
    
    NSString *phone=[GCUser getInstance].mobile?[GCUser getInstance].mobile:@"";
    
    NSString *deviceId=[GCUser getInstance].device.deviceId?[GCUser getInstance].device.deviceId:@"";
    
    NSDictionary *dict=@{
                         @"type":[NSNumber numberWithInt:KAppType],
                         @"id":phone,
                         @"msgtype":KMsgtype,
                         @"rectype":KRectype,
                         @"target":deviceId,
                         KSokectOrder:order
                         };

  
    
    return dict;
}

@end

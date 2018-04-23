
//
//  GCGlobalStyle.h
//  goockr_dustbin
//
//  Created by csl on 16/9/30.
//  Copyright © 2016年 csl. All rights reserved.
//

#ifndef GCGlobalStyle_h
#define GCGlobalStyle_h

/*******************枚举定义***********************************/
typedef NS_ENUM(NSInteger, DeviceLinkState) {
    DeviceLinkStateNoneNet,
    DeviceLinkStateLinking,
    DeviceLinkStateLinked
};


#define KHudTipTime                        1

/*******************颜色值********************************/
#define KMainColor                         0xff8212


//http://www.zhuhaiheyi.com/cooker/a/login
//http://120.78.212.242/cooker/a/login


/**********************主机ip 端口***********************************/
#define KWIFIPrefix                        @"abc"

#define KIP                                @"www.zhuhaiheyi.com" //@"120.24.5.252" //@"192.168.1.190" //@"192.168.1.65" @"120.24.5.252:9001"


#define KPort                              9001 //192.168.1.65:9001


#define KSokectFlagString                  @"@_@"


/********************发送数据Tag值***************************/
#define KTagPowerOn                        1000

#define KTagPowerOff                       1001



/***********************通知名*************************************/
/**
 登录成功通知名
 
 @return 登录成功通知名
 */
#define KNotiLoginSuccess                      @"KNotiLoginSuccess"


/**
 设备状态发生变化通知名

 @return 设备状态发生变化通知名
 */
#define KNotiDevoceStateChange                 @"KDevoceStateChangeNoti"


/**
 设备档位状态发生变化通知名

 @return 设备档位状态发生变化通知名
 */
#define KNotiDevoceStallsChange                @"KDevoceStallsChangeNoti"


/**
 警报通知名称

 @return 警报通知名称
 */
#define KNotiError                              @"KErrorNoti"

/**
 预约通知名称
 
 @return 预约通知名称
 */
#define KNotiReservation                        @"KNotiReservation"

/**
 预约信息
 
 @return 预约信息名称
 */
#define KNotiReservationInfo                    @"KNotiReservationInfo"

/**
 工作时间通知名称
 
 @return 工作时间通知名称
 */
#define KNotiWorkTime                           @"KNotiWorkTime"


/**
 定时通知名称
 
 @return  定时通知名称
 */
#define KNotiTiming                             @"KNotiTiming"


/**
 设备断开连接时通知
 
 @return  电磁炉没有连接服务器通知
 */
#define KNotiDeviceDisconnectFormServe          @"KNotiDeviceDisconnectFormServe"

/**
 获取设备成功
 
 @return  获取设备成功
 */
#define KNotiSelectDeviceChange                @"KNotiSelectDeviceChange"


/**
 连接服务器状态
 
 @return  连接服务器状态
 */
#define KNotiConnectSokectServeState                @"KNotiConnectSokectServeState"


/************************用户偏好设置的Key*****************************************/
#define KLeftDeviceReservation            @"KLeftDeviceReservation"

#define KRightDeviceReservation           @"KRightDeviceReservation"

#define KPreferenceDeviceId               @"KPreferenceDeviceId"

#define KPreferenceModen                  @"KPreferenceModen"

#define KPreferenceTime                   @"KPreferenceTime"

#define KPreferenceStall                   @"KPreferenceStall"

#define KPreferenceDate                   @"KPreferenceDate"

#define KPreferenceUserInfo               @"KPreferenceUserInfo"


/**************************数据库表名***************************************************/
#define KErrorTableName                   @"error"


/*******************************hud相关参数*************************************************/
#define KHudSuccessShowShortTime          0.8

#define KHudTitleShowShortTime            1.2

#define KHudTitleShowLongTime             2.0

/*******************************枚举**********************************************/
typedef NS_ENUM(NSInteger, VerifyPhoneState) {
    VerifyPhoneStateRegist = 0,
    VerifyPhoneStateFogetPwd = 1
    
};



/**
 *  一般操作成功回调
 */
typedef void (^onSuccess)();

/**
 *  操作失败回调
 *
 *  @param error  错误描述，配合错误码使用，如果问题建议打印信息定位
 */
typedef void (^onFail)(NSError * error);



/**
 *  返回数组回调
 *
 *  @param arr 返回数组
  */
typedef void (^returnArray)(NSArray *arr);


/**
 *  返回字符串回调
 *
 *  @param string 返回字符串
 */
typedef void (^returnString)(NSString *string);


typedef void (^backIdBlock)(id model);


typedef void (^backIdBlock)(id model);


typedef void (^ReceiveBlock)(NSData *data,long tag);



#endif /* GCGlobalStyle_h */

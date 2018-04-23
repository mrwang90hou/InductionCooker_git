//
//  WifiHelper.h
//  InductionCooker
//
//  Created by csl on 2017/7/6.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiHelper : NSObject


+ (BOOL) isConnectDeviceWifi;

+ (NSString *)getWifiName;

+ (void)checkWifiStatus;

+ (instancetype) getInstance;

- (NSString *)getWifiName;

- (BOOL)isConnectDeviceWifi;

- (void)checkWifiStatus;

@end

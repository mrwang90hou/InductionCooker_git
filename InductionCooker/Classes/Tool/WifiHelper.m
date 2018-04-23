//
//  WifiHelper.m
//  InductionCooker
//
//  Created by csl on 2017/7/6.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "WifiHelper.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "MQHudTool.h"
#import "RHSocketConnection.h"

@interface WifiHelper ()

@property (nonatomic,strong) MQHudTool *hud;

@end


@implementation WifiHelper

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


static  WifiHelper *tool;
+ (instancetype) getInstance
{
    
    if (tool==nil) {
        
        tool=[[WifiHelper alloc] init];
        
    }
    return tool;
    
}

-(BOOL)isDeviceWifi
{
    return [[self getWifiName] hasPrefix:KWIFIPrefix];
}


#pragma mark -类方法
+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}



+ (BOOL)isConnectDeviceWifi
{
    return [[self getWifiName] hasPrefix:KWIFIPrefix];
}

+ (void)checkWifiStatus
{
    // 创建
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 启动
    [thread start];
}

#pragma mark -对象方法
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
           // NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (BOOL)isConnectDeviceWifi
{
    return [[self getWifiName] hasPrefix:KWIFIPrefix];
}

- (void)checkWifiStatus
{
    // 创建
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 启动
    [thread start];
}

- (void) run{
    
    while (YES) {
        
        if ([self isConnectDeviceWifi]) {
            
            
            [[NSThread currentThread] cancel];
         
            
        }else{

           
            
        }
        
        sleep(5);
        
    }
    
}



































@end

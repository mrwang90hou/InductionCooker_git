//
//  GCNetStateHelper.m
//  InductionCooker
//
//  Created by csl on 2017/7/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCNetStateHelper.h"

#import "AFNetworking.h"

@interface GCNetStateHelper ()

@end

@implementation GCNetStateHelper

+ (BOOL) isNetCanUse
{
    BOOL isCanUse=NO;
    
    
    
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case -1:
//                NSLog(@"未知网络");
//                break;
//            case 0:
//                NSLog(@"网络不可达");
//                break;
//            case 1:
//                NSLog(@"GPRS网络");
//                break;
//            case 2:
//                NSLog(@"wifi网络");
//                break;
//            default:
//                break;
//        }
//        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
//        {
//          //  NSLog(@"有网");
//        }else
//        {
//
//        }
//    }];
//    
    
   AFNetworkReachabilityStatus status= [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)//有网
    {
        
        isCanUse=YES;
        
    }else
    {
        isCanUse=NO;
        
    }
    
    return isCanUse;
    
    
}

@end

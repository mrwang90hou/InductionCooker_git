//
//  GCHttpTool.h
//  goockr_heart
//
//  Created by csl on 16/10/4.
//  Copyright © 2016年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MQError.h"

@interface GCHttpTool : NSObject



/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Post:(NSString *)URLString
     parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(MQError *error))failure;


@end



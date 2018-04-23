//
//  GCHttpDataTool.m
//  goockr_dustbin
//
//  Created by csl on 2016/11/23.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCHttpDataTool.h"

#import "AFNetworking.h"




@implementation GCHttpDataTool


+(void)getLoginSmsCodeWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpLoginSmsCode];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

    
}

+(void)getForgetSmsCodeWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpForgetSmsCode];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}

+(void)registerWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpRegist];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}



+(void)forgetPwdWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpForgetPwd];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)smsLoginWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpSmsLogin];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
    
    
}


+ (void)pwdLoginWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpLoginPwd];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}

+(void)resetPasswordWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpResetPwd];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)bindingWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpBindingDevice];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}


+ (void)deviceListWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceList];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)deviceChangeUserWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceChangeUser];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}


+ (void)deviceChangeUserSmsCodeWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceChangeUserSmsCode];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}

+ (void)selectDeviceWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpFindSelectDev];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}


+ (void)changeSelectDeviceWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpChangeSelectDev];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}

//http://www.zhuhaiheyi.com/cooker/a/comm/commDeviceRef/delDeviceRef
+ (void)delDeviceRefWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttDelDeviceRef];
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}



@end

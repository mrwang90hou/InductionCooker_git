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
    NSLog(@"当前URL请求【获取验证号登录验证码】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

    
}

+(void)getForgetSmsCodeWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpForgetSmsCode];
    NSLog(@"当前URL请求【获取忘记密码验证码】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}

+(void)registerWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpRegist];
    NSLog(@"当前URL请求【注册】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}



+(void)forgetPwdWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpForgetPwd];
    NSLog(@"当前URL请求【忘记密码】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)smsLoginWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpSmsLogin];
    NSLog(@"当前URL请求【验证码登录】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
    
    
}


+ (void)pwdLoginWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpLoginPwd];
    NSLog(@"当前URL请求【密码登录】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}

+(void)resetPasswordWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpResetPwd];
    NSLog(@"当前URL请求【重设密码】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)bindingWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpBindingDevice];
    NSLog(@"当前URL请求【绑定设备】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        NSLog(@"error.code = %d , error.msg = %@",error.code,error.msg);
//        [ hud hudUpdataTitile:@"绑定产品成功" hideTime:KHudSuccessShowShortTime];
        failure(error);
        
    }];
}


+ (void)deviceListWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceList];
    NSLog(@"当前URL请求【获取设备列表】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];

}


+(void)deviceChangeUserWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceChangeUser];
    NSLog(@"当前URL请求【设备权限转移】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}


+ (void)deviceChangeUserSmsCodeWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpDeviceChangeUserSmsCode];
    NSLog(@"当前URL请求【获取设备权限转移验证码】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}

+ (void)selectDeviceWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpFindSelectDev];
    NSLog(@"当前URL请求【获取选中的设备】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}


+ (void)changeSelectDeviceWithDict:(NSDictionary *)dict success:(void (^)(id))success failure:(void (^)(MQError *))failure
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",KHttpHeader,KHttpChangeSelectDev];
    NSLog(@"当前URL请求【更换选中的设备】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    
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
    
    NSLog(@"当前URL请求【删除已绑定的设备】为：%@",urlString);
    NSLog(@"parameters参数为：%@",dict);
    
    
    [GCHttpTool Post:urlString parameters:dict success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(MQError *error) {
        
        failure(error);
        
    }];
}



@end

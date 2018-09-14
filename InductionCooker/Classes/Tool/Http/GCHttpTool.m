//
//  GCHttpTool.m
//  goockr_heart
//
//  Created by csl on 16/10/4.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCHttpTool.h"

#import "AFNetworking.h"
#import "GCLoginViewController.h"


@implementation GCHttpTool

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    [mgr.requestSerializer setTimeoutInterval:5.0];
    
    [mgr GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
          // NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            
           // NSLog(@"获取到的数据为：%@",dict);
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failure) {
            
            NSLog(@"%@",error);
            failure(error);
            
        }
        
    }];
    
    
}

+ (void)Post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(MQError *error))failure;

{
   
    //[3]	(null)	@"NSLocalizedDescription" : @"Request failed: unacceptable content-type: text/plain"	
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    "PhoneNumber":"13679587672",
    //    "Password":"123456"
    
    //  NSMutableDictionary *dict = @{@"PhoneNumber":@"13679587672",@"Password":@"123456"};
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *mJsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"获取到的数据为：\n%@", [[NSString alloc] initWithData:mJsonData encoding:NSUTF8StringEncoding]);
//        NSDictionary *mResult = [NSJSONSerialization JSONObjectWithData:mJsonData options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"获取到的数据为：%@",[responseObject description]);
//        NSLog(@"获取到的数据为：%@",[mResult description]);

        
        if ([responseObject[@"result"] intValue]!=0)
        {
            MQError *err=[[MQError alloc] init];;
            
            err.code=[responseObject[@"result"] intValue];
            
            err.msg=responseObject[@"msg"];
            
            failure(err);
            
            
        }else{
            
            success(responseObject);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MQError *err=[MQError errorWithCode:-1 msg:@"网络请求失败"];
        
        failure(err);

        
    }];
    

    
   
//    [mgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//        NSLog(@"获取到的数据为：%@",responseObject);
//        
//        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        
//        if (dict[@"result"]!=0)
//        {
//            MQError *err=[[MQError alloc] init];;
//            
//            err.code=[dict[@"result"] intValue];
//            
//            err.code=[dict[@"msg"] intValue];
//            
//            failure(err);
//            
//            
//            
//        }else{
//            
//            success(dict);
//            
//        }
//
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        
//        MQError *err=[MQError errorWithCode:-1 msg:@"网络请求失败"];
//        
//        failure(err);
//        
//    }];

    
   // [self test:nil dictionary:nil];


}

+ (void) test:(NSString *)urlString dictionary:(NSDictionary *)dict
{
    
    
    urlString=@"http://120.24.5.252:8088/api/Account/Login";
    
    dict=@{
           @"PhoneNumber":@"13763085121",
           @"Password":@"123456"
           };
    
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    "PhoneNumber":"13679587672",
    //    "Password":"123456"
    
    //  NSMutableDictionary *dict = @{@"PhoneNumber":@"13679587672",@"Password":@"123456"};
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 5.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
   
    
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
    
    


    
}
//responseObject是接口返回来的Unicode数据
//NSLog(@" %@",[self transformDic:responseObject]);
- (NSString *)transformDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\"u" withString:@"\"U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@""  withString:@"\""];
    NSString *tempStr3 = [[@"" stringByAppendingString:tempStr2] stringByAppendingString:@""];
     NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
     NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
     return str;
 }



@end


























//
//  GCUser.m
//  InductionCooker
//
//  Created by csl on 2017/6/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCUser.h"

@implementation GCUser

static GCUser *user;

+ (instancetype) getInstance{
 
    
    if (user==nil) {
        
        user=[[GCUser alloc] init];
        
    }
    
    
    return  user;
}

- (instancetype)init
{
    if (self=[super init]) {
        
        self.device= [[GCDevice alloc] init];
        
        self.deviceList=[NSMutableArray array];
        
    }
    
    return self;
}


+(instancetype)createModelWithDict:(NSDictionary *)dict
{
    
    GCUser *model=[[GCUser alloc] init];
    
    
    model.name=dict[@"name"];
    
    model.mobile=dict[@"mobile"];
    
    model.userId=dict[@"id"];
    
    model.token=dict[@"token"];
    
    return model;
    
}

- (void) updateUserInfoWithdict:(NSDictionary *)dict
{
    
    self.name=dict[@"name"];
    
    self.mobile=dict[@"mobile"];
    
    self.userId=dict[@"id"];
    
    self.token=dict[@"token"];
    
    

}


- (void)clearUserInfo
{
    self.name=nil;
    
    self.mobile=nil;
    
    self.userId=nil;
    
    self.token=nil;
    
    self.device=[[GCDevice alloc] init];;
    
    [self.deviceList removeAllObjects];
    
    self.device.leftDevice.selModen=nil;
    
    self.device.rightDevice.selModen=nil;

}



























@end

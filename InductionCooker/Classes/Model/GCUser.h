//
//  GCUser.h
//  InductionCooker
//
//  Created by csl on 2017/6/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDevice.h"

@interface GCUser : NSObject



@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,strong) GCDevice *device;

@property (nonatomic,strong) NSMutableArray *deviceList;

+ (instancetype) getInstance;

- (void) updateUserInfoWithdict:(NSDictionary *)dict;

- (void) clearUserInfo;


@end

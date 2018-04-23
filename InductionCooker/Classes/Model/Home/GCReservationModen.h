//
//  GCReservationModen.h
//  InductionCooker
//
//  Created by csl on 2017/8/5.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCReservationModen : NSObject

@property (nonatomic,assign) int deviceId;

@property (nonatomic,assign) int modenId;

@property (nonatomic,assign) long date;

@property (nonatomic,assign) int time;

@property (nonatomic,assign) int stall;

+ (instancetype) createModelWithDict:(NSDictionary *)dict;

@end

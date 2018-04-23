//
//  GCReservationModen.m
//  InductionCooker
//
//  Created by csl on 2017/8/5.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationModen.h"

@implementation GCReservationModen

+(instancetype)createModelWithDict:(NSDictionary *)dict
{
    
    GCReservationModen *model=[[GCReservationModen alloc] init];
    
    model.deviceId=dict[KPreferenceDeviceId]==nil?0 :[dict[KPreferenceDeviceId] intValue];
    
    model.modenId=dict[KPreferenceModen]==nil?0:[dict[KPreferenceModen] intValue];
    
    model.date=dict[KPreferenceDate]==nil?0:[dict[KPreferenceDate] longValue];
    
    model.time=dict[KPreferenceTime]==nil?0:[dict[KPreferenceTime] intValue];
    
    model.stall=dict[KPreferenceStall]==nil?0:[dict[KPreferenceStall] intValue];
    
    return model;
    
}


@end

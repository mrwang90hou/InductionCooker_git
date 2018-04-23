//
//  GCModen.m
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCModen.h"

@implementation GCModen

+(instancetype)createModelWithDict:(NSDictionary *)dict
{
    
    GCModen *model=[[GCModen alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    model.reservationWorkTime=0;
    
    model.currentStall=-1;
    
    return model;
    
}


@end

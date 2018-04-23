//
//  MQError.m
//  InductionCooker
//
//  Created by csl on 2017/8/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "MQError.h"

@implementation MQError

+ (MQError *) errorWithCode:(int) code msg:(NSString *)msg
{
    MQError *error=[[MQError alloc] init];
    
    error.code=code;
    
    error.msg=msg;
    
    return error;
    
}

@end

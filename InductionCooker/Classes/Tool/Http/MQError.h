//
//  MQError.h
//  InductionCooker
//
//  Created by csl on 2017/8/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQError : NSObject

@property (nonatomic,assign) int code;

@property (nonatomic,copy) NSString *msg;

+ (MQError *) errorWithCode:(int) code msg:(NSString *)msg;

@end

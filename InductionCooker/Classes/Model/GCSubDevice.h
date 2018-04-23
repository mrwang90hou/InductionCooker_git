//
//  GCSubDevice.h
//  InductionCooker
//
//  Created by csl on 2017/8/5.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCSubDevice : NSObject

@property (nonatomic,assign) int powerState;

@property (nonatomic,assign) BOOL hasReservation;

@property (nonatomic,strong) GCModen *selModen;

@end

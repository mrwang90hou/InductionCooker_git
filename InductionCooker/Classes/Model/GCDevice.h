//
//  GCDevice.h
//  InductionCooker
//
//  Created by csl on 2017/6/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCModen.h"
#import "GCSubDevice.h"


@interface GCDevice : NSObject

@property (nonatomic,copy) NSString *deviceId;

//@property (nonatomic,assign) int leftPowerState;
//
//@property (nonatomic,assign) int rightPowerState;

//@property (nonatomic,strong) GCModen *leftSelModen;
//
//@property (nonatomic,strong) GCModen *rightSelModen;

@property (nonatomic,copy) NSString *deviceName;

@property (nonatomic,assign) int code;

@property (nonatomic,strong) GCSubDevice *leftDevice;

@property (nonatomic,strong) GCSubDevice *rightDevice;

@property (nonatomic,assign) int error;

- (void) resetSubdevice;


@end


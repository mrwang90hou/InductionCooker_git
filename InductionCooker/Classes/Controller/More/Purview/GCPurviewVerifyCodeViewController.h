//
//  GCPurviewVerifyCodeViewController.h
//  InductionCooker
//
//  Created by csl on 2017/9/29.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDevice.h"

@interface GCPurviewVerifyCodeViewController : UIViewController

@property (nonatomic,copy) NSString *phone;

@property (nonatomic,strong) GCDevice *device;

@end

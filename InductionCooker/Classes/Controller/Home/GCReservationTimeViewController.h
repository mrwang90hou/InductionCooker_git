//
//  GCReservationTimeViewController.h
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModen.h"

@interface GCReservationTimeViewController : UIViewController

@property (nonatomic,strong) GCModen *moden;

@property (nonatomic,assign) long date;

@property (nonatomic,assign) int deviceId;


@end

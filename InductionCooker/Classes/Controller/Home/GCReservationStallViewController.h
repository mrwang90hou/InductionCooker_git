//
//  GCReservationStallViewController.h
//  InductionCooker
//
//  Created by csl on 2017/9/29.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCModen.h"


@interface GCReservationStallViewController : UIViewController

@property (nonatomic,strong) GCModen *moden;

@property (nonatomic,assign) int deviceId;

@property (nonatomic,assign) long date;

@property (nonatomic,assign) int time;


@end

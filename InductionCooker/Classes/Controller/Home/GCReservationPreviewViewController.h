//
//  GCReservationPreviewViewController.h
//  InductionCooker
//
//  Created by csl on 2017/6/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModen.h"
#import "GCReservationModen.h"

@interface GCReservationPreviewViewController : UIViewController

@property (nonatomic,strong) GCReservationModen *reservationModen;

@property (nonatomic,assign) int deviceId;




@end

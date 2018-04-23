//
//  GCDeviceListViewController.h
//  InductionCooker
//
//  Created by csl on 2017/11/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDevice.h"

@protocol GCDeviceListViewControllerDelegate <NSObject>

- (void)portableDeviceSelected:(GCDevice *)device;

@end

@interface GCDeviceListViewController : UIViewController

@property (nonatomic,strong)  NSMutableArray *dataSoucre;

@property (nonatomic,weak) id<GCDeviceListViewControllerDelegate> delegate;

@end


//
//  GCAdjustViewController.h
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModen.h"

@protocol GCAdjustViewControllerDelegate <NSObject>

- (void) removeButtonClickWithDeivceId:(int)deviceId;


@end

@interface GCAdjustViewController : UIViewController

@property (nonatomic,assign) int deviceId;

@property (nonatomic,strong) GCModen *moden;

@property (nonatomic,weak) id<GCAdjustViewControllerDelegate> delegate;

- (void) updateViewWithModen:(GCModen *)moden;

- (void) showAdjustView:(BOOL)show;

@end

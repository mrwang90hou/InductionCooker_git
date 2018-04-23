//
//  GCReservationModenView.h
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCModen;

@interface GCReservationModenView : UIView

+ (instancetype)loadViewFromXibWithiType:(NSInteger)type;

@property (nonatomic,strong)  GCModen *selModen;

@end

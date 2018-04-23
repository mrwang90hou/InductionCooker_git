//
//  GCRightDeivceView.h
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCModenButton;
@class GCModen;

@protocol GCRightDeivceViewDelegate <NSObject>


- (void) rightModenButtonClick:(GCModenButton *)button;

- (void) rightReservationButtonClick;

- (void) rightUnreservationButtonClick;

- (void) changeDeivceButtonClick;

@end

@interface GCRightDeivceView : UIView

@property (assign, nonatomic) BOOL isConection;

@property (nonatomic,weak) id<GCRightDeivceViewDelegate> delegate;

+ (instancetype)loadViewFromXib;


-(GCModen *)updateModen:(int)moden;

- (void) powerState:(BOOL)state hasReservation:(BOOL)has monden:(int) moden;

- (void) reservationStateChange:(int)state;


@end

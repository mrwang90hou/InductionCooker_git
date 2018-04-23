//
//  GCLeftDeivceView.h
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCModenButton;
@class GCModen;

@protocol GCLeftDeivceViewDelegate <NSObject>


- (void) leftModenButtonClick:(GCModenButton *)button;

- (void) leftReservationButtonClick;

- (void) leftUnreservationButtonClick;

- (void) changeDeivceButtonClick;


@end

@interface GCLeftDeivceView : UIView

@property (assign, nonatomic) BOOL isConection;

@property (nonatomic,weak) id<GCLeftDeivceViewDelegate> delegate;


+ (instancetype) loadViewFromXib;

- (GCModen *) updateModen:(int) moden;


- (void) powerState:(BOOL)state hasReservation:(BOOL)has monden:(int) moden;

- (void) reservationStateChange:(int)state;

@end

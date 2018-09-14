//
//  GCSegmentedControl.h
//  InductionCooker
//
//  Created by csl on 2017/6/9.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCSegmentedControlDelegate <NSObject>

- (void)segmentedValueChange:(NSInteger)value;

@end

@interface GCSegmentedControl : UIView


+ (instancetype)loadViewFromXib;


@property (nonatomic,weak) id<GCSegmentedControlDelegate> delegate;

@property (nonatomic,assign) NSInteger selectIndex;

- (void) itemIndex:(int)index isWarm:(BOOL) warm;

- (void) updateItemWithIndex:(int) index title:(NSString *)title;
- (void) updateItemWithIndex:(int)index stallsMode:(int)stallsMode;

@end

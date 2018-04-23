//
//  GCModenButton.h
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCModen.h"

@protocol GCModenButtonDelegate <NSObject>

- (void) buttonClick:(UIButton *)button;

@end

// 在定义类的前面加上IB_DESIGNABLE宏,确保该控件在xib或storyboard上可以实时渲染
IB_DESIGNABLE
@interface GCModenButton : UIButton


@property (nonatomic,assign) IBInspectable BOOL isCanAutoWork;

@property (nonatomic,strong) GCModen *moden;

@property (nonatomic,weak) id<GCModenButtonDelegate> delegate;

@end

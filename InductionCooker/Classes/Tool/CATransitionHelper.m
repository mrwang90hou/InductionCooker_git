//
//  CATransitionHelper.m
//  InductionCooker
//
//  Created by csl on 2017/6/15.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "CATransitionHelper.h"

@implementation CATransitionHelper

+ (void) addTransitionWithLayer:(CALayer *)layer animationType:(NSString *)type subtype:(NSString *)subtype duration:(float)duration
{
    CATransition *leftAnimation = [CATransition animation];
    leftAnimation.type = type;
    leftAnimation.subtype=subtype;
    leftAnimation.duration = duration;
    [layer addAnimation:leftAnimation forKey:nil];

}

@end

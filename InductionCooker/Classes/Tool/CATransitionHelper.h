//
//  CATransitionHelper.h
//  InductionCooker
//
//  Created by csl on 2017/6/15.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATransitionHelper : NSObject

+ (void) addTransitionWithLayer:(CALayer *)layer animationType:(NSString *)type subtype:(NSString *)subtype duration:(float)duration;

@end

//
//  GCDiscoverView.h
//  InductionCooker
//
//  Created by csl on 2017/7/6.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDiscoverView : UIView

+ (void) showWithTip:(NSString *)tip;

+ (void) showInSupview:(UIView *)supView tip:(NSString *)tip;

+ (void) showWithTip:(NSString *)tip cancelClick:(onSuccess) success;

@end

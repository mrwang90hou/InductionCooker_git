//
//  MQButtonCountDownTool.m
//  InductionCooker
//
//  Created by csl on 2017/8/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "MQButtonCountDownTool.h"

#define KCountDown              59
#define KButtonNormTitle        @"获取验证码"
#define KButtonCountDownFoot    @"重新发送"

@implementation MQButtonCountDownTool


+(void)startTimeWithButton:(UIButton *)button
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:KButtonNormTitle forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [button setTitle:[NSString stringWithFormat:@"%@s %@",strTime,KButtonCountDownFoot] forState:UIControlStateNormal];
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
}


@end

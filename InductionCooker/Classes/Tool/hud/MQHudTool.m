//
//  MQHudTool.m
//  goockr_dustbin
//
//  Created by csl on 2016/11/8.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "MQHudTool.h"

#import "MBProgressHUD.h"

#import "AppDelegate.h"

@interface MQHudTool ()<MBProgressHUDDelegate>

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) onSuccess succ;


@end

@implementation MQHudTool

static MQHudTool  *tool;


+ (instancetype) shareHudTool
{
    
    if (tool==nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            tool=[[MQHudTool alloc] init];
            
        });
        
    }
    return tool;
    
}

- (BOOL)isShow
{
    if (self.hud) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark -hud 添加
- (void) addTipHudWithTitle:(NSString *) title
{
    if ([AppDelegate sharedAppDelegate].hadShowAlert) {
        return;
    }
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    
    self.hud=[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    
    [myWindow addSubview:_hud];
    
    _hud.mode = MBProgressHUDModeText;
    
    _hud.removeFromSuperViewOnHide = YES;
    
    
    _hud.labelText=title;
    
    [_hud show:YES];
    
    [_hud hide:YES afterDelay:0.5];
    
}

- (void) addTipHudWithTitle:(NSString *) title timeInterval:(NSTimeInterval) time
{
    if ([AppDelegate sharedAppDelegate].hadShowAlert) {
        return;
    }
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    
    self.hud=[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    
    [myWindow addSubview:_hud];
    
    _hud.mode = MBProgressHUDModeText;
    
    _hud.removeFromSuperViewOnHide = YES;
    
    
    _hud.labelText=title;
    
    [_hud show:YES];
    
    [_hud hide:YES afterDelay:time];
    
}



- (void) addNormHudWithSupView:(UIView *) supView title:(NSString *)title
{
    if ([AppDelegate sharedAppDelegate].hadShowAlert) {
        return;
    }
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    
    self.hud= [[MBProgressHUD alloc] init];
    
    
    self.hud.delegate=self;
    
    [supView addSubview:_hud];
    
    
    _hud.labelText=title;
    
    [_hud show:YES];
    
}


- (void) addHudWithTitle:(NSString *) title onWindow:(UIWindow *)window
{
    if ([AppDelegate sharedAppDelegate].hadShowAlert) {
        return;
    }
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    
    if (self.hud) {
        return;
    }
    
    self.hud=[[MBProgressHUD alloc] initWithWindow:window];
    
    [window addSubview:_hud];
    
    _hud.removeFromSuperViewOnHide = YES;
    
    _hud.labelText=title;
    
    [_hud show:YES];
    
}





#pragma mark -hud 更新
//NSTimeInterval
- (void) hidHudWithHideTime:(NSTimeInterval)time{
    
    if (_hud) {
        [ _hud hide:YES afterDelay:time];
        
    }
    
}

- (void) hudUpdataTitile:(NSString *)title hideTime:(NSTimeInterval)time
{
    if (_hud) {
        
        _hud.mode=MBProgressHUDModeText;
        _hud.labelText=title;
        
        [self hidHudWithHideTime:time];
        
    }
}







- (void) successShowHudWithTitle:(NSString *)title
{
    self.hud=[[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    
    [myWindow addSubview:_hud];
    
    _hud.mode = MBProgressHUDModeText;
    
    _hud.removeFromSuperViewOnHide = YES;
    
    
    _hud.labelText=title;
    
    [_hud show:YES];
    
    
     [_hud hide:YES afterDelay:1];

}

- (void)hudUpdataTitile:(NSString *)title hideTime:(NSTimeInterval)time success:(onSuccess)succ
{
    self.succ=succ;
    
    if (_hud) {
        
        _hud.mode=MBProgressHUDModeText;
        _hud.labelText=title;
        
        [self hidHudWithHideTime:time];
        
    }
}

- (void) hide{
    
    [AppDelegate sharedAppDelegate].hadShowAlert = NO;
    
    if (_hud) {
        [_hud hide:NO];
    }
    
}



#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [AppDelegate sharedAppDelegate].hadShowAlert = NO;
    if ([_delegate respondsToSelector:@selector(MQHudWasHidWithhud:)]) {
        [_delegate MQHudWasHidWithhud:self];
    }
    
    if (_succ) {
        _succ();
    }
    
    if (_hud) {
        [hud removeFromSuperview];
        hud=nil;
  
    }
}


@end

































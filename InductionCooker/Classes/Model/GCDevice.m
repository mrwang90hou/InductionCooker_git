//
//  GCDevice.m
//  InductionCooker
//
//  Created by csl on 2017/6/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCDevice.h"



@interface GCDevice ()



@end


@implementation GCDevice


-(NSString *)deviceId
{
      
    return _deviceId;
}


- (instancetype)init
{
    if (self=[super init]) {
        
     //   self.leftSelModen=[[GCModen alloc] init];
    //    self.rightSelModen=[[GCModen alloc] init];
        
        self.leftDevice=[[GCSubDevice alloc] init];
        self.rightDevice=[[GCSubDevice alloc] init];
        self.error=0;
        
    }
    
    return self;
}

- (void)setError:(int)error
{
    _error=error;
    
    
    UIViewController *rootVc=myWindow.rootViewController;
    
    UITabBarController *tabbarVc=nil;
    
    if ([rootVc isKindOfClass:[UITabBarController class]]) {
        
        tabbarVc=(UITabBarController *)rootVc;
        
        UITabBar *tabar=tabbarVc.tabBar;
        
        UITabBarItem *item=tabar.items[1];
        
        if (error==0) {
            item.badgeValue=nil;
        }else
        {
            NSString *badgeValue=error>99?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%d",error];
            item.badgeValue=badgeValue;
        }
        
    }
 
    
}


- (void)resetSubdevice
{
    
    self.leftDevice=[[GCSubDevice alloc] init];
    self.rightDevice=[[GCSubDevice alloc] init];
    
}



@end

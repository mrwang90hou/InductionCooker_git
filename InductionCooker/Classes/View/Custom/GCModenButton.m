//
//  GCModenButton.m
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCModenButton.h"
#import "UIView+NTES.h"

#import "WifiHelper.h"
#import "GCDiscoverView.h"
#import "GCUser.h"
#import "GCLoginViewController.h"
#import "AppDelegate.h"


@implementation GCModenButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        
      //  [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        //[self sendAction:@selector(buttonClick) to:self forEvent:UIControlEventTouchUpInside];
        
        
    }
    
    return self;
}


- (void) buttonClick
{
    if ([_delegate respondsToSelector:@selector( buttonClick:)]) {
        
        [_delegate buttonClick:self];
        
    }
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //self.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.numberOfLines=0;
    
    self.titleLabel.font=[UIFont systemFontOfSize:KScreenScaleValue(16)];
    
   // self.imageView.contentMode=UIViewContentModeCenter;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat screenScale=KScreenWidth/414.0;
//
//    CGFloat imageViewWidth=self.width*screenScale;
//
//    CGFloat imageViewHeight=self.width*(132/122)*screenScale;
    
    CGFloat width=self.width;
    CGFloat height=self.height;
    
    self.imageView.frame=CGRectMake(0, 0, self.width, self.width);
    
    float y=CGRectGetMaxY(self.imageView.frame)-KScreenScaleValue(2);
    
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    float x=self.width/2-(labelsize.width/2);
    self.titleLabel.frame=CGRectMake(x,y, labelsize.width, labelsize.height);
    
    
}

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    
    if ([GCUser getInstance].userId==nil)
    {
        [GCDiscoverView showWithTip:@"请先登录,再进行操作!" cancelClick:^{
            
            [self intoLogin];
            
        }];
        return ;
    }
    
    if ([GCUser getInstance].device.deviceId==nil)
    {
        [GCDiscoverView showWithTip:@"当前产品列表为空!" cancelClick:^{
            
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [app getDeviceListWithShowTip:YES];
            
        }];

        return ;
    }

    
    if ([[RHSocketConnection getInstance] isConnected]) {
        
    
        
          //[RHSocketConnection getInstance].isDeviceDisconnect=YES;
          [super sendAction:action to:target forEvent:event];
      
        
    }else{
        

        [GCDiscoverView showWithTip:@"请先连接服务器,再进行操作!" cancelClick:^{
            
            [[RHSocketConnection getInstance] connectWithHost:KIP port:KPort];
            
        }];

        
        
    }
    
    
}


- (void) intoLogin
{
    
    UITabBarController *tabbarVc=(UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *nav=tabbarVc.childViewControllers[0];
    
    GCLoginViewController *loginVc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
    
    [nav pushViewController:loginVc animated:YES];
    
    
    
}
























@end

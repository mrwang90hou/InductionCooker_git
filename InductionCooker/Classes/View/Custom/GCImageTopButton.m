//
//  GCImageTopButton.m
//  InductionCooker
//
//  Created by csl on 2017/6/12.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCImageTopButton.h"

#import "UIView+NTES.h"
#import "WifiHelper.h"
#import "GCDiscoverView.h"
#import "RHSocketConnection.h"
#import "GCLoginViewController.h"
#import "AppDelegate.h"


@interface GCImageTopButton ()



@end

@implementation GCImageTopButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        UIImageView *tipImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reservation_Badge"]];
        
        [self addSubview:tipImageView];
        
        self.tipImageView=tipImageView;
        
        tipImageView.hidden=YES;
    }
    
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
        UIImageView *tipImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reservation_Badge"]];
        
        [self addSubview:tipImageView];
        
        self.tipImageView=tipImageView;
         tipImageView.hidden=YES;
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect labelFrame = self.titleLabel.frame;
    
    float margin=2;
    
    float imageY=(self.height-self.imageView.image.size.height-labelFrame.size.height-margin)/2;
    
    float imageX=(self.width-self.imageView.image.size.width)/2;
    
    self.imageView.frame=CGRectMake(imageX, imageY, self.imageView.image.size.width, self.imageView.image.size.height);
    
    NSDictionary * attributes = @{NSFontAttributeName:self.titleLabel.font};
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    self.titleLabel.frame=CGRectMake(self.width/2-(size.width/2), CGRectGetMaxY(self.imageView.frame)+margin, size.width, labelFrame.size.height);
    
    int tipImageViewWidth=10;
    
    self.tipImageView.frame=CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, tipImageViewWidth, tipImageViewWidth);
    
    
    
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
        
    
        if(self.tag!=555)
        {
             [RHSocketConnection getInstance].isDeviceDisconnect=YES;
        }
       
        
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

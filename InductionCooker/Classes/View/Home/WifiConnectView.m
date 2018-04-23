//
//  WifiConnectView.m
//  InductionCooker
//
//  Created by csl on 2017/11/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "WifiConnectView.h"

@interface WifiConnectView ()

@property (weak,nonatomic) UIButton *content_bt;

@property (nonatomic,strong) NSArray *typeArr;

@property (nonatomic,weak) UIImageView *connecting_iv;

@end

@implementation WifiConnectView


- (NSArray *)typeArr
{
    if (_typeArr==nil) {
        _typeArr=@[@"未连接",@"已连接"];
    }
    return _typeArr;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        [btn setBackgroundImage:[UIImage imageNamed:@"connection_status_box"] forState:UIControlStateNormal];


        [btn setTitle:self.typeArr[0] forState:UIControlStateNormal];

        [btn setTitleColor:UIColorFromRGB(KMainColor) forState:UIControlStateNormal];

        btn.titleLabel.font=[UIFont systemFontOfSize:9];

        [btn setUserInteractionEnabled:NO];
        
        UIImageView *imageView=[[UIImageView alloc] init];

        NSArray *imageArr=@[[UIImage imageNamed:@"connection_status_spot1"],[UIImage imageNamed:@"connection_status_spot2"],[UIImage imageNamed:@"connection_status_spot3"]];

        imageView.animationImages=imageArr;

        imageView.hidden=YES;

        imageView.animationDuration = 1.0;
        // repeat the annimation forever
        imageView.animationRepeatCount = 0;

//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [btn setBackgroundImage:[UIImage imageNamed:@"connection_status_box"] forState:UIControlStateNormal];
//
//
//        [btn setTitle:self.typeArr[0] forState:UIControlStateNormal];
//
//        [btn setTitleColor:UIColorFromRGB(KMainColor) forState:UIControlStateNormal];
//
//        btn.titleLabel.font=[UIFont systemFontOfSize:9];
//
//        [btn setUserInteractionEnabled:NO];
//
        [self addSubview:btn];
//
//        _content_bt = btn;
        
        [self addSubview:imageView];
        
        self.connecting_iv=imageView;
        
        self.content_bt=btn;
        
    }
    
    
    return self;
}


//- (void)setWifiConnectType:(WifiConnectType)type
//{
//
//    if (type==WifiConnectTypeDisconnect) {
//
//
//
//
//    }else if (type==WifiConnectTypeConnecting)
//    {
//
//
//
//
//
//    }else if(type==WifiConnectTypeConnected)
//    {
//
//
//
//
//    }
    
    
//    int state=(int) type;
//
//    [self.content_bt setTitle:self.typeArr[state] forState:UIControlStateNormal];
//
//    if (type==WifiConnectTypeConnecting) {
//
//        self.connecting_iv.hidden=NO;
//        [self.connecting_iv startAnimating];
//
//    }else{
//
//        [self.connecting_iv stopAnimating];
//        self.connecting_iv.hidden=YES;
//
//    }
//    
//  
//
//    
//}

- (void) setWifiConnectLabelTitleWithIndex:(int) status
{
    [self.content_bt setTitle:self.typeArr[status] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.content_bt.frame=self.bounds;

    self.connecting_iv.frame=self.bounds;

}














@end

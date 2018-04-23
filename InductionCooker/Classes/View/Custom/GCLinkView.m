//
//  GCLinkView.m
//  InductionCooker
//
//  Created by csl on 2017/7/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCLinkView.h"

#import "Masonry.h"

@interface GCLinkView ()

@property (nonatomic,weak) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,weak) UILabel *tipLabel;

@end

@implementation GCLinkView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityView];
        self.activityIndicatorView=activityView;
        activityView.hidesWhenStopped=YES;
        
        
        UILabel *label=[[UILabel alloc] init];
        [self addSubview:label];
        self.tipLabel=label;
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor grayColor];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityView];
        self.activityIndicatorView=activityView;
        activityView.hidesWhenStopped=YES;
        
        
        UILabel *label=[[UILabel alloc] init];
        [self addSubview:label];
        self.tipLabel=label;
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor grayColor];

        
    }
    
    return self;
}

- (void) linkStateChange:(DeviceLinkState) state
{
    
    if (state==DeviceLinkStateLinking) {
        
        [self.activityIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.width.mas_equalTo(self.mas_height);
            make.height.mas_equalTo(self.mas_height);
            
        }];
        
        [self.activityIndicatorView startAnimating];
        
        self.tipLabel.text=@"正在连接产品";
        
    }else{
        
        [self.activityIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
            
        }];

        
        [self.activityIndicatorView stopAnimating];
        
        if (state==DeviceLinkStateLinked)
        {
            
            self.tipLabel.text=@"已连接";
            
        }else if (state==DeviceLinkStateNoneNet)
        {
            self.tipLabel.text=@"未连接产品WIFI";
        }

        
    }
    
    [self layoutIfNeeded];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.activityIndicatorView.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    
    
}











































@end

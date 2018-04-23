//
//  GCDiscoverView.m
//  InductionCooker
//
//  Created by csl on 2017/7/6.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCDiscoverView.h"
#import "UIView+NTES.h"

@interface GCDiscoverView()

@property (nonatomic,weak) UIImageView *bgImageView;

@property (nonatomic,weak) UIImageView *tipImageView;

@property (nonatomic,weak) UIButton *cancel_bt;

@property (nonatomic,weak) UILabel *tipLabel;

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,strong) onSuccess success;



@end

@implementation GCDiscoverView

+ (void) showInSupview:(UIView *)supView tip:(NSString *)tip
{
    GCDiscoverView *view=[[GCDiscoverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight)];
 
    //CGRect rect=supView.bounds;
    
    view.tipLabel.text=tip;
    
    [supView addSubview:view];
    
}


+ (void) showWithTip:(NSString *)tip
{
    GCDiscoverView *view=[[GCDiscoverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight)];
    
    //CGRect rect=supView.bounds;
    
    view.tipLabel.text=tip;
    
    [myWindow addSubview:view];
    
}

+ (void) showWithTip:(NSString *)tip cancelClick:(onSuccess) success
{
    GCDiscoverView *view=[[GCDiscoverView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScreenHeight)];
    
    //CGRect rect=supView.bounds;
    
    view.tipLabel.text=tip;
    
    view.success=success;
    
    [myWindow addSubview:view];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
       
        [self createUI];
        
        
    }
    
    return self;
}


- (void) createUI{
    
   // self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
    
   // self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    
    UIView *contentView=[[UIView alloc] init];
    [self addSubview:contentView];
    self.contentView=contentView;
   // contentView.backgroundColor=[UIColor grayColor];
    
    UIImageView *bgImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_popup_bg"]];
    [self.contentView addSubview:bgImageview];
    self.bgImageView=bgImageview;
    
    
    UIImageView *tipImageView=[[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"home_pop_icon"]];
    [self.contentView addSubview:tipImageView];
    self.tipImageView=tipImageView;
    
    UIButton *cancel_bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancel_bt setImage:[UIImage imageNamed:@"pop_icon_delete"] forState:UIControlStateNormal];
    [cancel_bt setImage:[UIImage imageNamed:@"pop_icon_delete_pressed"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:cancel_bt];
    self.cancel_bt =cancel_bt;
    
    
    UILabel *tipLabel=[[UILabel alloc] init];
    [self.contentView addSubview:tipLabel];
    
    UIFont *font= [UIFont fontWithName:@"AmericanTypewriter-Bold" size:KScreenScaleValue(18)];;
    tipLabel.font=font;
    
    tipLabel.textColor=[UIColor blackColor];
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.numberOfLines=0;

    self.tipLabel=tipLabel;
    
    [cancel_bt addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void) cancelButtonClick:(UIButton *)bt
{
    [self removeFromSuperview];
    
    if (self.success) {
        self.success();

    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float contentViewWidth=KScreenScaleValue(636/2);
    
    float contentViewHeight=KScreenScaleValue(402/2) ;
    
    self.contentView.frame=CGRectMake((self.width-contentViewWidth)/2, (self.height-contentViewHeight)/2, contentViewWidth, contentViewHeight);
    
    
    self.bgImageView.frame=self.contentView.bounds;
    
    [self.tipImageView sizeToFit];
    self.tipImageView.center=CGPointMake(self.contentView.width/2, self.contentView.height*0.10+57);
    
    
    float tipLabelMargin=KScreenScaleValue(30);
    float tipLabelMarginTop=10;
    CGSize size = [self.tipLabel sizeThatFits:CGSizeMake(self.contentView.width-(tipLabelMargin*2), MAXFLOAT)];
    
    self.tipLabel.frame=CGRectMake(tipLabelMargin, CGRectGetMaxY(self.tipImageView.frame)+tipLabelMarginTop, self.contentView.width-(tipLabelMargin*2),size.height );
    
    float bt_width=40;
    float bt_height=40;
    float bt_magrin=5;
    self.cancel_bt.frame=CGRectMake(self.contentView.width-40-bt_magrin, bt_magrin, bt_width, bt_height);
    
    
    
    
    
}


































@end

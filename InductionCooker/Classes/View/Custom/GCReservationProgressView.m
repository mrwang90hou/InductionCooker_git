//
//  GCReservationProgressView.m
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationProgressView.h"

#import "Masonry.h"
#import "UIView+NTES.h"

@interface GCReservationProgressView ()

@property (nonatomic,strong) NSMutableArray *buttonList;

@property (nonatomic, strong) NSMutableArray *lineViewList;

@property (nonatomic,strong) NSMutableArray *tipLabelList;

@end

@implementation GCReservationProgressView

-(NSMutableArray *)buttonList
{
    if (_buttonList==nil) {
        _buttonList=[NSMutableArray array];
    }
    return _buttonList;
}

-(NSMutableArray *)imageViewList
{
    if (_buttonList==nil) {
        _buttonList=[NSMutableArray array];
    }
    return _buttonList;
}

- (NSMutableArray *)lineViewList
{
    if (_lineViewList==nil) {
        _lineViewList=[NSMutableArray array];
    }
    return _lineViewList;
}

-(NSMutableArray *)tipLabelList
{
    if (_tipLabelList==nil) {
        
        _tipLabelList=[NSMutableArray array];
        
    }
    return _tipLabelList;
}


#pragma mark -改变进度
- (void)setProgress:(int)progress{
    
    if (progress>self.count||progress<1) {
        return;
    }
    
    
    if (_progress<progress) {
        
//        for (int i=0; i<progress; i++) {
//            
//            UIButton *bt=self.buttonList[i];
//
//            if (i==progress-1) {
//                [bt setImage:[UIImage imageNamed:@"message_edit"] forState:UIControlStateNormal];
//            }else{
//
//                
//                [bt setImage:[UIImage imageNamed:@"message_edited"] forState:UIControlStateNormal];
//            }
//            
//        }
        
        UIButton *bt=self.buttonList[_progress-1];
        [bt setImage:[UIImage imageNamed:@"message_edited"] forState:UIControlStateNormal];
        
        
        UIButton *bt_1 =self.buttonList[progress-1];
        [bt_1 setImage:[UIImage imageNamed:@"message_edit"] forState:UIControlStateNormal];

        
        
        UIView *view=self.lineViewList[progress-2];
        view.backgroundColor=UIColorFromRGB(KMainColor);

      

        
    }else if(_progress>progress)
    {
        
        UIButton *bt=self.buttonList[progress-1];
        [bt setImage:[UIImage imageNamed:@"message_edit"] forState:UIControlStateNormal];

        
        UIButton *bt_1 =self.buttonList[_progress-1];
        [bt_1 setImage:[UIImage imageNamed:@"message_nor_edited"] forState:UIControlStateNormal];

        UIView *view=self.lineViewList[_progress-2];
        view.backgroundColor=[UIColor grayColor];
        
        
        
    }else{
        if (progress==1) {
            UIButton *bt=self.buttonList[progress-1];
            [bt setImage:[UIImage imageNamed:@"message_edit"] forState:UIControlStateNormal];

        }
    }
    
    
    _progress=progress;

    
//    for (int i=0; i<self.count; i++) {
//        
//        if (i<progress) {
//            
//            UIButton *bt=self.buttonList[i];
//            if (i+1<progress) {
//                
//                bt.enabled=YES;
//                bt.selected=YES;
//                UIView *view=self.lineViewList[i];
//                view.backgroundColor=UIColorFromRGB(KMainColor);
//                
//            }else{
//                
//                bt.enabled=false;
//                
//            }
//
//        }else{
//            
//             UIButton *bt=self.buttonList[i];
//             bt.enabled=YES;
//             bt.selected=NO;
//            if (i+1<self.count) {
//                UIView *view=self.lineViewList[i];
//                view.backgroundColor=[UIColor grayColor];
//            }
//        }
//        
//        
//    }
    
    
    
}

#pragma mark -initWithFrame
- (instancetype)initWithCount:(int) count tips:(NSArray *)tips
{
    
    if (self=[super init]) {
        
        self.userInteractionEnabled=NO;
        
        self.count=count;
        
        self.tipArray=tips;
        
        _progress=1;
        
        for (int i=0; i<count;i++ ) {
            
            if (i+1<count) {
                
                UIView *view=[self viewWithbackgroundColor:UIColorFromRGB(0xe6e6e6)];
                [self.lineViewList addObject:view];
                
            }

            
            UIButton *bt=[self buttonWithNormImageName:@"message_nor_edited" selImageName:@"message_edited" disableImageName:@"message_edit"];
            
            [self.buttonList addObject:bt];
            
            UILabel *la=[self labelWithTitle:tips[i]];
            [self.tipLabelList addObject:la];
            la.text=self.tipArray[i];
            
            
            
        }
        
       // self.backgroundColor=[UIColor lightGrayColor];
        
        
    }
    
    return self;
    
}

- (UIButton *) buttonWithNormImageName:(NSString *)normImageName selImageName:(NSString *)selImageName disableImageName:(NSString *)disableImageName
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"" forState:UIControlStateNormal];
    
   // button setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    
    [button setImage:[UIImage imageNamed:normImageName] forState:UIControlStateNormal];
    
//    [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
//    
//    [button setImage:[UIImage imageNamed:disableImageName] forState:UIControlStateDisabled];

    
    [self addSubview:button];
    
    return button;
    
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label=[[UILabel alloc] init];
    
    label.text=title;
    
    label.font=[UIFont systemFontOfSize:KScreenScaleValue(14)];
    
    [self addSubview:label];
    
    
    return label;
}

- (UIView *)viewWithbackgroundColor:(UIColor *)color
{
    UIView *view=[[UIView alloc] init];
    
    view.backgroundColor=color;
    
    [self addSubview:view];
    
    return view;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float marginLeft=KScreenScaleValue(50);
    
    float buttonWidth=KScreenScaleValue(23);
    
    float viewMargin=((self.width-2*marginLeft)-(self.count*buttonWidth))/(self.count-1);
    
    float buttton_y=self.height/2-buttonWidth;
    
    for (int i=0; i<self.buttonList.count; i++) {
        
        float button_x=marginLeft+(viewMargin*i)+(buttonWidth*i);
        
        UIButton *bt=self.buttonList[i];
        bt.frame=CGRectMake(button_x, buttton_y, buttonWidth, buttonWidth);
        
        UILabel *la=self.tipLabelList[i];
        CGSize size = CGSizeMake(320,2000);
        CGSize labelsize = [la.text sizeWithFont:la.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        la.frame=CGRectMake(button_x+(buttonWidth/2)-(labelsize.width/2), self.height/2+5, labelsize.width, labelsize.height);
        
        
        if (i+1<self.count) {
            
            UIView *view=self.lineViewList[i];
            view.frame=CGRectMake(button_x+(buttonWidth/2), buttton_y+buttonWidth/2-1, viewMargin+buttonWidth, 2);
            
//            if (i+1==2) {
//                
//                view.backgroundColor=[UIColor clearColor];
//            }
            
            
        }

        
    }
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.progress-=1;
}





























@end

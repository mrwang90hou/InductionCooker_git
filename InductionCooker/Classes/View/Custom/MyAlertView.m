//
//  MyAlertView.m
//  AlertViewDemo
//
//  Created by csl on 2017/12/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "MyAlertView.h"
#import "Masonry.h"
#import "AppDelegate.h"

#define KScreenWidthScaleValue(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)


@interface MyAlertView()

@property (nonatomic,weak) IBOutlet UIView  *bgView;

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;

@property (nonatomic,weak) IBOutlet UILabel *contenLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,strong) NSArray *btnTitles;

@property (nonatomic,strong) AlterViewClickedButtonAtIndex listener;

@property (nonatomic,strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic,assign) int cancelButtonIndex;

@end

@implementation MyAlertView

static UIColor *CancelButtonColor;
static UIColor *ActionButtonColor;

- (NSMutableArray<UIButton *> *)buttons
{
    if(_buttons==nil)
    {
        _buttons=[NSMutableArray array];
    }
    
    return  _buttons;
}

+(void)initialize
{
    CancelButtonColor=[UIColor blueColor];
    ActionButtonColor=[UIColor blackColor];
}

+ (void)appearanceWithCancelColor:(UIColor *)cancelColor actionColor:(UIColor *)actionColor
{
    CancelButtonColor=cancelColor;
    ActionButtonColor=actionColor;
}

- (NSArray *)btnTitles
{
    if(_btnTitles==nil)
    {
        _btnTitles=[NSArray array];
    }
    return _btnTitles;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)msg otherButtonTitles:(NSArray *)titles listener:(AlterViewClickedButtonAtIndex)listener
{
    if (self=[super init]) {
        
        self=[[[NSBundle mainBundle] loadNibNamed:@"MyAlertView" owner:self options:nil] lastObject];
        
        self.title=title;
        self.msg=msg;
        self.btnTitles=titles;
        self.listener = listener;
        self.cancelButtonIndex=-1;
        
        [self setupViewWithCancleIndex:-1];
        
    }
    
    return self;
}


- (instancetype) initWithTitle:(NSString *)title message:(NSString *)msg otherButtonTitles:(NSArray *) titles cancelIndex:(int) cancelIndex listener:(AlterViewClickedButtonAtIndex)listener
{
    if (self=[super init]) {
        
        self=[[[NSBundle mainBundle] loadNibNamed:@"MyAlertView" owner:self options:nil] lastObject];
        
        self.title=title;
        self.msg=msg;
        self.btnTitles=titles;
        self.listener = listener;
        
    
        if (cancelIndex<0||cancelIndex>=titles.count) {
            self.msg=@"取消按钮索引越界";
            cancelIndex=-1;
        }
        
        self.cancelButtonIndex=cancelIndex;
        
        [self setupViewWithCancleIndex:cancelIndex];
        
    }
    
    return self;
}

- (void) setupViewWithCancleIndex:(int) cancelIndex
{
    self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.3];
    
    self.bgView.layer.cornerRadius = KScreenWidthScaleValue(12);
    
    self.bgView.clipsToBounds=YES;
    
    self.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    
    self.contenLabel.font=[UIFont systemFontOfSize:16];
    
    self.titleLabel.text=self.title;
    
    self.contenLabel.text=self.msg;
    
    for (int i=0;i<self.btnTitles.count;i++) {

        UIColor *btnTitleColor=self.cancelButtonIndex==i?CancelButtonColor:ActionButtonColor;
        btnTitleColor=self.cancelButtonIndex==-1&&i==0&&self.btnTitles.count>1?CancelButtonColor:btnTitleColor;
        UIButton *btn=[self createButtonWithTitle:self.btnTitles[i] font:[UIFont systemFontOfSize:KScreenWidthScaleValue(15)] titleColor:btnTitleColor tag:i ];
        
        [self.buttons addObject:btn];
        
        [self.bottomView addSubview:btn];
        
    }
    
   
    
}

- (UIView *)createLineViewWithBackgroundColor:(UIColor *)backgroundColor
{
    UIView *view=[[UIView alloc] init];
    
    view.backgroundColor=backgroundColor;
    
    return view;
    
}

- (UIButton *) createButtonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *) titleColor tag:(int) tag
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font=font;
    
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    btn.backgroundColor=[UIColor whiteColor];
    
    btn.tag=tag;
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    return btn;
}


- (void) show
{
    if ([AppDelegate sharedAppDelegate].hadShowAlert) {
        return;
    }
    
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    self.frame=[UIScreen mainScreen].bounds;
    
    [window addSubview:self];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.title&&(self.msg==nil||self.msg.length==0)) {
        
        [self.contenLabel removeFromSuperview];
        
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.bottom.equalTo(self.lineView.mas_top).offset(-20);
            
        }];
    
        
    }
    
    if(self.msg&&(self.title==nil||self.title.length==0))
    {
        [self.titleLabel removeFromSuperview];
        
        [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.bgView.mas_top).offset(20);
            
        }];
    }
    
    if (self.buttons.count>=2) {
        
        // 实现masonry水平固定间隔方法
        [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
        // 设置array的垂直方向的约束
        [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.bottomView.mas_top);
            make.bottom.equalTo(self.bottomView.mas_bottom);
        }];
        
    }else if(self.buttons.count==1)
    {
        [self.buttons[0] mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.bottomView.mas_left);
            make.right.equalTo(self.bottomView.mas_right);
            make.top.equalTo(self.bottomView.mas_top);
            make.bottom.equalTo(self.bottomView.mas_bottom);
            
        }];
    }
 
    
}

#pragma mark -用户交互方法
- (void) buttonClick:(UIButton *)button
{
    
    
    
    if (self.listener) {
        
        self.listener(self,button.tag);
        
    }
    
    if (self.cancelButtonIndex==-1&&button.tag==0) {
        [self removeFromSuperview];
    }
    
    if (button.tag==self.cancelButtonIndex) {
        
        [self removeFromSuperview];
    }
    
}

- (void)hide
{
    [AppDelegate sharedAppDelegate].hadShowAlert = YES;
    [self removeFromSuperview];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self removeFromSuperview];
//}













@end

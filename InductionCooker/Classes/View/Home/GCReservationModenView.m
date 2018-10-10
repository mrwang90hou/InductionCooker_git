//
//  GCReservationModenView.m
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationModenView.h"

#import "GCReservationProgressView.h"
#import "Masonry.h"
#import "GCModenButton.h"
#import "UIView+NTES.h"


#define  KNormImageNameKey  @"KNormImageNameKey"

#define  KSelImageNameKey   @"KSelImageNameKey"

#define  KDisImageNameKey   @"KDisImageNameKey"

static NSInteger status;

@interface GCReservationModenView ()


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,weak) GCReservationProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong)  NSMutableArray *modenArr;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, weak) GCModenButton  *selButton;

@property (nonatomic,strong) NSArray *norImageNames;


@property (nonatomic,strong) NSArray *selImageNames;

@end

@implementation GCReservationModenView

- (GCModen *)selModen
{
    _selModen= self.selButton.moden;
    return _selModen;
}


- (NSMutableArray *)buttons
{
    if (_buttons==nil) {
        _buttons=[NSMutableArray array];
    }
    
    return _buttons;
}

+ (instancetype)loadViewFromXibWithiType:(NSInteger)type
{
    status=type;
    
    GCReservationModenView *view=[[[NSBundle mainBundle] loadNibNamed:@"GCReservationModenView" owner:self options:nil]lastObject];
    
   
    
    return view;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
       
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self getData];
    
    [self createUI];
    
}

- (void) getData
{
    
    int count=status==0?8:6;
    
    NSMutableArray *nArr=[NSMutableArray array];
    
    NSMutableArray *sArr=[NSMutableArray array];

    for (int i=0; i<count; i++) {
        
        NSString *norImageName=status==0?[NSString stringWithFormat:@"btn_moden_left_%d_normal",i+1]:[NSString stringWithFormat:@"btn_moden_right_%d_normal",i+1];
        
        NSString *selImageName=status==0?[NSString stringWithFormat:@"btn_moden_left_%d_selected",i+1]:[NSString stringWithFormat:@"btn_moden_right_%d_selected",i+1];
        
        [nArr addObject:norImageName];
        
        [sArr addObject:selImageName];
        
    }
    self.norImageNames=nArr;
    
    self.selImageNames=sArr;
    
}


- (void) getData2
{
    
    int count=status==0?5:3;
    
    NSMutableArray *nArr=[NSMutableArray array];
    
    NSMutableArray *sArr=[NSMutableArray array];
    
    for (int i=0; i<count; i++) {
        
        NSString *norImageName=status==0?[NSString stringWithFormat:@"btn_moden_left_%d_normal",i+1]:[NSString stringWithFormat:@"btn_moden_right_%d_normal",i+1];
        NSString *selImageName=status==0?[NSString stringWithFormat:@"btn_moden_left_%d_selected",i+1]:[NSString stringWithFormat:@"btn_moden_right_%d_selected",i+1];
        
        [nArr addObject:norImageName];
        
        [sArr addObject:selImageName];
        
    }
    if (status==0) {
        [nArr removeLastObject];
        [sArr removeLastObject];
        NSString *norImageName = [NSString stringWithFormat:@"btn_moden_left_%d_normal",8];
        NSString *selImageName = [NSString stringWithFormat:@"btn_moden_left_%d_selected",8];
        [nArr addObject:norImageName];
        [sArr addObject:selImageName];
    }
    
    
    self.norImageNames=nArr;
    
    self.selImageNames=sArr;
    
    
    
    
}


- (void) createUI{
    
    GCReservationProgressView *progressView=[[GCReservationProgressView alloc] initWithCount:2 tips:@[@"1.选择模式",@"2.预约开机时间"]];
    
    [self.topView addSubview:progressView];
    self.progressView=progressView;
    
    self.progressView.progress=1;
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.topView.mas_left).offset(0);
        make.right.mas_equalTo(self.topView.mas_right).offset(0);
        make.top.mas_equalTo(self.topView.mas_top);
        make.bottom.mas_equalTo(self.topView.mas_bottom);
        
    }];

    
    NSMutableArray *modenArr=[NSMutableArray array];
    
    NSArray *modens=[NSArray array];
    
    
    
    if (status==0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"leftdevice" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        modens=dic[@"value"];
        
    }else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"rightdevice" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
       modens=dic[@"value"];
    }
    
    
    
    
    int i=0;
    
    for (NSDictionary *dict in modens) {
        
        GCModen *moden=[GCModen createModelWithDict:dict];
        
        
            [modenArr addObject:moden];
            
            //NSDictionary *dictionary=[self imageNameFromModenType:moden];
            NSLog(@"moden.type = %@",moden.type);
            GCModenButton *modenButton=[self buttomWithModen:moden norImageName:self.norImageNames[i] selImageName:self.selImageNames[i] disabelImageName:nil];
            
            [self.buttons addObject:modenButton];
            
            if (i==0) {
                self.selButton=modenButton;
                self.selButton.selected=YES;
            }
            i++;
        
    }
    
    
    self.modenArr=modenArr;
    
    
    
}


- (GCModenButton *)buttomWithModen:(GCModen *)moden norImageName:(NSString *)nImageName selImageName:(NSString *)sImageName disabelImageName:(NSString *)disIamgeName
{
    GCModenButton *button=[GCModenButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:moden.type forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:nImageName] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:sImageName] forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:disIamgeName] forState:UIControlStateDisabled];
    
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    
   // button.titleLabel.textColor=[UIColor blackColor];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   // button.backgroundColor=[UIColor lightGrayColor];
    
    [self.contentView addSubview:button];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.moden=moden;
    
    return button;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
   // self.progressView.progress+=1;
}


- (void)layoutSubviews0
{
    [super layoutSubviews];
//    [SVProgressHUD showSuccessWithStatus:@"layoutSubviews"];
//    float buttonWidth= 71;
//
//    float buttonHeight=94;
//
//    float buttonWidth= KScreenScaleValue(71);
//
//    float buttonHeight=KScreenScaleValue(94);
    
    float buttonWidth= KScreenScaleValue(71);
    
    float buttonHeight=KScreenScaleValue(94);
    
    float buttonMarginTop=KScreenScaleValue(10);
    
    float buttonMarginBottom=KScreenScaleValue(100);
    
   // float a=self.contentView.height;
    
    float buttonMargin=(self.contentView.height-buttonMarginTop-buttonMarginBottom-(self.buttons.count/2*buttonHeight))/((self.buttons.count/2)-1);

    int column=2;
    
    float buttonHMargin=(self.contentView.width-column*buttonWidth)/(column*2);


//    int i=0;
//    for (GCModenButton *button in self.buttons) {
//
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin+(i%2*(buttonHMargin+buttonWidth)));
//
//            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i%2*(buttonHeight+buttonMargin));
//
//            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(buttonHeight);
//
//        }];
//        i++;
//    }

    
    NSUInteger count=self.buttons.count/2;
    
    for (int i=0; i<count; i++) {
        
        GCModenButton *button_1=self.buttons[i];
        
        GCModenButton *button_2=self.buttons[i+count];
        
        
        [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin);
            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
            
        }];
        
        [button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.contentView.mas_left).offset(3*buttonHMargin+buttonWidth);
            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
    
    
    // 执行九宫格布局
//    [self.contentView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:10 fixedInteritemSpacing:20 warpCount:3 topSpacing:10 bottomSpacing:10 leadSpacing:10 tailSpacing:10];

    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
//    [SVProgressHUD showSuccessWithStatus:@"layoutSubviews"];
    //    float buttonWidth= 71;
    //
    //    float buttonHeight=94;
    //
    //    float buttonWidth= KScreenScaleValue(71);
    //
    //    float buttonHeight=KScreenScaleValue(94);
    
    float buttonWidth= KScreenScaleValue(71);
    
    float buttonHeight=KScreenScaleValue(94);
    
    float buttonMarginTop=KScreenScaleValue(10);
    
    float buttonMarginBottom=KScreenScaleValue(100);
    
    // float a=self.contentView.height;
    
    float buttonMargin=(self.contentView.height-buttonMarginTop-buttonMarginBottom-(self.buttons.count/2*buttonHeight))/((self.buttons.count/2)-1);
    
    int column=2;
    
    float buttonHMargin=(self.contentView.width-column*buttonWidth)/(column*2);
    
    
    //    int i=0;
    //    for (GCModenButton *button in self.buttons) {
    //
    //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin+(i%2*(buttonHMargin+buttonWidth)));
    //
    //            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i%2*(buttonHeight+buttonMargin));
    //
    //            make.width.mas_equalTo(buttonWidth);
    //            make.height.mas_equalTo(buttonHeight);
    //
    //        }];
    //        i++;
    //    }
    
    if (status == 0) {
        //左炉布局
        NSMutableArray *newButtonArray = [NSMutableArray new];
        for (int i=0; i<4; i++) {
            [newButtonArray addObject:self.buttons[i]];
        }
        NSUInteger count=newButtonArray.count/2;
//        int j = 0;
        for (int i=0; i<count; i++) {
            
            GCModenButton *button_1=newButtonArray[i];
            
            GCModenButton *button_2=newButtonArray[i+count];
            
            [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin);
                make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(buttonHeight);
                
            }];
            
            [button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.contentView.mas_left).offset(3*buttonHMargin+buttonWidth);
                make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(buttonHeight);
            }];
            
            if (i == 1) {
                GCModenButton *button_7=self.buttons[7];
                [button_7 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin);
                    make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin)*2);
                    make.width.mas_equalTo(buttonWidth);
                    make.height.mas_equalTo(buttonHeight);
                }];
            }
        }
        
        for (int i = 4; i<7; i++) {
            GCModenButton *button = self.buttons[i];
            [button setHidden:true];
        }
        
    }else{
        //右炉布局
        NSMutableArray *newButtonArray = [NSMutableArray new];
        for (int i=0; i<3; i++) {
            [newButtonArray addObject:self.buttons[i]];
        }
        [newButtonArray addObject:[self.buttons lastObject]];
        NSUInteger count=newButtonArray.count/2;
        for (int i=0; i<count; i++) {
            
            GCModenButton *button_1=newButtonArray[i];
            
            GCModenButton *button_2=newButtonArray[i+count];
            
            [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin);
                make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(buttonHeight);
                
            }];
            
            [button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(self.contentView.mas_left).offset(3*buttonHMargin+buttonWidth);
                make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
                make.width.mas_equalTo(buttonWidth);
                make.height.mas_equalTo(buttonHeight);
            }];
            if (i == 1) {
                [button_2 setHidden:true];
            }
        }
        
        for (int i = 3; i<5; i++) {
            GCModenButton *button = self.buttons[i];
            [button setHidden:true];
        }
        
        
    }
    
    
    
    
    
    
    
    
    
//
//
//    NSUInteger count=self.buttons.count/2;
//    for (int i=0; i<count; i++) {
//
//        GCModenButton *button_1=self.buttons[i];
//
//        GCModenButton *button_2=self.buttons[i+count];
//
//
//        [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(self.contentView.mas_left).offset(buttonHMargin);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
//            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(buttonHeight);
//
//        }];
//
//        [button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.mas_equalTo(self.contentView.mas_left).offset(3*buttonHMargin+buttonWidth);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
//            make.width.mas_equalTo(buttonWidth);
//            make.height.mas_equalTo(buttonHeight);
//        }];
//    }
//
    
    // 执行九宫格布局
    //    [self.contentView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:10 fixedInteritemSpacing:20 warpCount:3 topSpacing:10 bottomSpacing:10 leadSpacing:10 tailSpacing:10];
    
    
    
}



#pragma mark -用户交互方法
- (void) buttonClick:(GCModenButton *)button
{
    
    self.selButton.selected=!self.selButton.selected;
    
    button.selected=!button.selected;
    
    self.selButton=button;
}


































@end

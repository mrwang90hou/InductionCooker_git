//
//  GCLeftDeivceView.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCLeftDeivceView.h"

#import "UIView+NTES.h"
#import "GCModenButton.h"
#import "GCModen.h"
#import "RHSocketConnection.h"
#import "GCAgreementHelper.h"
#import "GCUser.h"
#import "GCDiscoverView.h"
#import "GCSokectDataDeal.h"
#import "GCAdjustViewController.h"
#import "CATransitionHelper.h"
#import "Masonry.h"
#import "GCImageTopButton.h"


@interface GCLeftDeivceView ()<GCAdjustViewControllerDelegate>





@property (weak, nonatomic) IBOutlet GCModenButton *button_0;

@property (weak, nonatomic) IBOutlet GCModenButton *button_1;

@property (weak, nonatomic) IBOutlet GCModenButton *button_2;

@property (weak, nonatomic) IBOutlet GCModenButton *button_3;

@property (weak, nonatomic) IBOutlet GCModenButton *button_4;

@property (weak, nonatomic) IBOutlet GCModenButton *button_5;

@property (weak, nonatomic) IBOutlet GCModenButton *button_6;

@property (weak, nonatomic) IBOutlet GCModenButton *button_7;


@property (nonatomic,strong) GCModenButton *selectButton;


@property (weak, nonatomic) IBOutlet GCImageTopButton *poweBt;

@property (weak, nonatomic) IBOutlet GCImageTopButton *reservationBt;

@property (weak, nonatomic) IBOutlet GCImageTopButton *disReservatonBt;


@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,strong) GCAdjustViewController *subVc;

@property (weak, nonatomic) IBOutlet UIView *modenView;


@property (nonatomic,strong) NSMutableArray<GCModenButton *> *buttons;

@property (nonatomic,strong) NSArray *normImageList;

@property (nonatomic,strong) NSArray *disEnableImageList;

@property (nonatomic,strong) NSArray *selectedImageList;

@property (nonatomic,assign) BOOL powerState;






@end

@implementation GCLeftDeivceView

#pragma mark -懒加载
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        
        _buttons=[NSMutableArray array];
        
    }
    
    return _buttons;
}

-(void)setIsConection:(BOOL)isConection
{
    _isConection = isConection;
    if (_isConection) {
        [self.poweBt setImage:[UIImage imageNamed:@"btn_openkey_normal"] forState:UIControlStateNormal];
        [self.reservationBt setImage:[UIImage imageNamed:@"btn_reservation_normal"] forState:UIControlStateNormal];
        [self.disReservatonBt setImage:[UIImage imageNamed:@"btn_cancel_normal"] forState:UIControlStateNormal];
        
        self.poweBt.userInteractionEnabled = YES;
        self.reservationBt.userInteractionEnabled = YES;
        self.disReservatonBt.userInteractionEnabled = YES;
    }else
    {
        [self.poweBt setImage:[UIImage imageNamed:@"btn_openkey_disabled"] forState:UIControlStateNormal];
        [self.reservationBt setImage:[UIImage imageNamed:@"btn_reservation_disabled"] forState:UIControlStateNormal];
        [self.disReservatonBt setImage:[UIImage imageNamed:@"btn_cancel_disabled"] forState:UIControlStateNormal];
        
        self.poweBt.userInteractionEnabled = NO;
        self.reservationBt.userInteractionEnabled = NO;
        self.disReservatonBt.userInteractionEnabled = NO;
    }
}

#pragma mark -view
+ (instancetype)loadViewFromXib
{
    GCLeftDeivceView *view=[[[NSBundle mainBundle] loadNibNamed:@"GCLeftDeivceView" owner:self options:nil]lastObject];
    
    return view;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.normImageList=@[@"btn_soup_normal",@"btn_porridge_normal",@"btn_rice_normal",@"btn_water_normal",
                             @"brn_hotpot_normal",@"btn_fried_normal",@"btn_baked_fried_normal",@"btn_r_temperature_normal"];
        self.disEnableImageList=@[@"btn_soup_disabled",@"btn_porridge_disabled",@"btn_rice_disabled",@"btn_water_disabled",
                                  @"brn_hotpot_disabled",@"btn_fiy_disabled",@"btn_baked_fried_disabled",
                                  @"btn_r_temperature_disabled"];
        self.selectedImageList=@[@"btn_soup_selected",@"btn_porridge_selected",@"btn_rice_selected",@"btn_water_selected",
                                  @"brn_hotpot_selected",@"btn_fried__selected",@"btn_baked_fried_selected",
                                  @"btn_r_temperature_selected"];
        
    }
    
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {

        NSMutableArray *nArr=[NSMutableArray array];
        
        NSMutableArray *dArr=[NSMutableArray array];
        
        
        for(int i=0;i<8;i++)
        {
            NSString *norImageName=[NSString stringWithFormat:@"btn_moden_left_%d_normal",i+1];//btn_moden_left_4_disabled
            
            NSString *disImageName=[NSString stringWithFormat:@"btn_moden_left_%d_disabled",i+1];
            
            [nArr addObject:norImageName];
            
            [dArr addObject:disImageName];
        }
        
        self.normImageList=nArr;
        self.disEnableImageList=dArr;
    }
    
    return self;
}

- (IBAction)action01:(GCModenButton *)sender {
    //button0的bug解决方案！
    NSLog(@"煲粥");
    NSData *data=[GCSokectDataDeal getDataWithModen:4 device:0];
    [[RHSocketConnection getInstance] writeData: data timeout:-1 tag:-1];

//    [[RHSocketConnection getInstance] writeData:data timeout:-1 tag:-1 ReceiveBlock:^(NSData *data, long tag) {
//        [sender setImage:[UIImage imageNamed:@"btn_moden_left_1_selected"] forState:UIControlStateNormal];
//    }];

//    [sender setImage:[UIImage imageNamed:@"btn_moden_left_1_selected"] forState:UIControlStateNormal];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSArray *arr=@[_button_0,_button_1,_button_2,_button_3,_button_4,_button_5,_button_6,_button_7];
    
    [self.buttons addObjectsFromArray:arr];
    
    int i=0;
    for (GCModenButton *bt in self.buttons) {
//        NSLog(@"bt = %@",bt.titleLabel.text);
//        NSLog(@"bt.moden.modenId = %d",bt.moden.modenId);
        
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bt setImage:[UIImage imageNamed:self.disEnableImageList[i++]] forState:UIControlStateNormal];
    }
    [self getData];
    
    [self addStallView];
    
    self.backgroundColor=[UIColor clearColor];
    
    
    
}


- (void)addStallView
{
    
    self.subVc = [[GCAdjustViewController alloc] initWithNibName:@"GCAdjustViewController" bundle:nil];
    
    self.subVc.delegate=self;
    
    self.subVc.view.hidden=YES;
    
    self.subVc.deviceId=0;
    
    [self.modenView addSubview:self.subVc.view];
    
}


- (void) stallViewShow:(BOOL)isShow moden:(GCModen *)model{


    if (isShow) {
        
        if (self.subVc.view.hidden) {
           
            [self.subVc updateViewWithModen:model];
            [self.subVc showAdjustView:YES];
            
            [CATransitionHelper addTransitionWithLayer:self.subVc.view.layer animationType:kCATransitionPush subtype:kCATransitionFromTop duration:0.4];
            
        }

        
    }else{
        
        if (!self.subVc.view.hidden) {
            [self.subVc showAdjustView:NO];
            [CATransitionHelper addTransitionWithLayer:self.subVc.view.layer animationType:kCATransitionPush subtype:kCATransitionFromBottom duration:0.4];
        }
      
        
        
    }

    
    if (self.powerState) {
        self.bottomView.hidden=!self.subVc.view.hidden;
    }else{
        self.bottomView.hidden=YES;
    }
    
    

}


#pragma mark -用户交互方法
- (IBAction)powerButtonClick:(id)sender {
    
    
    GCImageTopButton *bt=sender;
    
    
    if (bt.selected) {
        //0   1 表示关机
        //0   0 表示开机
//        NSLog(@"bt.selected is true ! = %@",[GCSokectDataDeal getRootBytesWithDeviceId:0 status:0]);
//        [SVProgressHUD showWithStatus:@"bt.selected is true ! "];
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:0 status:1] timeout:-1 tag:KTagPowerOff ReceiveBlock:^(NSData *data, long tag) {

        }];
    }else{
//        NSLog(@"bt.selected is false ! = %@",[GCSokectDataDeal getRootBytesWithDeviceId:0 status:0]);
//        [SVProgressHUD showWithStatus:@"bt.selected is false ! "];
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:0 status:0] timeout:-1 tag:KTagPowerOn ReceiveBlock:^(NSData *data, long tag) {

        }];
        
        
    }

    
}

- (IBAction)reservationButtonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(leftReservationButtonClick)]) {
        
        [_delegate leftReservationButtonClick];
    }
    
}

- (IBAction)unReservationButtonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(leftUnreservationButtonClick)]) {
        
        [_delegate leftUnreservationButtonClick];
    }
    
}

- (IBAction)showStallViewButtonClick:(id)sender {
    
    [self stallViewShow:YES moden:[GCUser getInstance].device.leftDevice.selModen];
    
}


- (void) buttonClick:(GCModenButton *)button
{
    
    if ([GCUser getInstance].device.leftDevice.powerState==0) {
        
        [GCDiscoverView showWithTip:@"请先开机,再进行操作!"];
        return;
    }
    if(button.moden.modenId==[GCUser getInstance].device.leftDevice.selModen.modenId) {
        NSLog(@"_delegate!_delegate!_delegate!_delegate!_delegate!_delegate!_delegate!_delegate!");
        if ([_delegate respondsToSelector:@selector(leftModenButtonClick:)]) {
            [_delegate leftModenButtonClick:button];
        }
        return;
    }
//    for (UIButton *btn in self.buttons) {
//        NSLog(@"self.buttons = %@",btn.titleLabel.text);
//        if ([btn.titleLabel.text isEqualToString:@"煲粥"]) {
////            modelId = 0;
//        }
//    }
    
    
    NSLog(@"button.moden = %@",button.moden);
    NSLog(@"button.moden.modenId = %d",button.moden.modenId);
    //改变了 button 的序列位置
    int modelId = 0 ;
    switch (button.moden.modenId) {
        case 0:
            modelId = 4;
            break;
        case 1:
            modelId = 5;
            break;
        case 2:
            modelId = 6;
            break;
        case 3:
            modelId = 7;
            break;
        case 4:
            modelId = 0;
            break;
        case 5:
            modelId = 1;
            break;
        case 6:
            modelId = 2;
            break;
        case 7:
            modelId = 3;
            break;
    }
    
    NSLog(@"modelId = %d",modelId);
//    NSData *data=[GCSokectDataDeal getDataWithModen:button.moden.modenId device:0];
    
    NSData *data=[GCSokectDataDeal getDataWithModen:modelId device:0];
    
    [[RHSocketConnection getInstance] writeData: data timeout:-1 tag:-1];

    
}


- (IBAction)changDeviceClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(changeDeivceButtonClick)]) {
        
        [_delegate changeDeivceButtonClick];
        
    }
    
}



- (void) getData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"leftdevice" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    for (int i=0;i<[dic[@"value"] count];i++) {
        
        NSDictionary *dict = dic[@"value"][i];
        
        GCModen *model=[GCModen createModelWithDict:dict];
        
        self.buttons[i].moden=model;
//        NSLog(@"self.buttons[i].moden.modenId = %d",model.modenId);
//        [self.buttons[0] addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(GCModen *)updateModen:(int)moden
{
    
    if (moden<self.buttons.count) {
        
        GCModenButton *button=self.buttons[moden];
        
        if (self.selectButton&&self.selectButton!=button) {
            self.selectButton.selected=NO;
            self.selectButton.moden.currentStall=-1;
        }
        
        button.selected=YES;
        
        self.selectButton=button;
        
        if ([_delegate respondsToSelector:@selector(leftModenButtonClick:)]) {
            
           
            [_delegate leftModenButtonClick:button];
            
        }

        
        return button.moden;
    }
    
    return nil;
    
}


- (void) powerState:(BOOL)state hasReservation:(BOOL)has monden:(int) moden
{

//    int selModen=self.selectButton.moden?self.selectButton.moden.modenId:-1;
//    if (self.powerState==state&&selModen==moden) {
//        return;
//    }
    
    if (!state) {
        
        if (self.selectButton) {
            self.selectButton.selected=NO;
            self.selectButton.moden.currentStall=-1;
        }
    }
    
    
    if (state!=self.powerState) {
        
        NSArray *arr=state?self.normImageList:self.disEnableImageList;
        
        for (int i=0;i<arr.count;i++) {
            
            //NSString *str=arr[i];
            
            [self.buttons[i] setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            
        }
    }
   
    self.powerState=state;
    
    self.poweBt.selected=state;
  
    
    if (!state)
    {
        [self stallViewShow:state moden:[GCUser getInstance].device.leftDevice.selModen];
    }else{
        
        self.bottomView.hidden=!self.subVc.view.hidden;
    }
    
    self.reservationBt.tipImageView.hidden=!has;
   
}

- (void)reservationStateChange:(int)state
{
    self.reservationBt.tipImageView.hidden=!state;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.subVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.modenView.mas_left).offset(0);
        make.right.mas_equalTo(self.modenView.mas_right).offset(0);
        make.top.mas_equalTo(self.modenView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.modenView.mas_bottom).offset(0);
        
    }];

    [self layoutButtons];
    
    
}

- (void) layoutButtons
{
    float buttonWidth= KScreenScaleValue(71);
    
    float buttonHeight=KScreenScaleValue(94);
    
    float buttonMarginTop=KScreenScaleValue(10);
    
    float buttonMarginBottom=KScreenScaleValue(40);
    

    
    float buttonMargin=(self.modenView.height-buttonMarginTop-buttonMarginBottom-(self.buttons.count/2*buttonHeight))/((self.buttons.count/2)-1);
    
    int column=2;
    
    float buttonHMargin=(self.modenView.width-column*buttonWidth)/(column*2);

    NSUInteger count=self.buttons.count/2;
    
    for (int i=0; i<count; i++) {
        
        GCModenButton *button_1=self.buttons[i];
        
        GCModenButton *button_2=self.buttons[i+count];
        
        
        [button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.modenView.mas_left).offset(buttonHMargin);
            make.top.mas_equalTo(self.modenView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
            
        }];
        
        [button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.modenView.mas_left).offset(3*buttonHMargin+buttonWidth);
            make.top.mas_equalTo(self.modenView.mas_top).offset(buttonMarginTop+i*(buttonHeight+buttonMargin));
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
            
            
        }];
        
        
    }
    
    
//    [self.buttons[0] mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//
//
//    }];
    
}


#pragma mark -GCAdjustViewControllerDelegate
- (void) removeButtonClickWithDeivceId:(int)deviceId
{

    [self stallViewShow:NO moden:nil];

    
}































@end

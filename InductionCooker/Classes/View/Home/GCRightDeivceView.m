//
//  GCRightDeivceView.m
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCRightDeivceView.h"

#import "GCModenButton.h"

#import "GCUser.h"
#import "GCDiscoverView.h"
#import "GCSokectDataDeal.h"
#import "GCImageTopButton.h"
#import "GCAdjustViewController.h"
#import "CATransitionHelper.h"
#import "Masonry.h"
#import "UIView+NTES.h"

@interface GCRightDeivceView ()<GCAdjustViewControllerDelegate>


@property (weak, nonatomic) IBOutlet GCModenButton *button_0;

@property (weak, nonatomic) IBOutlet GCModenButton *button_1;

@property (weak, nonatomic) IBOutlet GCModenButton *button_2;

@property (weak, nonatomic) IBOutlet GCModenButton *button_3;

@property (weak, nonatomic) IBOutlet GCModenButton *button_4;

@property (weak, nonatomic) IBOutlet GCModenButton *button_5;


@property (nonatomic,strong) NSMutableArray<GCModenButton *> *buttons;

@property (nonatomic,strong) GCModenButton *selectButton;

@property (weak, nonatomic) IBOutlet GCImageTopButton *poweBt;

@property (weak, nonatomic) IBOutlet GCImageTopButton *reservationBt;

@property (weak, nonatomic) IBOutlet GCImageTopButton *disReservatonBt;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,strong) GCAdjustViewController *subVc;

@property (weak, nonatomic) IBOutlet UIView *modenView;

@property (nonatomic,strong) NSDictionary *modenButtonDict;

@property (nonatomic,strong) NSArray *normImageList;

@property (nonatomic,strong) NSArray *disEnableImageList;

@property (nonatomic,assign) BOOL powerState;



@end

@implementation GCRightDeivceView

- (NSMutableArray *)buttons
{
    if (_buttons==nil) {
        _buttons=[NSMutableArray array];
    }
    return _buttons;
}

+ (instancetype)loadViewFromXib
{
    GCRightDeivceView *view=[[[NSBundle mainBundle] loadNibNamed:@"GCRightDeivceView" owner:self options:nil]lastObject];
    
    return view;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.normImageList=@[@"btn_baked_normal",@"btn_stew_normal",@"btn_r_temperature_normal",
                             @"btn_quicyfry_normal",@"btn_fried_normal",@"btn_slowfire_normal"];
        self.disEnableImageList=@[@"btn_baked_disabled",@"btn_stew_disabled",@"btn_r_temperature_disabled",
                                  @"btn_quicyfry_disabled",@"btn_fried__disabled",@"btn_slowfire_disabled",];
        
    }
    
    return  self;
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        NSMutableArray *nArr=[NSMutableArray array];
        NSMutableArray *dArr=[NSMutableArray array];
        for(int i=0;i<6;i++)
        {
            NSString *norImageName=[NSString stringWithFormat:@"btn_moden_right_%d_normal",i+1];
            
            NSString *disImageName=[NSString stringWithFormat:@"btn_moden_right_%d_disabled",i+1];
            
            [nArr addObject:norImageName];
            
            [dArr addObject:disImageName];
        }
        self.normImageList=nArr;
        self.disEnableImageList=dArr;
    }
    
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    NSArray *arr=@[_button_0,_button_1,_button_2,_button_3,_button_4,_button_5];
    
    [self.buttons addObjectsFromArray:arr];
    
    int i=0;
    for (GCModenButton *bt in self.buttons) {
        
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bt setImage:[UIImage imageNamed:self.disEnableImageList[i++]] forState:UIControlStateNormal];
    }


    [self getData];
    
    [self addStallView];
    
}

- (void)addStallView
{
    
    self.subVc = [[GCAdjustViewController alloc] initWithNibName:@"GCAdjustViewController" bundle:nil];
    self.subVc.delegate=self;
    self.subVc.view.hidden=YES;
    self.subVc.deviceId=1;
    [self.modenView addSubview:self.subVc.view];
    
}

- (void) stallViewShow:(BOOL)isShow moden:(GCModen *)model{
    
    
    
    if (isShow) {
        
        if (self.subVc.view.hidden) {
            
            [self.subVc showAdjustView:YES];
            [self.subVc updateViewWithModen:model];
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


- (void) getData{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rightdevice" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *mDict=[NSMutableDictionary dictionary];
    
    for (int i=0;i<[dic[@"value"] count];i++) {
        
        NSDictionary *dict = dic[@"value"][i];
        
        GCModen *model=[GCModen createModelWithDict:dict];
        
        self.buttons[i].moden=model;
        
        [mDict setObject:self.buttons[i] forKey:[NSString stringWithFormat:@"%d",model.modenId]];
    }
    
    self.modenButtonDict=mDict;
    
}


#pragma mark -用户交互方法

- (IBAction)powerButtonClick:(id)sender {
    
    GCImageTopButton *bt=sender;
    
    
    if (bt.selected) {
        
        //1   0 表示开机
        //1   1 表示关机
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:1 status:1] timeout:-1 tag:KTagPowerOff ReceiveBlock:^(NSData *data, long tag) {
        
            
        }];
        
        
    }else{
        
        
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:1 status:0] timeout:-1 tag:KTagPowerOn ReceiveBlock:^(NSData *data, long tag) {
            
            
        }];
        
        
    }

    
}

- (IBAction)reservationButtonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(rightReservationButtonClick)]) {
        
        [_delegate rightReservationButtonClick];
    }
    
}

- (IBAction)unReservationButtonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(rightUnreservationButtonClick)]) {
        
        [_delegate rightUnreservationButtonClick];
    }
    
}

- (IBAction)showStallViewButtonClick:(id)sender {
    
    [self stallViewShow:YES moden:[GCUser getInstance].device.rightDevice.selModen];
    
}


- (void) buttonClick:(GCModenButton *)button
{
    if ([GCUser getInstance].device.rightDevice.powerState==0) {
        
        [GCDiscoverView showWithTip:@"请先开机,再进行操作!"];
        return;
    }
    
    if(button.moden.modenId==[GCUser getInstance].device.rightDevice.selModen.modenId) {
        
        if ([_delegate respondsToSelector:@selector(rightModenButtonClick:)]) {
            [_delegate rightModenButtonClick:button];
        }
        return;
        
    }

    int moden=button.moden.modenId%100;
//    int moden=button.moden.modenId;
    
    
    //改变了 button 的序列位置
    int modelId = 0 ;
    switch (moden) {
        case 10:
            modelId = 0;
            break;
        case 11:
            modelId = 1;
            break;
        case 12:
            modelId = 2;
            break;
        case 8:
            modelId = 3;
            break;
        case 9:
            modelId = 4;
            break;
        case 7:
            modelId = 5;
            break;
    }
    NSLog(@"modelId = %d",modelId);
//    NSData *data=[GCSokectDataDeal getDataWithModen:moden device:1];
    NSData *data=[GCSokectDataDeal getDataWithModen:modelId device:1];
    
    [[RHSocketConnection getInstance] writeData: data timeout:-1 tag:-1];
    
}

- (IBAction)changeDeviceClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(changeDeivceButtonClick)]) {
        
        [_delegate changeDeivceButtonClick];
        
    }
    
}




-(GCModen *)updateModen:(int)moden
{

    GCModenButton *button=self.modenButtonDict[[NSString stringWithFormat:@"%d",moden+100]];
    
    
    if (button) {
        
        if (self.selectButton) {
            self.selectButton.selected=NO;
        }
        
        button.selected=YES;
        
        self.selectButton=button;
        
        if ([_delegate respondsToSelector:@selector(rightModenButtonClick:)]) {
            
             [_delegate rightModenButtonClick:button];
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
        [self stallViewShow:state moden:[GCUser getInstance].device.rightDevice.selModen];
    }else{
        
        self.bottomView.hidden=!self.subVc.view.hidden;
    }
    
    self.reservationBt.tipImageView.hidden=!has;
    
}

- (void) reservationStateChange:(int)state
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
    
    float buttonMarginBottom=KScreenScaleValue(70);
    
    
    
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
    
    
}


#pragma mark -GCAdjustViewControllerDelegate
- (void) removeButtonClickWithDeivceId:(int)deviceId
{
    
    [self stallViewShow:NO moden:nil];
    
    
}

































@end

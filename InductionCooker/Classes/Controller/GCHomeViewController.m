//
//  GCHomeViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCHomeViewController.h"

#import "Masonry.h"
#import "GCLeftDeivceView.h"
#import "GCSegmentedControl.h"
#import "GCRightDeivceView.h"
#import "GCAdjustViewController.h"
#import "CATransitionHelper.h"
#import "GCModenButton.h"
#import "GCReservationViewController.h"
#import "GCDiscoverView.h"
#import "RHSocketConnection.h"
#import "GCImageTopButton.h"
#import "GCAgreementHelper.h"
#import "GCLinkView.h"
#import "GCUser.h"
#import "GCReservationPreviewViewController.h"
#import "MQHudTool.h"
#import "GCDataBasicManager.h"
#import "GCSokectDataDeal.h"
#import "NSDictionary+Category.h"
#import "HexStringChange.h"
#import "WifiConnectView.h"
#import "GCDeviceListViewController.h"
#import "MyAlertView.h"

@interface GCHomeViewController ()<GCSegmentedControlDelegate,GCAdjustViewControllerDelegate,GCLeftDeivceViewDelegate,GCRightDeivceViewDelegate,GCDeviceListViewControllerDelegate>
{
    GCAdjustViewController* modenVc;
}

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *controllerView;

@property (nonatomic,weak) GCRightDeivceView *rightView;

@property (nonatomic,weak)  GCLeftDeivceView *leftView;

//@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, weak) GCSegmentedControl *segmentControl;

@property (nonatomic,weak) WifiConnectView *wifiConnectView;

@property (nonatomic,weak) UILabel *deviceNameLabel;

@property (nonatomic,strong) GCDeviceListViewController *deviceVc;

//@property (weak, nonatomic) IBOutlet GCImageTopButton *root_bt;

//@property (weak, nonatomic) IBOutlet GCImageTopButton *reservation_bt;

//@property (weak, nonatomic) IBOutlet GCImageTopButton *unreservation_bt;

@property (nonatomic,copy) NSString *leftDeviceLastData;

@property (nonatomic,copy) NSString *rightDeviceLastData;

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,copy) NSString *lastErrorId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewMarginTop;

@end

@implementation GCHomeViewController

- (GCDeviceListViewController *)deviceVc
{
    if (_deviceVc==nil) {
        _deviceVc=[[GCDeviceListViewController alloc] init];
        _deviceVc.delegate=self;
    }
    return _deviceVc;
}

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addObserver];
    
    [self getData];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
    [self.leftView reservationStateChange:[GCUser getInstance].device.leftDevice.hasReservation];
    
    [self.rightView reservationStateChange:[GCUser getInstance].device.rightDevice.hasReservation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -页面逻辑方法
- (void) addObserver
{
    //设备状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiDevoceStateChange object:nil];
    
    //电磁炉未连接服务器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotiDeivceDisconnect) name:KNotiDeviceDisconnectFormServe object:nil];
    
    //选中的设备切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDeiveChange) name:KNotiSelectDeviceChange object:nil];
    
    //连接sokect服务器状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSokectServeStateChange:) name:KNotiConnectSokectServeState object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conectionStatus) name:@"conectionStatus" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conectionStatus:) name:@"conectionStatus" object:nil];
}

- (void) getData{
    
    
}


- (void) createUI{
    
    GCSegmentedControl *segmentControl=[GCSegmentedControl loadViewFromXib];
    
    segmentControl.delegate=self;
    
    [self.topView addSubview:segmentControl];
    
    if (KIsiPhoneX) {
        self.topViewMarginTop.constant=40;
    }
    
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        make.top.mas_equalTo(self.topView.mas_top);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
        
    }];
    
    self.segmentControl=segmentControl;
    
    WifiConnectView *wifiConnectView=[[WifiConnectView alloc] init];
    
    [self.topView addSubview:wifiConnectView];
    
    

    [wifiConnectView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(segmentControl.mas_right).offset(5);
        make.centerY.mas_equalTo(segmentControl.mas_centerY);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(17);

    }];
    
//    int type = [GCUser getInstance].device.code == -1 ? 0 : 1;
    [wifiConnectView setWifiConnectLabelTitleWithIndex:0];
    
    self.wifiConnectView=wifiConnectView;
    
    UILabel *deviceNameLabel=[[UILabel alloc] init];
    
    [self.topView addSubview:deviceNameLabel];
    
    self.deviceNameLabel=deviceNameLabel;
    
    [deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(segmentControl.mas_bottom).offset(5);
        make.centerX.mas_equalTo(segmentControl.mas_centerX);
        
    }];
    self.deviceNameLabel.text=@"";
    self.deviceNameLabel.textColor=[UIColor blackColor];
    
   

    GCRightDeivceView *rightView=[GCRightDeivceView loadViewFromXib];
    
    [self.controllerView addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.controllerView.mas_left).offset(0);
        make.right.mas_equalTo(self.controllerView.mas_right).offset(0);
        make.top.mas_equalTo(self.controllerView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.controllerView.mas_bottom).offset(5);
        
    }];
    
    rightView.hidden=YES;
    rightView.delegate=self;
    
    self.rightView=rightView;
    
    
    GCLeftDeivceView *leftView=[GCLeftDeivceView loadViewFromXib];
    
    [self.controllerView addSubview:leftView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.controllerView.mas_left).offset(0);
        make.right.mas_equalTo(self.controllerView.mas_right).offset(0);
        make.top.mas_equalTo(self.controllerView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.controllerView.mas_bottom).offset(0);
        
    }];
    
    leftView.delegate=self;
    self.leftView=leftView;
    
    if ([GCUser getInstance].device.deviceId == nil) {
        self.wifiConnectView.hidden = YES;
        [self conectionStatus];
    }else
        self.wifiConnectView.hidden = NO;
    
}

-(void)conectionStatus
{
//    NSLog(@"conectionStatus!!!");
    int code = [GCUser getInstance].device.code;
    if ([GCUser getInstance].device.deviceId == nil) {
        self.wifiConnectView.hidden = YES;
        code = -1;
    }else
        self.wifiConnectView.hidden = NO;
    
    if (code == -1) {
        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:0];
        self.leftView.isConection = NO;
        self.rightView.isConection = NO;
    }else
    {
        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:1];
        self.leftView.isConection = YES;
        self.rightView.isConection = YES;
    }
    //监听连接状态，进行弹窗提示！
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiConnectViewHiddenChange:) name:UITextFieldTextDidChangeNotification object:self.wifiConnectView];
    
}

-(void)wifiConnectViewHiddenChange:(NSNotification *)noti{
    
    WifiConnectView *wifi = (WifiConnectView *)noti.object;
    if (wifi.hidden) {
        //        [self.hud addHudWithTitle:@"连接成功！" onWindow:myWindow];
        [SVProgressHUD showSuccessWithStatus:@"连接断开！"];
        [SVProgressHUD dismissWithDelay:1];
        //        [MBProgressHUD hideAllHUDsForView:myWindow animated:true];
    }
    else{
        [SVProgressHUD showSuccessWithStatus:@"连接成功！"];
        [SVProgressHUD dismissWithDelay:1];
    }
}



-(void)conectionStatus:(NSNotification *)noti
{
//    NSLog(@"conectionStatus:(NSNotification *)noti!!!");
    int code = [GCUser getInstance].device.code;
    if ([GCUser getInstance].device.deviceId == nil) {
        self.wifiConnectView.hidden = YES;
        code = -1;
    }else
        self.wifiConnectView.hidden = NO;
    
    if (code == -1) {
        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:0];
        self.leftView.isConection = NO;
        self.rightView.isConection = NO;
    }else
    {
        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:1];
        self.leftView.isConection = YES;
        self.rightView.isConection = YES;
    }
    //加载更新开关机动态
    NSDictionary *data=[noti userInfo];
//    NSLog(@"NSDictionary = %@",data);
    int deviceId=[data[@"isLeft"] intValue];
    int power=[data[@"isOpen"] intValue];
    [self updatePowerWithDevice:deviceId State:power];
}

- (void) removeDeviceView
{
    [self.deviceVc willMoveToParentViewController:nil];
    [self.deviceVc removeFromParentViewController];
    [self.deviceVc.view removeFromSuperview];
    
}

- (void) addDeivceView
{
 
    
    [self addChildViewController:self.deviceVc];
    
    self.deviceVc.view.frame=self.view.bounds;
    
    self.deviceVc.dataSoucre=[GCUser getInstance].deviceList;
    
    [self.view addSubview:self.deviceVc.view];
}




//- (void) showModenView:(GCModen *)model{
//    
//    
//   // self.bottomView.hidden=YES;
//    
//    if (modenVc) {
//        
//        if ([self.controllerView.subviews containsObject:modenVc.view]) {
//            [modenVc.view removeFromSuperview];
//        }
//    }
//    
//    modenVc = [[GCAdjustViewController alloc] initWithNibName:@"GCAdjustViewController" bundle:nil];
//    
//    modenVc.moden=model;
//    
//    modenVc.delegate=self;
//    
//    modenVc.deviceId=(int)self.segmentControl.selectIndex;
//    
//    
//    [self.controllerView addSubview:modenVc.view];
//    
//    [CATransitionHelper addTransitionWithLayer:modenVc.view.layer animationType:kCATransitionPush subtype:kCATransitionFromTop duration:0.4];
//    
//    [modenVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(self.controllerView.mas_left).offset(0);
//        make.right.mas_equalTo(self.controllerView.mas_right).offset(0);
//        make.top.mas_equalTo(self.controllerView.mas_top).offset(0);
//        make.bottom.mas_equalTo(self.controllerView.mas_bottom).offset(0);
//        
//    }];
//    
//    [modenVc didMoveToParentViewController:self];
//    
//    
//}


- (void) removeStallViewWithBottomViewHide:(BOOL)hide
{
    float duration=0.4;
    
    [CATransitionHelper addTransitionWithLayer:modenVc.view.layer animationType:kCATransitionPush subtype:kCATransitionFromBottom duration:duration];
    
    
    modenVc.view.hidden=YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [modenVc.view removeFromSuperview];
        [modenVc removeFromParentViewController];
        //self.bottomView.hidden=hide;
    });
    
    
    //self.bottomView.hidden=hide;
    
}



#pragma mark -GCSegmentedControlDelegate
- (void)segmentedValueChange:(NSInteger)value
{
    
    
 //   float delay=0.0;
    
//    if ([self.controllerView.subviews containsObject:modenVc.view]) {
//        [self removeStallViewWithBottomViewHide:YES];
//        delay=0.45;
//    }
    
 //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        float duration=0.2;
        
        
        if (value==0) {
            
      
            [CATransitionHelper addTransitionWithLayer:self.leftView.layer animationType:kCATransitionPush subtype:kCATransitionFromLeft duration:duration];
            [CATransitionHelper addTransitionWithLayer:self.rightView.layer animationType:kCATransitionPush subtype:kCATransitionFromLeft duration:duration];
            
            self.rightView.hidden=YES;
            self.leftView.hidden=NO;
        
            
        }else{
            
           
            [CATransitionHelper addTransitionWithLayer:self.leftView.layer animationType:kCATransitionPush subtype:kCATransitionFromRight duration:duration];
            [CATransitionHelper addTransitionWithLayer:self.rightView.layer animationType:kCATransitionPush subtype:kCATransitionFromRight duration:duration];
            self.leftView.hidden=YES;
            self.rightView.hidden=NO;
            

        }
  //  });
    
    
}

#pragma mark -用户交互方法
- (IBAction)rootButtonClick:(id)sender {
    
    GCImageTopButton *bt=sender;
    
    if (bt.selected) {
//
//        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:0] timeout:-1 tag:KTagPowerOff ReceiveBlock:^(NSData *data, long tag) {
//            NSLog(@"data = %@ tag = %ld",data,tag);
//            if (tag==KTagPowerOff) {
//
//            }
//
//        }];
//        NSLog(@"bt.selected is true ! = %@",[GCAgreementHelper getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:0]);
//        [SVProgressHUD showWithStatus:@"bt.selected is true ! "];
          [[RHSocketConnection getInstance] writeData:[GCAgreementHelper getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:0] timeout:5 tag:KTagPowerOff];
        
    }else{
        
        //  [GCAgreementHelper getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:1];
        
//        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:1] timeout:-1 tag:KTagPowerOn ReceiveBlock:^(NSData *data, long tag) {
//
//            if (tag==KTagPowerOn) {
//
//
//            }
//
//        }];
        
       [[RHSocketConnection getInstance] writeData:[GCAgreementHelper getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:1] timeout:5 tag:KTagPowerOn];
//        NSLog(@"bt.selected is false ! = %@",[GCAgreementHelper getRootBytesWithDeviceId:(int)self.segmentControl.selectIndex status:0]);
//        [SVProgressHUD showWithStatus:@"bt.selected is false ! "];
    }
    
    
    
}


- (IBAction)reservation {
    
   // GCSubDevice *subDevice=self.segmentControl.selectIndex==0?[GCUser getInstance].device.leftDevice:[GCUser getInstance].device.rightDevice;
    
    BOOL hasReservation=self.segmentControl.selectIndex==0 ? [GCUser getInstance].device.leftDevice.hasReservation:[GCUser getInstance].device.rightDevice.hasReservation;
    
    if (hasReservation) {
        
        GCReservationPreviewViewController *vc=[[GCReservationPreviewViewController alloc] initWithNibName:@"GCReservationPreviewViewController" bundle:nil];
        
        vc.deviceId=(int)self.segmentControl.selectIndex;
        
//        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"vc.deviceId = %d",vc.deviceId]];
//        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"vc.reservationModen.deviceId = %d",vc.reservationModen.deviceId]];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
        
        GCReservationViewController *vc=[[GCReservationViewController alloc] initWithNibName:@"GCReservationViewController" bundle:nil];
        vc.title=@"预约";
        vc.state=self.segmentControl.selectIndex;
//        vc.state=labs(self.segmentControl.selectIndex-1);
//        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%ld",labs(self.segmentControl.selectIndex-1)]];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
}


- (IBAction)unreservation{
    
    
    GCSubDevice *subDevice=self.segmentControl.selectIndex==0?[GCUser getInstance].device.leftDevice:[GCUser getInstance].device.rightDevice;
    
    if (!subDevice.hasReservation) {
//        [SVProgressHUD showWithStatus:@"show!"];
//        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"请点击\"预约\"按钮设置预约程序"];
//        [alertView addButtonWithTitle:@"确定"
//                                 type:SIAlertViewButtonTypeCancel
//                              handler:^(SIAlertView *alertView) {
//
//                                  [alertView dismissAnimated:NO];
//
//                              }];
//
//
//        [alertView show];

        
        MyAlertView *alertView=[[MyAlertView alloc] initWithTitle:@"提示" message:@"请点击\"预约\"按钮设置预约程序" otherButtonTitles:@[@"确定"] listener:nil];
        [alertView show];
        
        
        return;
    }
    
    GCReservationPreviewViewController *vc=[[GCReservationPreviewViewController alloc] initWithNibName:@"GCReservationPreviewViewController" bundle:nil];
    
    vc.deviceId=(int)self.segmentControl.selectIndex;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)openModenViewButtonClick:(id)sender {
    
    //  GCModen *mod=[GCUser getInstance].device.leftDevice.selModen;
    
    GCModen *moden=self.segmentControl.selectIndex==0?[GCUser getInstance].device.leftDevice.selModen:[GCUser getInstance].device.rightDevice.selModen;
    
  
}


#pragma mark -GCAdjustViewControllerDelegate
-(void)removeButtonClickWithDeivceId:(int) deviceId
{
    
    [self removeStallViewWithBottomViewHide:NO];
    
}

#pragma mark -GCLeftDeivceViewDelegate
- (void)leftModenButtonClick:(GCModenButton *)button
{
    
    
   
    
    
}

- (void) leftReservationButtonClick
{
    
    [self reservation];
    
}

- (void) leftUnreservationButtonClick
{
    
    [self unreservation];
    
}

- (void)changeDeivceButtonClick
{
    if ([self.childViewControllers containsObject:self.deviceVc]) {
        
        [self removeDeviceView];
        
    }else{
        
        [self addDeivceView];
    }
}


#pragma mark -GCRightDeivceViewDelegate
- (void)rightModenButtonClick:(GCModenButton *)button
{
    
   
}

- (void)rightReservationButtonClick
{
     [self reservation];
}

- (void)rightUnreservationButtonClick
{
    [self unreservation];
}


#pragma mark -监听数据变化1
- (void) receiveNoti1:(NSNotification *)noti
{
    //NSDictionary *dict=[noti userInfo];
    
    //从soap 信息中解析出CusotmerDetail 对象
    @try
    {
        NSDictionary *data=[noti userInfo][@"data"];
        
        NSLog(@"NSDictionary = %@",data);
        
        int deviceId=[data[@"deviceId"] intValue];
        
//        if (deviceId==1) {
//
//            [GCUser getInstance].device.leftDevice.powerState=1;
//
//        }else{
//            [GCUser getInstance].device.rightDevice.powerState=1;
//        }
        
        //  self.root_bt.selected=self.segmentControl.selectIndex==deviceId?YES:NO;
        
        switch ([data[@"code"] intValue]) {
                
            case (1)://状态查询
            {
                [self updateStateWithBytes:data];
            }
                break;
                
            case (2)://开机回复
            {
                
               // int power=[data[@"power"] intValue];
                
               // [self updatePowerWithDevice:deviceId State:power];
            }
                break;
                
            case (3)://模式设定回复
            {
                
                int moden=[data[@"moden"] intValue];
                
                [self updateModenWithiDevoceId:deviceId moden:moden];
                
                
            }
                break;
                
            case (4)://档位设置回复
            {
                
                int stalls=[data[@"stall"] intValue];
                int mod=[data[@"moden"] intValue];
                
                
                [self updateStallsWithiDevoceId:deviceId moden:mod stalls:stalls];
            }
                
                break;
            case (9)://收到故障报警
            {
                
                [self deviceErrorWithDict:data];
            }
                
                break;
                
                
            default:
                break;
        }
        
        
        
    }@catch (NSException * e) {
        
        return;
    }
}
#pragma mark -监听数据变化2
- (void) receiveNoti:(NSNotification *)noti
{
    //NSDictionary *dict=[noti userInfo];
    
    //从soap 信息中解析出CusotmerDetail 对象
    @try
    {
        //        NSDictionary *data=[noti userInfo][@"data"];
        NSDictionary *totalData = [noti userInfo];
        NSDictionary *cookerData = totalData[@"cookerItem"];
        
//        NSLog(@"NSDictionary = %@",data);
        
/**       新旧参数对照表
       含义                新参数                旧参数
      左、右炉           isLeft (1、0)         deviceId(0、1)
    电源开启状态(1、0)       isOpen(1、0)          power(1、0)         给服务器传参时，此处有坑！！！！【开：0  关：1】
 
 
                             LYuYue = "";
                             RYuYue = "";
                             cookerItem =     {
                             curError = XX;
                             curMode = "-1";
                             curPower = 0;
                             cursystemtime = 0;
                             maxPower = 0;
                             maxcookTime = 0;
                             showStallsMode = "-1";
                             };
                             id = 882c9e98b76700000000;
                             isCancel = 0;
                             isLeft = 1;
                             isOpen = 1;
                             msgtype = 1;
                             rectype = 2;
                             target = 123450;
                             type = 1;
        */
        int deviceId = [totalData[@"isLeft"] intValue];
        int power = [totalData[@"isOpen"] intValue];
        int moden = [cookerData[@"curMode"] intValue];  //当前模式
        int stalls=[cookerData[@"curPower"] intValue];  //当前档位
        int showStallsMode=[cookerData[@"showStallsMode"] intValue];  //当前显示模式类型           摄氏度：1       功率数：2       AUTO:3
        
//        NSLog(@"cookerData[@curError] = %@",cookerData[@"curError"]);
        //【1】状态查询       （复杂、待完善）
        [self updateStateWithBytes:totalData];
        //【2】开关机状态同步回复
//        [self updatePowerWithDevice:deviceId State:power];
        //【3】模式设定回复    （实时更新同步火炉状态、待完善）
//        [self updateModenWithiDevoceId:deviceId moden:moden];
        //【4】档位设置回复
//        [self updateStallsWithiDevoceId:deviceId moden:moden stalls:stalls];
        //【5】收到故障报警
//        [self deviceErrorWithDict:totalData];
        //【6】模式设定回复
        
        
#pragma mark -收到故障报警 curError参数！！！
        
        
        
        
        
        
        
        
    }@catch (NSException * e) {
        
        return;
    }
}


- (void) receiveNotiDeivceDisconnect
{
    [self.leftView powerState:NO hasReservation:NO monden:-1];
    
    [self.rightView powerState:NO hasReservation:NO monden:-1];
    
    [self.segmentControl updateItemWithIndex:0 title:@"     "];
    
    [self.segmentControl updateItemWithIndex:1 title:@"     "];
}

- (void) selectDeiveChange
{
    if ([GCUser getInstance].device.deviceId == nil) {
        self.wifiConnectView.hidden = YES;
        [self conectionStatus];
    }else
        self.wifiConnectView.hidden = NO;
    
    self.deviceNameLabel.text=[GCUser getInstance].device.deviceId;
    [self.leftView powerState:NO hasReservation:NO monden:-1];
    
    [self.rightView powerState:NO hasReservation:NO monden:-1];
    
    [self.segmentControl updateItemWithIndex:0 title:@"     "];
    
    [self.segmentControl updateItemWithIndex:1 title:@"     "];
    
    
}

- (void) connectSokectServeStateChange:(NSNotification *)noti
{
//    NSDictionary *dict=[noti userInfo];
//    WifiConnectType state=[dict[@"state"] integerValue];
//    if (state == WifiConnectTypeDisconnect) {
//        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:0];
//    }else
//    {
//        [self.wifiConnectView setWifiConnectLabelTitleWithIndex:1];
//    }
}

#pragma mark -根据数据更新UI

/**
 更新开/关机状态
 
 @param device 炉号
 @param state 开关机状态
 */
- (void) updatePowerWithDevice0:(int)device State:(int)state
{
//    NSLog(@"updatePowerWithDevice");
    if(self.segmentControl.selectIndex==device&&state==1)
    {
       // self.root_bt.selected=YES;
        
    }else if(self.segmentControl.selectIndex==device&&state==0)
    {
        //self.root_bt.selected=NO;
    }
    
    
    if (device==0) {
        
        [GCUser getInstance].device.leftDevice.powerState=state;
        [self.leftView powerState:state hasReservation:NO monden:-1];
        
    }else{
        [GCUser getInstance].device.rightDevice.powerState=state;
         [self.rightView powerState:state hasReservation:NO monden:-1];
    }
    
    
    if (state==0&&device==0) {
        
       
        
        [self.segmentControl updateItemWithIndex:0 title:@"--W"];
        
        //self.bottomView.hidden=[GCUser getInstance].device.leftDevice.selModen?NO:YES;
        
    }else if(state==0&&device==1)
    {
        
        [self.segmentControl updateItemWithIndex:1 title:@"--W"];
        //self.bottomView.hidden=[GCUser getInstance].device.rightDevice.selModen?NO:YES;
    }
    
    
    
}

- (void) updatePowerWithDevice:(int)device State:(int)state
{
//    NSLog(@"updatePowerWithDevice");
    if(device==1&&state==1)
    {
//        NSLog(@"1    1");
        [self.segmentControl updateItemWithIndex:0 title:@"已开机"];
    }
    if(device==0&&state==1)
    {
//        NSLog(@"0    1");
        [self.segmentControl updateItemWithIndex:1 title:@"已开机"];
    }
    if (device==1&&state==0) {
//        NSLog(@"1    0");
        [self.segmentControl updateItemWithIndex:0 title:@"    "];
        //self.bottomView.hidden=[GCUser getInstance].device.leftDevice.selModen?NO:YES;
    }
    if(device==0&&state==0)
    {
//        NSLog(@"0    0");
        [self.segmentControl updateItemWithIndex:1 title:@"    "];
        //self.bottomView.hidden=[GCUser getInstance].device.rightDevice.selModen?NO:YES;
    }
    
    
    if (device==1) {
//        [self.segmentControl updateItemWithIndex:1 title:@"已开机"];
        [GCUser getInstance].device.leftDevice.powerState=state;
        [self.leftView powerState:state hasReservation:NO monden:-1];
    }else{
//        [self.segmentControl updateItemWithIndex:0 title:@"已开机"];
        [GCUser getInstance].device.rightDevice.powerState=state;
        [self.rightView powerState:state hasReservation:NO monden:-1];
    }
    
    

}



/*状态更新
 
 @param dict bytes description
 */

- (void) updateStateWithBytes1:(NSDictionary *)dict
{

    int deviceId=0;
    
    int moden=0;
    
    int power=0;
    
    int stall=0;
    
    BOOL reservation=NO;
    
    @try {
        deviceId=[dict[@"deviceId"] intValue];
        
        moden=[dict[@"moden"] intValue];
        
        power=[dict[@"power"] intValue];
        
        stall=[dict[@"stall"] intValue];
        
        reservation=[dict[@"reservation"] boolValue];
        
    } @catch (NSException *exception) {
        
        return;
    }
    
    
    //数据过滤
    NSString *lastStr=deviceId==1?self.leftDeviceLastData:self.rightDeviceLastData;
    NSString *statusStr=[dict dictionaryToJson];
    
    if ([statusStr isEqualToString:lastStr]) {
        // return;
    }
    
    if (deviceId==1) {
        self.leftDeviceLastData=statusStr;
    }else{
        self.rightDeviceLastData=statusStr;
    }
    
    GCLog(@"查询到的模式%d   查询到的档位%d",moden,stall);
    GCSubDevice *subDevice=deviceId==1?[GCUser getInstance].device.leftDevice:[GCUser getInstance].device.rightDevice;
    
    GCModen *selModen=subDevice.selModen;
    
    subDevice.powerState=power;
    
    subDevice.hasReservation=reservation;
    
    
    if (power==1) {
        
        deviceId==1?[self.leftView powerState:YES hasReservation:reservation monden:moden]:[self.rightView powerState:YES hasReservation:reservation monden:moden];
        
        if (moden!=selModen.modenId%100||selModen==nil) {
            
            subDevice.selModen=deviceId==1?[self.leftView updateModen:moden]:[self.rightView updateModen:moden];
            
            NSDictionary *dict=@{
                                 @"stalls":[NSNumber numberWithInt:stall],
                                 @"deviceId":[NSNumber numberWithInt:deviceId],
                                 @"moden":[NSNumber numberWithInt:moden]
                                 };
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
            
            
        }else{
            
            if(subDevice.selModen.currentStall!=stall)
            {
                subDevice.selModen.currentStall=stall;
                NSDictionary *dict=@{
                                     @"stalls":[NSNumber numberWithInt:stall],
                                     @"deviceId":[NSNumber numberWithInt:deviceId],
                                     @"moden":[NSNumber numberWithInt:moden]
                                     };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
                
            }
        }
        
    }else if(power==0)
    {
        deviceId==1?[self.leftView powerState:NO hasReservation:reservation monden:-1]:[self.rightView powerState:NO hasReservation:reservation monden:-1];
    }
    
    //不分左右炉刷新
    [self.segmentControl updateItemWithIndex:deviceId title:[GCAgreementHelper getPowerWhithDeivce:deviceId moden:moden stalls:stall]];
    
    
    if (power==0&&deviceId==1) {
        
        
        [self.segmentControl updateItemWithIndex:0 title:@"     "];
        [GCUser getInstance].device.leftDevice.selModen=nil;
        
    }else if(power==0&&deviceId==1)
    {
        [self.segmentControl updateItemWithIndex:1 title:@"     "];
        [GCUser getInstance].device.rightDevice.selModen=nil;
    }
}

- (void) updateStateWithBytes2:(NSDictionary *)dict
{
    /**       新旧参数对照表
        含义                新参数                旧参数
        左、右炉           isLeft (1、0)         deviceId(0、1)
        电源开启状态(1、0)       isOpen(1、0)          power(1、0)         给服务器传参时，此处有坑！！！！【开：0  关：1】
     
        LYuYue = "";
        RYuYue = "";
        cookerItem =
        {
            curError = XX;
            curMode = "-1";
            curPower = 0;
            cursystemtime = 0;
            maxPower = 0;
            maxcookTime = 0;
            showStallsMode = "-1";
        };
        id = 882c9e98b76700000000;
        isCancel = 0;
        isLeft = 1;
        isOpen = 1;
        msgtype = 1;
        rectype = 2;
        target = 123450;
        type = 1;
    */
    NSDictionary *totalData = dict;
    NSDictionary *cookerItemsData = totalData[@"cookerItem"];
    NSString *leftYuYue = totalData[@"LYuYue"];
    NSString *rightYuYue = totalData[@"RYuYue"];
        NSString *curError = cookerItemsData[@"curError"];                  //错误码
        int curMode = [cookerItemsData[@"curMode"] intValue];               //当前模式      -1代表无任何模式
        int curPower = [cookerItemsData[@"curPower"] intValue];             //当前档位、功率
        NSString *cursystemtime = cookerItemsData[@"cursystemtime"];        //模式切换时间
        int maxPower = [cookerItemsData[@"curPower"] intValue];             //最大功率、档位
        int maxcookTime = [cookerItemsData[@"maxcookTime"] intValue]/1000;   //最大烹饪时间 【单位：分钟】
        int showStallsMode = [cookerItemsData[@"showStallsMode"] intValue];  //当前显示模式类型       已开机： -1     显示定时和自动AUTO ：0    摄氏度：1       功率数：2       都是自动AUTO:3
    NSString *idName = totalData[@"id"];
    int isLeft = [totalData[@"isLeft"] intValue];
    int isOpen = [totalData[@"isOpen"] intValue];
    int isCancel = [totalData[@"isCancel"] intValue];
    NSString *target = totalData[@"target"];
    
    
    //判断是否有预定
    BOOL reservation = NO;
    //预约状态
//    reservation = [leftYuYue isEqualToString:@""]||[leftYuYue isEqualToString:@""] ? NO:YES;
    
    if (isLeft==1) {
        reservation = [leftYuYue isEqualToString:@""] ? NO:YES;
    }else{
        reservation = [rightYuYue isEqualToString:@""] ? NO:YES;
    }
    
    //关机状态
    if((isOpen==0&&isLeft==1)||(isOpen==0&&isLeft==0)){
        if (isLeft==1) {
            [self.segmentControl updateItemWithIndex:1 title:@"     "];
            [GCUser getInstance].device.leftDevice.selModen=nil;
            [GCUser getInstance].device.leftDevice.powerState=NO;
            [self.leftView powerState:NO hasReservation:reservation monden:-1];
        }else{
            [self.segmentControl updateItemWithIndex:0 title:@"     "];
            [GCUser getInstance].device.rightDevice.selModen=nil;
            [GCUser getInstance].device.rightDevice.powerState=NO;
            [self.rightView powerState:NO hasReservation:reservation monden:-1];
        }
    }else
    //开机状态
    {
        //【1】powerButton显示状态
        if (isLeft==1) {
            //        [self.segmentControl updateItemWithIndex:1 title:@"已开机"];
            [GCUser getInstance].device.leftDevice.powerState=YES;
            [self.leftView powerState:YES hasReservation:reservation monden:-1];
        }else{
            //        [self.segmentControl updateItemWithIndex:0 title:@"已开机"];
            [GCUser getInstance].device.rightDevice.powerState=YES;
            [self.rightView powerState:YES hasReservation:reservation monden:-1];
        }
        //【2】segmentControl显示状态
        //当前显示模式类型       已开机： -1     显示定时和自动AUTO ：0    摄氏度：1       功率数：2       都是自动AUTO:3
        [GCUser getInstance].device.leftDevice.selModen.aotuWork = 0;
        switch (showStallsMode){
            case -1:
                [self.segmentControl updateItemWithIndex:isLeft title:@"已开机"];
                break;
            case 1:
                [self.segmentControl updateItemWithIndex:isLeft title:@"摄氏度"];
                break;
            case 2:
                [self.segmentControl updateItemWithIndex:isLeft title:[GCAgreementHelper getPowerWhithDeivce:isLeft moden:curMode stalls:curPower]];
                break;
            case 0:
            case 3:
                [GCUser getInstance].device.leftDevice.selModen.aotuWork = 1;
                [self.segmentControl updateItemWithIndex:isLeft title:@"Auto"];
                
//                [self.segmentControl updateItemWithIndex:isLeft title:[GCAgreementHelper getPowerWhithDeivce:isLeft moden:curMode stalls:curPower]];
                break;
        }
    }
//    [self.segmentControl updateItemWithIndex:isLeft stallsMode:showStallsMode];

    
    
    
    
    
    //数据过滤
//    NSString *lastStr = isLeft==1 ? self.leftDeviceLastData:self.rightDeviceLastData;
    NSString *statusStr=[dict dictionaryToJson];
    if (isLeft==1) {
        self.leftDeviceLastData=statusStr;
    }else{
        self.rightDeviceLastData=statusStr;
    }
    GCLog(@"查询到的模式%d   查询到的档位%d",curMode,curPower);
    
//    GCSubDevice *subDevice=isLeft==1?[GCUser getInstance].device.leftDevice:[GCUser getInstance].device.rightDevice;
//
//    GCModen *selModen = subDevice.selModen;
//
//    subDevice.powerState=isOpen;
//
//    subDevice.hasReservation=reservation;
//
//
//    if (isOpen==1) {
//
//        isLeft==1?[self.leftView powerState:YES hasReservation:reservation monden:curMode]:[self.rightView powerState:YES hasReservation:reservation monden:curMode];
//
//        if (curMode!=selModen.modenId%100||selModen==nil) {
//
//            subDevice.selModen=isLeft==1?[self.leftView updateModen:curMode]:[self.rightView updateModen:curMode];
//
//            NSDictionary *dict=@{
//                                 @"stalls":[NSNumber numberWithInt:curPower],
//                                 @"deviceId":[NSNumber numberWithInt:isLeft],
//                                 @"moden":[NSNumber numberWithInt:curMode]
//                                 };
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
//
//
//        }else{
//
//            if(subDevice.selModen.currentStall!=curPower)
//            {
//                subDevice.selModen.currentStall=curPower;
//                NSDictionary *dict=@{
//                                     @"stalls":[NSNumber numberWithInt:curPower],
//                                     @"deviceId":[NSNumber numberWithInt:isLeft],
//                                     @"moden":[NSNumber numberWithInt:curMode]
//                                     };
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
//
//            }
//        }
//
//    }else if(isOpen==0)
//    {
//        isLeft==1?[self.leftView powerState:NO hasReservation:reservation monden:-1]:[self.rightView powerState:NO hasReservation:reservation monden:-1];
//    }
//
//    //不分左右炉刷新
//    [self.segmentControl updateItemWithIndex:isLeft title:[GCAgreementHelper getPowerWhithDeivce:isLeft moden:curMode stalls:curPower]];
//
//
    
    
}

- (void) updateStateWithBytes:(NSDictionary *)dict
{
    NSDictionary *totalData = dict;
    NSDictionary *cookerItemsData = totalData[@"cookerItem"];
    NSString *leftYuYue = totalData[@"LYuYue"];
    NSString *rightYuYue = totalData[@"RYuYue"];
        NSString *curError = cookerItemsData[@"curError"];                  //错误码
        int curMode = [cookerItemsData[@"curMode"] intValue];               //当前模式      -1代表无任何模式
        int curPower = [cookerItemsData[@"curPower"] intValue];             //当前档位、功率
        NSString *cursystemtime = cookerItemsData[@"cursystemtime"];        //模式切换时间
        int maxPower = [cookerItemsData[@"curPower"] intValue];             //最大功率、档位
        int maxcookTime = [cookerItemsData[@"maxcookTime"] intValue]/1000;   //最大烹饪时间 【单位：分钟】
        int showStallsMode = [cookerItemsData[@"showStallsMode"] intValue];  //当前显示模式类型       已开机： -1     显示定时和自动AUTO ：0    摄氏度：1       功率数：2       都是自动AUTO:3
    NSString *idName = totalData[@"id"];
    int isLeft = [totalData[@"isLeft"] intValue];
    int isOpen = [totalData[@"isOpen"] intValue];
    int isCancel = [totalData[@"isCancel"] intValue];
    NSString *target = totalData[@"target"];
    
    
    
    int deviceId = 0;
    
    int moden=0;
    
    int power=0;
    
    int stall=0;
    
    BOOL reservation=NO;
    
    @try {
//        deviceId=abs([dict[@"isLeft"] intValue]-1);
        
        deviceId = [dict[@"isLeft"] intValue];
        int modelId;
        if (deviceId == 1) {
            switch (curMode) {
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
                default:
                    modelId = curMode;
                    break;
            }
        }else{
//            NSLog(@"右边火炉！！！");
            switch (curMode) {
                case 0:
                    modelId = 110;
                    break;
                case 1:
                    modelId = 111;
                    break;
                case 2:
                    modelId = 112;
                    break;
                case 3:
                    modelId = 108;
                    break;
                case 4:
                    modelId = 109;
                    break;
                case 5:
                    modelId = 107;
                    break;
                default:
                    modelId = curMode;
                    break;
            }
//            int moden=button.moden.modenId%100;
//            modelId = modelId*100+modelId;
        }
        moden = modelId;
        power = [dict[@"isOpen"] intValue];
        
//        stall=[dict[@"stall"] intValue];
        stall = curPower;
//        reservation=[dict[@"reservation"] boolValue];
        if (deviceId==1) {
            reservation = [leftYuYue isEqualToString:@""] ? NO:YES;
        }else{
            reservation = [rightYuYue isEqualToString:@""] ? NO:YES;
        }
        
    } @catch (NSException *exception) {
        
        return;
    }
    
    
    //数据过滤
    NSString *lastStr=deviceId==1?self.leftDeviceLastData:self.rightDeviceLastData;
    NSString *statusStr=[dict dictionaryToJson];
    
    if ([statusStr isEqualToString:lastStr]) {
        // return;
    }
    
    if (deviceId==1) {
        self.leftDeviceLastData=statusStr;
    }else{
        self.rightDeviceLastData=statusStr;
    }
    
    GCLog(@"当前火炉 %d  查询到的模式 %d   查询到的档位 %d",deviceId,moden,stall);
    GCSubDevice *subDevice=deviceId==1?[GCUser getInstance].device.leftDevice:[GCUser getInstance].device.rightDevice;
    
    GCModen *selModen=subDevice.selModen;
    
    subDevice.powerState=power;
    
    subDevice.hasReservation=reservation;
    
    
    if (power==1) {
        
        deviceId==1?[self.leftView powerState:YES hasReservation:reservation monden:moden]:[self.rightView powerState:YES hasReservation:reservation monden:moden];
        //当前模式更改 或是 不为空 的时候
//        NSLog(@"moden = %d",moden);
//        NSLog(@"selModen.modenId = %d",selModen.modenId);
        if (moden!=selModen.modenId||selModen==nil) {
//            NSLog(@"当前模式更改！");
            subDevice.selModen=deviceId==1?[self.leftView updateModen:moden]:[self.rightView updateModen:moden];
            
            NSDictionary *dict=@{
                                 @"stalls":[NSNumber numberWithInt:stall],
                                 @"deviceId":[NSNumber numberWithInt:deviceId],
                                 @"moden":[NSNumber numberWithInt:moden]
                                 };
            //设备档位发生变化
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
        }else{
//            NSLog(@"subDevice.selModen.currentStall = %d",subDevice.selModen.currentStall);
            if(subDevice.selModen.currentStall!=stall)
            {
                subDevice.selModen.currentStall=stall;
                NSDictionary *dict=@{
                                     @"stalls":[NSNumber numberWithInt:stall],
                                     @"deviceId":[NSNumber numberWithInt:deviceId],
                                     @"moden":[NSNumber numberWithInt:moden]
                                     };
                //设备档位发生变化
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
            }
        }
        
    }else if(power==0)
    {
        deviceId==1?[self.leftView powerState:NO hasReservation:reservation monden:-1]:[self.rightView powerState:NO hasReservation:reservation monden:-1];
    }
    
    //不分左右炉刷新
    
//    if (deviceId==1&&power==1) {
//        [self.segmentControl updateItemWithIndex:1 title:[GCAgreementHelper getPowerWhithDeivce:deviceId moden:moden stalls:stall]];
//    }
//    if (deviceId==0&&power==1) {
//        [self.segmentControl updateItemWithIndex:0 title:[GCAgreementHelper getPowerWhithDeivce:deviceId moden:moden stalls:stall]];
//    }
    
//    if ((deviceId==1&&power==1)||(deviceId==0&&power==1)) {
        [self.segmentControl updateItemWithIndex:deviceId title:[GCAgreementHelper getPowerWhithDeivce:deviceId moden:moden stalls:stall]];
//    }
    
    if (deviceId==1&&power==0) {
//        [SVProgressHUD showErrorWithStatus:@"left segmentControl"];
        [self.segmentControl updateItemWithIndex:1 title:@"     "];
        [GCUser getInstance].device.leftDevice.selModen=nil;
        
    }
    if(deviceId==0&&power==0)
    {
//        [SVProgressHUD showErrorWithStatus:@"right segmentControl"];
        [self.segmentControl updateItemWithIndex:0 title:@"     "];
        [GCUser getInstance].device.rightDevice.selModen=nil;
    }
}


/**
 更新模式
 
 @param deviceId 炉号
 @param moden 模式
 */
- (void) updateModenWithiDevoceId:(int)deviceId moden:(int)moden
{
//    GCLog(@"模式设置测试,回复模式编号%d",moden);
    GCLog(@"当前火炉位置：%d,模式编号：%d",deviceId,moden);
}


/**
 更新档位状态
 
 @param deviceId 炉号
 @param moden 模式
 @param stalls 档位
 */
- (void) updateStallsWithiDevoceId:(int)deviceId moden:(int)moden stalls:(int) stalls
{
    [self.segmentControl updateItemWithIndex:deviceId title:[GCAgreementHelper getPowerWhithDeivce:deviceId moden:moden stalls:stalls]];

    NSDictionary *dict=@{
                         @"stalls":[NSNumber numberWithInt:stalls],
                         @"deviceId":[NSNumber numberWithInt:deviceId],
                         @"moden":[NSNumber numberWithInt:moden]
                         };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStallsChange object:nil userInfo:dict];
}

- (void) deviceErrorWithDict:(NSDictionary *)dict
{
    //    0x0001 无锅或锅材质不对或锅具小于8cm（故障代码：E1）
    //    0x0002 高压保护（故障代码：E3）
    //    0x0004 低压保护（故障代码：E4）
    //    0x0008 IGBT超温（故障代码：E2）
    //    0x0010 炉面开路（热敏开路）（故障代码：E5）
    //    0x0020炉面超温保护，短路保护（故障代码：E6）
    //    0x0040线盘开路短路，振荡电路故障（大电容开路短路）（故障代码：E0）
    
    NSLog(@"故障信息%@",dict);
    
    int deviceId=[dict[@"deviceId"] intValue];
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getErorrBackDataWithDeviceId:deviceId] timeout:-1 tag:-1];
    
    NSString *errorStr=dict[@"warm"];
    
    NSArray  *array = [errorStr componentsSeparatedByString:@"___"];//--分隔符
    
    NSString *error=array[0];
    
    int errorCode=(int)[HexStringChange numberWithHexString:[error substringWithRange:NSMakeRange(1, error.length-1)]] ;
    
    if (![array[1] isEqualToString:self.lastErrorId])
    {
        self.lastErrorId=array[1];
    }else{
        return;
    }
    
    
    
    
    
    if (errorCode!=0) {
        
        
        NSString *error=@"";
        
        switch (errorCode) {
            case (0x01)://无锅或锅材质不对或锅具小于8cm
            {
                error=@"无锅、锅具过小或锅具材质不对,请放置正确的锅具。";
            }
                break;
            case (0x03)://高压保护
            {
                error=@"电压过高，请检查或更换供电电源";
            }
                break;
            case (0x04)://低压保护
            {
                error=@"电压过低，请检查或更换供电电源";
            }
                break;
            case (0x02)://IGBT超温
            {
                error=@"器件温度过高，请联系售后维修。售后电话400-8888-8888";
            }
                break;
            case (0x05)://炉面开路（热敏开路）
            {
                error=@"炉面温检失败,请联系售后维修。售后电话400-8888-8888";
            }
                break;
            case (0x06)://炉面超温保护，短路保护
            {
                error=@"炉面温度过高,请联系售后维修。售后电话400-8888-8888";
            }
                break;
            case (0x00)://线盘开路短路，振荡电路故障
            {
                error=@"电路故障,请联系售后维修.售后电话400-8888-8888";
            }
                break;
                
                
            default:
                break;
        }
        
        
        
        error=deviceId==1?[@"(左炉) " stringByAppendingString:error]:[@"(右炉) " stringByAppendingString:error];
        
        [GCDiscoverView showWithTip:error];
        
        [GCUser getInstance].device.error++;
        
        
        GCNotificationCellMd *model=[GCNotificationCellMd createModelWithNotiState:errorCode text:error date:[NSDate date]];
        
        [[GCDataBasicManager shareManager] insertOneDataOnTable:KErrorTableName model:model];
        
        NSDictionary *dict=@{
                             @"error":model
                             };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiError object:nil userInfo:dict];
    }
    
    
    
    
}

#pragma mark -GCDeviceListViewControllerDelegate
- (void)portableDeviceSelected:(GCDevice *)device
{
    
    if (device) {
        
        if (device!=[GCUser getInstance].device) {
            
             [self.hud addNormHudWithSupView:self.view title:@"正在切换电磁炉..."];
            
//            *         手机号码    mobile=13800138000
//            *         token值        token=adsafokjdsoaidslakjfsdalkj
//            *         电磁炉编号    devcode=test01
            
            NSDictionary *dict=@{
                                 @"mobile":[GCUser getInstance].mobile,
                                 @"token":[GCUser getInstance].token,
                                 @"devcode":device.deviceId
                                 };
            
            [GCHttpDataTool changeSelectDeviceWithDict:dict success:^(id responseObject) {
                
                [[GCUser getInstance].device resetSubdevice];
                
                [GCUser getInstance].device=device;
                self.deviceNameLabel.text=[GCUser getInstance].device.deviceId;
                
                [self.leftView powerState:NO hasReservation:NO monden:-1];
                
                [self.rightView powerState:NO hasReservation:NO monden:-1];
                
                [self.segmentControl updateItemWithIndex:0 title:@"     "];
                
                [self.segmentControl updateItemWithIndex:1 title:@"     "];
       
                 [self.hud hide];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    [self.hud hide];
//
//                });
                
            } failure:^(MQError *error) {
                
                [self.hud hudUpdataTitile:@"切换电磁炉失败" hideTime:1.2];
                
            }];
            
         
            
            
            
        }
        
       
    }
    
    [self removeDeviceView];
    
    
    
}



@end

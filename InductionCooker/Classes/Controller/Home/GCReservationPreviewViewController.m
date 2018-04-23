//
//  GCReservationPreviewViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationPreviewViewController.h"

#import "MQBarButtonItemTool.h"
#import "MQSaveLoadTool.h"
#import "DateTool.h"
#import "NSDate+TimeCategory.h"
#import "MQHudTool.h"
#import "GCAgreementHelper.h"

#define KTypePrefixString           @"模式: "
#define KDatePrefixString           @"开机时间: "
#define KTimePrefixString           @"工作时长: "
#define KPowerPrefixString          @"火力: "

#define KGetReservationDataTag      @"KGetReservationDataTag"
#define KUnReservationDataTag       @"KUnReservationDataTag"



@interface GCReservationPreviewViewController ()

@property (nonatomic,strong) NSArray *modenNameArr;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelTop;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipPowerLabel;

@property (nonatomic,strong) GCModen *moden;

@property (nonatomic,copy) NSString *preferenceKey;

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,assign) int resendCount;

@property (nonatomic,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIView *discoverView;
@end

@implementation GCReservationPreviewViewController

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}

- (NSArray *)modenNameArr
{
    
    if(_modenNameArr==nil)
    {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ModenName" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _modenNameArr=arr;
    }
    
    return _modenNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // [self test];
    
    [self getData];
    
    [self createUI];
    
    
    [self addObserver];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   [self checkPowerOffTimeWithWork:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [self checkPowerOffTimeWithWork:NO];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
    self.resendCount=0;
    
    NSString *modenFileName=self.reservationModen.deviceId==0?@"leftdevice":@"rightdevice";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:modenFileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    for (int i=0;i<[dic[@"value"] count];i++) {
        
        NSDictionary *dict = dic[@"value"][i];
        
        GCModen *model=[GCModen createModelWithDict:dict];
        
        if (model.modenId==self.reservationModen.modenId) {
            
            self.moden=model;
            
            break;
        }
    }

    
}


- (void) createUI{
    
    self.title=@"预约";
    

    if(self.reservationModen)
    {
        int minuteCount=self.reservationModen.time;

        [self setLabelWithReservationDate:self.reservationModen.date minute:minuteCount modenName:self.moden.type stall:self.reservationModen.stall];
        
    }else{
        
        [self.hud addNormHudWithSupView:self.view title:@"正在获取预约数据..."];
        
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationInfoBytesWithDeviceId:self.deviceId] timeout:-1 tag:7];
        
        [self performSelector:@selector(getReservationData) withObject:KGetReservationDataTag afterDelay:3];
    }
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self imageName:@"title_back"];


}


- (void) addObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiReservation object:nil];
    
}


- (void) checkPowerOffTimeWithWork:(BOOL) work
{
    if (work) {
        
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
        
        _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }else{
        if (_timer) {
            [_timer invalidate];
            _timer=nil;
        }
        
    }
}



- (void) timerAction
{
    GCLog(@"定时查询预约信息");
    
     [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationInfoBytesWithDeviceId:self.deviceId] timeout:-1 tag:7];
}

- (void) getReservationData
{
    if (self.resendCount==5) {
        
        [self reciveSuccess];
        
        [self.hud hudUpdataTitile:@"获取预约数据超时" hideTime:KHudTipTime success:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        return;
        
    }
    
    self.resendCount++;
    
     [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationInfoBytesWithDeviceId:self.deviceId] timeout:-1 tag:7];
    [self performSelector:@selector(getReservationData) withObject:KGetReservationDataTag afterDelay:3];
    
    
}


- (void)reciveSuccess
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.resendCount=0;
   
}



- (void) unReservationData
{
    if (self.resendCount==5) {
        
        [self reciveSuccess];
        
    }
    
    self.resendCount++;
    
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:self.deviceId setting:NO moden:self.reservationModen.modenId bootTime:self.reservationModen.date  appointment:self.reservationModen.time stall:-1] timeout:-1 tag:0];

    [self performSelector:@selector(unReservationData) withObject:KUnReservationDataTag afterDelay:3];

    
}




- (void) setLabelWithReservationDate:(double)timeInterval minute:(int)minuteCount modenName:(NSString *)name stall:(int)stall
{

   if(!self.discoverView.hidden)
    {
        self.discoverView.hidden=YES;
    }
    
    
//    NSString *typeStr=[NSString stringWithFormat:@"%@%@",KTypePrefixString,name];
//
//
//
//    NSMutableAttributedString *attributedTypeStr = [[NSMutableAttributedString alloc]initWithString:typeStr];
//
//    [attributedTypeStr addAttribute:NSForegroundColorAttributeName
//
//                              value:UIColorFromRGB(KMainColor)
//
//                              range:NSMakeRange(KTypePrefixString.length, typeStr.length-KTypePrefixString.length)];
    
//    self.typeLabel.attributedText=attributedTypeStr;
  
    
    self.typeLabel.text=name;

    self.moden.reservationWorkTime=60;
    
    double decimal=timeInterval-(int)timeInterval;
    
    int hour=(int)timeInterval/60;
    int min=decimal>0?(int)timeInterval%60+1:(int)timeInterval%60;
    
    if(min==60)
    {
        hour++;
        min=0;
    }
    
    NSString *time=[NSString stringWithFormat:@"%d小时%d分钟后",hour,min];
    
    time=timeInterval<=0?@"预约已过期":time;
    
   // NSString *dateStr=[NSString stringWithFormat:@"%@%@",KDatePrefixString,time];
    
    self.dateLabel.text=time;
    
    
//    NSMutableAttributedString *attributedDateStr = [[NSMutableAttributedString alloc]initWithString:dateStr];
//
//    [attributedDateStr addAttribute:NSForegroundColorAttributeName
//
//                              value:UIColorFromRGB(KMainColor)
//
//                              range:NSMakeRange(KDatePrefixString.length, dateStr.length-KDatePrefixString.length)];
//
//    self.dateLabel.attributedText=attributedDateStr;

        
    
    
    
    NSString *minute;
    
    if (self.moden.aotuWork&&self.moden.modenId%100!=7) {
        
        minute=@"自动";
        
    }else{
        int hour=(int)minuteCount/60;
        int min=(int)minuteCount%60;
        minute=[NSString stringWithFormat:@"%d小时%d分钟",hour,min];
 
    }
   // NSString *timeStr=[NSString stringWithFormat:@"%@%@",KTimePrefixString,minute];

    self.timeLabel.text=minute;
    
//    NSMutableAttributedString *attributedTimeStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
//
//    [attributedTimeStr addAttribute:NSForegroundColorAttributeName
//
//                              value:UIColorFromRGB(KMainColor)
//
//                              range:NSMakeRange(KTimePrefixString.length, timeStr.length-KTimePrefixString.length)];
//
//    self.timeLabel.attributedText=attributedTimeStr;
  

    NSString *powerStr=[GCAgreementHelper getPowerWhithDeivce:self.deviceId moden:self.moden.modenId stalls:stall];
    
    //powerStr=[powerStr isEqualToString:@"Auto"]?@"自动":powerStr;
    
    if(self.moden.aotuWork)
    {
        powerStr=@"自动";
    }
    
//    powerStr=[NSString stringWithFormat:@"%@%@",KPowerPrefixString,powerStr];
    
//    NSMutableAttributedString *attributedPowerStr = [[NSMutableAttributedString alloc]initWithString:powerStr];
//
//    [attributedPowerStr addAttribute:NSForegroundColorAttributeName
//
//                              value:UIColorFromRGB(KMainColor)
//
//                              range:NSMakeRange(KPowerPrefixString.length, powerStr.length-KPowerPrefixString.length)];
//
//    self.powerLabel.attributedText=attributedPowerStr;

    self.powerLabel.text=powerStr;
    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
}

- (void) leftButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (IBAction)unreservationButtonClick:(UIButton *)sender {
    
  
    [self.hud addNormHudWithSupView:self.view title:@"正在取消预约时间"];
    
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:self.deviceId setting:NO moden:self.reservationModen.modenId bootTime:self.reservationModen.date appointment:self.reservationModen.time stall:-1] timeout:-1 tag:0];
    
    [self performSelector:@selector(unReservationData) withObject:KUnReservationDataTag afterDelay:3];

    
}

- (void) test
{
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:self.deviceId setting:NO moden:self.reservationModen.modenId bootTime:self.reservationModen.date appointment:self.reservationModen.time stall:-1] timeout:-1 tag:0];
    
    [self performSelector:@selector(unReservationData) withObject:KUnReservationDataTag afterDelay:3];

}



#pragma mark -接收通知
- (void) receiveNoti:(NSNotification* )noti
{
    NSDictionary *dict=[noti userInfo][@"data"];
    
    
    int code=[dict[@"code"] intValue];
    
    int deviceId=0;
    
    if (dict[@"deviceId"]) {
        deviceId=[dict[@"deviceId"] intValue];
    }else{
        return;
    }
    
    if (self.deviceId!=deviceId) {
        return;
    }

    switch (code) {
        case 6:
        {
            BOOL success=[dict[@"success"] boolValue];
            BOOL setting=[dict[@"setting"] boolValue];
            
            if (success==NO||setting==YES) {
                [self.hud hudUpdataTitile:@"取消预约失败" hideTime:KHudTipTime];
                return;
            }
            
            if (self.deviceId==0) {
                [GCUser getInstance].device.leftDevice.hasReservation=0;
            }else{
                [GCUser getInstance].device.rightDevice.hasReservation=0;
            }
            
            //[NSObject cancelPreviousPerformRequestsWithTarget:self];
            
            [self reciveSuccess];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }
            break;
            
        case 7:
        {
       
            GCLog(@"查询预约: %@",dict);

            //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getReservationData) object:KGetReservationDataTag];
            
            [self reciveSuccess];
            
            [self.hud hide];
            
            NSString *dataStr=dict[@"bootTime"];
            
            double date=[dataStr integerValue]/60000.0;
            int time=[dict[@"appointment"] intValue]/60000;
            int moden=[dict[@"moden"] intValue];
            int stall=[dict[@"stall"] intValue];
            
            self.reservationModen=[[GCReservationModen alloc] init];
            self.reservationModen.deviceId=self.deviceId;
            self.reservationModen.modenId=moden;
            self.reservationModen.date=date;
            self.reservationModen.time=time;

            [self getData];
            
            [self setLabelWithReservationDate:date minute:self.reservationModen.time modenName:self.modenNameArr[moden] stall:stall];
            
            if(date<0.10)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
            break;
     
        default:
            
            
            
            break;
    }
    
   

    
    
    
      
    
}




















@end

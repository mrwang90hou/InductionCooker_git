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

#define KTypePrefixString           @"预约模式: "
#define KDatePrefixString           @"开机时间: "
#define KTimePrefixString           @"工作时长: "
#define KPowerPrefixString          @"火力: "

#define KGetReservationDataTag      @"KGetReservationDataTag"
#define KUnReservationDataTag       @"KUnReservationDataTag"



@interface GCReservationPreviewViewController ()

@property (nonatomic,strong) NSArray *modenNameArr;
@property (nonatomic,strong) NSArray *modenNameArrRight;
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
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ModenNameLeft" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _modenNameArr=arr;
    }
    
    return _modenNameArr;
}

- (NSArray *)modenNameArrRight
{
    
    if(_modenNameArrRight==nil)
    {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ModenNameRight" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _modenNameArrRight=arr;
    }
    
    return _modenNameArrRight;
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
    
//    NSString *modenFileName=self.reservationModen.deviceId==0?@"leftdevice":@"rightdevice";
    NSString *modenFileName=self.deviceId==0?@"leftdevice":@"rightdevice";
    
//    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"查看【预约】按钮对应的火炉状态 \n%@",modenFileName]];
    NSString *path = [[NSBundle mainBundle] pathForResource:modenFileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    for (int i=0;i<[dic[@"value"] count];i++) {
        
        NSDictionary *dict = dic[@"value"][i];
        
        GCModen *model=[GCModen createModelWithDict:dict];
        
        if (model.modenId==self.reservationModen.modenId) {
//            NSLog(@"model.type = %@   self.reservationModen.modenId = %d",model.type,self.reservationModen.modenId);
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
//        [SVProgressHUD showWithStatus:@"正在获取预约数据..."];
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
//            [SVProgressHUD dismiss];
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
    
//    if (self.moden.aotuWork&&self.moden.modenId%100!=7) {
//    [SVProgressHUD showSuccessWithStatus:self.moden.type];
//    if (![self.moden.type isEqualToString:@"保温"]) {
    if (![name isEqualToString:@"保温"]) {
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
    
//    if(self.moden.aotuWork)
//    {
//        powerStr=@"自动";
//    }
    powerStr=@"自动";

    self.powerLabel.text=powerStr;
    
    
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
- (void) receiveNoti0:(NSNotification* )noti
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
            
            if (self.deviceId==1) {
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

- (void) receiveNoti:(NSNotification* )noti
{
    NSDictionary *dict=[noti userInfo];
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
   
    int code=[dict[@"code"] intValue];
    int deviceId = abs(isLeft-1);
    
//    if (dict[@"deviceId"]) {
//        deviceId=[dict[@"deviceId"] intValue];
//    }else{
//        return;
//    }
    //如果火炉不一致
    if (self.deviceId!=deviceId) {
        return;
    }
    GCLog(@"查询预约: %@",dict);
    
    [self reciveSuccess];
    
    [self.hud hide];
    
    
    NSData *jsonData1 = [totalData[@"LYuYue"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err1;
    NSDictionary *leftYuYueDic = [NSJSONSerialization JSONObjectWithData:jsonData1
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err1];
    
    NSData *jsonData2 = [totalData[@"RYuYue"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err2;
    NSDictionary *rightYuYueDic = [NSJSONSerialization JSONObjectWithData:jsonData2
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err2];
//    NSDictionary *leftYuYueDic = totalData[@"LYuYue"];
//    NSDictionary *rightYuYueDic = totalData[@"RYuYue"];
    NSDictionary *yuYueDic = [NSDictionary new];
    if (!self.deviceId) {
        yuYueDic = leftYuYueDic;
    }else{
        yuYueDic = rightYuYueDic;
    }
    //取得记录的时间戳
    long long recordTime = [yuYueDic[@"time"] longLongValue];
    int startUpTimeHour = [yuYueDic[@"hour"] intValue];
    int startUpTimeMin = [yuYueDic[@"min"] intValue];
    int workTimeHour = [yuYueDic[@"wHour"] intValue];;
    int workTimeMin = [yuYueDic[@"wMin"] intValue];;
    
    
//    [SVProgressHUD showWithStatus:yuYueDic];
//    NSLog(@"😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊%@",yuYueDic);
    //获取当前的时间戳，来自1970年毫秒数
        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
        long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
        NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];

    NSTimeInterval value = theTime - recordTime;
    int second = (int)value /1000%60;//秒
    int minute = (int)value /1000/60%60;
    int house = (int)value /1000/ (24 *3600)%3600;
    int day = (int)value /1000/ (24 *3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house !=0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day==0 && house==0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
//    [SVProgressHUD showWithStatus:str];
//    NSLog(@"second = %d",second);
//    NSLog(@"minute = %d",minute);
//    NSLog(@"house = %d",house);
//    NSLog(@"day = %d",day);
//
    
    int time = workTimeHour*60+workTimeMin;
    
    
    double date = (startUpTimeHour - house)*60 + (startUpTimeMin - minute);

//    NSLog(@"data = %lf",date);
//    NSLog(@"time = %d",time);
    
//    NSString *dataStr=dict[@"bootTime"];
//    double date=[dataStr integerValue]/60000.0;
//    int time=[dict[@"appointment"] intValue]/60000;
    
    
    //    int moden=[dict[@"moden"] intValue];
    //    int stall=[dict[@"stall"] intValue];
    int moden = [yuYueDic[@"mode"] intValue];
    int stall = curPower;
    
    self.reservationModen=[[GCReservationModen alloc] init];
    self.reservationModen.deviceId=self.deviceId;
    self.reservationModen.modenId=moden;
    self.reservationModen.date=date;
    self.reservationModen.time=time;
    
    [self getData];
    
    if ([yuYueDic[@"left"] intValue] == 1) {
        
        [self setLabelWithReservationDate:date minute:self.reservationModen.time modenName:self.modenNameArr[moden] stall:stall];
    }else{
        
        [self setLabelWithReservationDate:date minute:self.reservationModen.time modenName:self.modenNameArrRight[moden] stall:stall];
    }
    
    NSLog(@"moden = %d",moden);
    
    NSLog(@"stall = %d",stall);
    
    
    if(date<0.10)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    
    
    
    
//
//    switch (code) {
//        case 6:
//        {
//            BOOL success=[dict[@"success"] boolValue];
//            BOOL setting=[dict[@"setting"] boolValue];
//
//            if (success==NO||setting==YES) {
//                [self.hud hudUpdataTitile:@"取消预约失败" hideTime:KHudTipTime];
//                return;
//            }
//
//            if (self.deviceId==1) {
//                [GCUser getInstance].device.leftDevice.hasReservation=0;
//            }else{
//                [GCUser getInstance].device.rightDevice.hasReservation=0;
//            }
//
//            //[NSObject cancelPreviousPerformRequestsWithTarget:self];
//
//            [self reciveSuccess];
//
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
//
//
//        }
//            break;
//
//        case 7:
//        {
//
//            GCLog(@"查询预约: %@",dict);
//
//            //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getReservationData) object:KGetReservationDataTag];
//
//            [self reciveSuccess];
//
//            [self.hud hide];
//
//            NSString *dataStr=dict[@"bootTime"];
//
//            double date=[dataStr integerValue]/60000.0;
//            int time=[dict[@"appointment"] intValue]/60000;
//            int moden=[dict[@"moden"] intValue];
//            int stall=[dict[@"stall"] intValue];
//
//            self.reservationModen=[[GCReservationModen alloc] init];
//            self.reservationModen.deviceId=self.deviceId;
//            self.reservationModen.modenId=moden;
//            self.reservationModen.date=date;
//            self.reservationModen.time=time;
//
//            [self getData];
//
//            [self setLabelWithReservationDate:date minute:self.reservationModen.time modenName:self.modenNameArr[moden] stall:stall];
//
//            if(date<0.10)
//            {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//
//        }
//            break;
//
//        default:
//
//
//
//            break;
//    }
}




















@end

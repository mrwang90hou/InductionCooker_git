//
//  GCAdjustViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCAdjustViewController.h"

#import "SFCircleGradientView.h"
#import "CircularProgressBar.h"
#import "GCReservationTimeViewController.h"
#import "GCTabBarController.h"
#import "GCHomeViewController.h"
#import "UIView+NTES.h"
#import "GCSokectDataDeal.h"
#import "MQHudTool.h"

@interface GCAdjustViewController ()
{
    CircularProgressBar *bar;
    UISlider *sw;
}


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet SFCircleGradientView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIView *powerView;

@property (nonatomic,assign) int progress;

@property (nonatomic, strong) NSDictionary *temperatureDict;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *temperLabel;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int countdown;

@property (nonatomic,assign) int maxTime;

@property (nonatomic,assign) CGPoint powerLabelOldCenter;

@end

@implementation GCAdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.powerLabelOldCenter=self.powerLabel.center;
    [self getData];
    
    [self createUI];
    
   // [self addObserver];
    
  
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    

    
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotiTiming object:nil];
    
    
}

- (void)dealloc
{
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -页面逻辑方法
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

- (void) showAdjustView:(BOOL)show
{
    self.view.hidden=!show;
    
    if (show) {
        
        [self addObserver];
        if (!self.moden.aotuWork||self.moden.modenId%100==7) {
            [self checkPowerOffTimeWithWork:YES];
            [self sendWorkData];
        }else{
            self.timeLabel.text=@"Auto";
        }
        
    }else{
    
        self.maxTime=0;
        self.countdown=0;
        [self setWorkTimeState];
        [self checkPowerOffTimeWithWork:NO];
        [self removeObserver];
    }
    
}
- (void) addObserver
{
    GCLog(@"GCAdjustViewController addObserver");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiDevoceStallsChange object:nil];
//    工作时间通知名称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWorkTime:) name:KNotiWorkTime object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTimingNoti:) name:KNotiTiming object:nil];
    
}

- (void) removeObserver
{
    GCLog(@"GCAdjustViewController removeObserver");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void) getData{

    self.maxTime=120;
    self.countdown=self.maxTime;
    
    self.progress=0;

    
    NSArray *leftvalues=@[@"80℃",@"120℃",@"140℃",@"160℃",@"180℃",@"200℃",@"220℃",@"240℃",@"260℃",@"280℃",@"290℃",@"300℃"];
    
    NSArray *leftkeys=@[@"100",@"200",@"400",@"600",@"800",@"1000",@"1200",@"1400",@"1600",@"1800",@"2000",@"2200"];

    NSArray *rightvalues=@[@"80℃",@"120℃",@"140℃",@"160℃",@"180℃",@"200℃",@"220℃",@"240℃",@"260℃",@"280℃",@"290℃",@"300℃"];
    
    NSArray *rightkeys=@[@"100",@"200",@"400",@"600",@"1000",@"1200",@"1400",@"1600",@"1800",@"2000",@"2300",@"2600"];

    NSArray *values;
    NSArray *keys;
    
    if (self.moden.modenId>=100) {
        
         values=rightvalues;
        
         keys=rightkeys;

    }else{
        
        values=leftvalues;
        
        keys=leftkeys;

    }
    
    
    NSMutableDictionary *mDict=[NSMutableDictionary dictionary];
    
    for (int i=0; i<values.count; i++) {
        
        NSString *key=keys[i];
        
        NSString *value=values[i];
        
        [mDict setValue:value forKey:key];
    }
    
    self.temperatureDict=mDict;
    
}

- (void) sendWorkData
{
  
//    int modenId=self.deviceId==1?self.moden.modenId:self.moden.modenId%100;
//    int modenId = [self getImportModenId:self.deviceId modenId:self.moden.modenId];
    
//    NSData *data = [GCSokectDataDeal getWorkTimeWithDeviceId:self.deviceId moden:modenId];
//    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"dic = %@",dic);
//    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"self.deviceId = %ddic = %@",self.deviceId,dic]];
    
//    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getWorkTimeWithDeviceId:abs(1-self.deviceId) moden:modenId] timeout:-1 tag:5];
//    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getWorkTimeWithDeviceId:self.deviceId moden:modenId] timeout:-1 tag:5];
}


- (int)getImportModenId:(int)isLeftDevice modenId:(int)modenId0{
    int modelId;
    if (isLeftDevice == 1) {
        switch (modenId0) {
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
    }
    else{
        //        int moden=button.moden.modenId%100;
        //改变了 button 的序列位置
        switch (modenId0) {
            case 110:
                modelId = 0;
                break;
            case 111:
                modelId = 1;
                break;
            case 112:
                modelId = 2;
                break;
            case 108:
                modelId = 3;
                break;
            case 109:
                modelId = 4;
                break;
            case 107:
                modelId = 5;
                break;
        }
    }
    return modelId;
    
}





- (void) createUI{
    
    
    self.nameLabel.text=self.moden.type;

    if (!self.moden.showTemperature||self.moden.aotuWork) {
        
       [self showTemperatureView:NO];
        self.powerLabel.text=self.moden.aotuWork?@"Auto":@"";
        
    }else{
        [self showTemperatureView:YES];
    }

    
   
    if (bar) {
        [bar removeFromSuperview];
    }

    bar = [[CircularProgressBar alloc]initWithFrame:self.powerView.bounds];
    
    bar.bgCircularColor=UIColorFromRGBA(0xebeef3, 0.5);
    
    bar.greyProgressColor=UIColorFromRGB(0xcccccc);
    
    bar.backgroundColor=[UIColor clearColor];
    
   
    NSMutableDictionary *mDict=[NSMutableDictionary dictionary];

    for (int i=0 ;i<self.moden.stalls.count;i++) {
        
        NSNumber *a=self.moden.stalls[i];
        NSString *str=[NSString stringWithFormat:@"%d",[a intValue]/100];
        
        if (self.moden.currentStall==-1) {
            
            if (self.moden.defaultStalls.count>0) {
                
                NSDictionary *defaultStall = [self.moden.defaultStalls firstObject];
                
                if ([[defaultStall allValues][0] intValue]==[a intValue]) {
                    
                    self.progress=i;
                    self.moden.currentStall=i;
                }
                
                
            }

            
        }else{
            self.progress=self.moden.currentStall;
        }
        
        
        
        [mDict setObject:str forKey:str];
        
    }

    bar.showCircular=mDict;
    
    bar.count=26;
    
    [bar strokeChart];
    [self.powerView addSubview:bar];

    
    [self setValueForUI];


}


- (void) setValueForUI
{
    
    
    if (self.moden.stalls.count>0) {
        
        bar.progress=[self.moden.stalls[self.progress] intValue]/2600.0;
        
        [self updataTemperatureAndPowerView];
    }

    
}



- (void) updateViewWithModen:(GCModen *)moden
{
    
    self.moden=moden;
    
    [self getData];
    
    [self createUI];
}

- (void) showTemperatureView:(BOOL) show
{
    self.lineView.hidden=!show;
    self.temperLabel.hidden=!show;
    
    if (show) {
        self.powerLabel.center=self.powerLabelOldCenter;
    }else{
        self.powerLabel.center=CGPointMake(self.powerView.width/2, self.powerView.height/2);
    }
    //self.powerLabel.center=show?self.powerLabelOldCenter:CGPointMake(self.powerView.width/2, self.powerView.height/2);
}

- (void) setWorkTimeState
{
    self.progressView.progress=(float)(self.maxTime-self.countdown)/self.maxTime;
    
    
    int minute =self.countdown/(60*1000)%60+1;
    
    int hour=self.countdown/(60*60*1000);
    
    if (minute==60) {
        hour++;
        minute=0;
    }
    
    NSString *minuteStr=minute>=10?[NSString stringWithFormat:@"%d",minute]:[NSString stringWithFormat:@"0%d",minute];
    
    NSString *hourStr=hour>=10?[NSString stringWithFormat:@"%d",hour]:[NSString stringWithFormat:@"0%d",hour];
    
    self.timeLabel.text=[NSString stringWithFormat:@"%@:%@",hourStr,minuteStr];
}


- (void) updataTemperatureAndPowerView{
    
    self.powerLabel.text=[NSString stringWithFormat:@"%@W",self.moden.stalls[self.moden.currentStall]];
    
    NSString *a=[NSString stringWithFormat:@"%@",self.moden.stalls[self.moden.currentStall]];
    
    NSString *str=self.temperatureDict[a];
    
    self.temperLabel.text=str;
    
    
}


- (UIViewController *) getSupViewController{
    
    GCTabBarController *tabbarVc=(GCTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav=tabbarVc.childViewControllers[0];
    

    return  nav.childViewControllers[0];
    
}

- (void) timerAction
{

    [self sendWorkData];
}

#pragma mark -交互方法
- (IBAction)reservationButtonClick:(id)sender {
    
    if (self.moden.aotuWork&&self.moden.modenId%100!=7) {
        return;
    }
    
     GCReservationTimeViewController *vc=[[GCReservationTimeViewController alloc] initWithNibName:@"GCReservationTimeViewController" bundle:nil];
   // [self.parentViewController.navigationController pushViewController:vc animated:YES];
    vc.deviceId=self.deviceId;
    
    vc.title=@"定时时间";
    
    [[self getSupViewController].navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)unReservationButtonClick:(id)sender {
    
    if (self.moden.aotuWork&&self.moden.modenId%100!=7) {
        return;
    }
    
//    int modenId=self.moden.modenId<100?self.moden.modenId:(self.moden.modenId%100);
    int modenId = [self getImportModenId:self.deviceId modenId:self.moden.modenId];
     [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getTimingBytesWithDeviceId:self.deviceId setting:NO moden:modenId timing:-1] timeout:-1 tag:0];
    
}


- (IBAction)reduceButtonClick:(id)sender {
    
    if (self.progress==0||self.moden.stalls.count==0) {
        return;
    }
    

    
    self.progress--;
    
    int deviceId=self.moden.modenId>=100?1:0;
    
    //[self updateUI];
    
    
    [[RHSocketConnection getInstance] writeData: [GCSokectDataDeal getBytesWithDeviceId:deviceId Stalls:self.progress]
 timeout:-1 tag:-1];
  

}

- (IBAction)plusButtonClick:(id)sender {
    
    if (self.progress==self.moden.stalls.count-1||self.moden.stalls.count==0) {
        return;
    }
    
    
    self.progress++;
    
    int deviceId=self.moden.modenId>=100?1:0;
    
   // [self updateUI];
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getBytesWithDeviceId:deviceId Stalls:self.progress] timeout:-1 tag:-1];
    


}

- (IBAction)removeBUttonClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(removeButtonClickWithDeivceId:)]) {
        
        int deviceId=self.moden.modenId<100?0:1;
        
        [_delegate removeButtonClickWithDeivceId:deviceId];
    }
    
}


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
}


- (void) updateUI
{
   // bar.progress=[self.moden.stalls[self.progress] intValue]/2600.0;
    
    //)&&(!self.moden.aotuWork||self.moden.modenId%100==7)
    if (self.moden.currentStall<self.moden.stalls.count) {
        bar.progress=[self.moden.stalls[self.moden.currentStall] intValue]/2600.0;
        [self updataTemperatureAndPowerView];
    }
    
    
    

}

- (void) delaySynchronize
{
    
    self.progress=self.moden.currentStall;
   [self updateUI];
    
}

#pragma mark -档位变化通知
- (void) receiveNoti:(NSNotification *)noti
{
    
    NSDictionary *dict=[noti userInfo];
    

    int deviceId=[dict[@"deviceId"] intValue];
    int stalls=[dict[@"stalls"] intValue];
    int mod=[dict[@"moden"] intValue];

    int modId=mod+deviceId*100;
    
    if (modId==self.moden.modenId) {
        
        if (stalls<0||stalls>=self.moden.stalls.count) {
            
            return;
            
        }
        
        
      //  self.progress=stalls;
        
        self.moden.currentStall=stalls;
        
      
        [self updateUI];
       
        //延迟
        [NSObject cancelPreviousPerformRequestsWithTarget:self]; //这个是取消当前run loop 里面所有未执行的 延迟方法(Selector Sources)
        // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onClickOverlay:) object:nil];// @selector 和 object 都和 延迟一致 就是 指定取消 未执行的一条或者多条的延迟方法.
        
        [self performSelector:@selector(delaySynchronize) withObject:nil afterDelay:3];
        
    }else{
        
        GCModen *moden=self.deviceId==1?[GCUser getInstance].device.leftDevice.selModen:[GCUser getInstance].device.rightDevice.selModen;
        [self updateViewWithModen:moden];
        
    }
    
    
    
}


#pragma mark -获取工作时间通知

- (void) receiveWorkTime0:(NSNotification *)noti
{
    
    NSDictionary *dict=[noti userInfo][@"data"];
    
    GCLog(@"👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻关机倒计时:  %@👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻",dict);
    int deviceId=0;
    int moden=0;
    double time=0;
    int maxtime=0;
    // NSString *s=dict[@"deviceId"];
    @try {

        deviceId=[dict[@"deviceId"] intValue];
        moden=[dict[@"moden"] intValue];
        time=[dict[@"time"] doubleValue];
        maxtime=[dict[@"stoptime"] intValue];
        
    } @catch (NSException *exception) {
        return;
    }
    
    int modenId=self.deviceId==1?self.moden.modenId:self.moden.modenId%100;
    
    if (self.deviceId!=deviceId||modenId!=moden) {
        return;
    }
    
    self.maxTime=maxtime;
    
    self.countdown=self.maxTime-(int)time;
    
    [self setWorkTimeState];
    
}

//关机预约通知方法
- (void) receiveWorkTime:(NSNotification *)noti
{
    
   NSDictionary *dict=[noti userInfo];
    
    NSDictionary *totalData = dict;
    NSDictionary *cookerItemsData = totalData[@"cookerItem"];
    //    NSString *leftYuYue = totalData[@"LYuYue"];
    //    NSString *rightYuYue = totalData[@"RYuYue"];
//    NSString *curError = cookerItemsData[@"curError"];                  //错误码
        int curMode = [cookerItemsData[@"curMode"] intValue];               //当前模式      -1代表无任何模式
//        int curPower = [cookerItemsData[@"curPower"] intValue];             //当前档位、功率
        NSString *cursystemtime = cookerItemsData[@"cursystemtime"];        //模式切换时间
    //    int maxPower = [cookerItemsData[@"curPower"] intValue];             //最大功率、档位
        int maxcookTime = [cookerItemsData[@"maxcookTime"] intValue]/1000;   //最大烹饪时间 【单位：分钟】
    //    int showStallsMode = [cookerItemsData[@"showStallsMode"] intValue];  //当前显示模式类型       已开机： -1     显示定时和自动AUTO ：0    摄氏度：1       功率数：2       都是自动AUTO:3
    //    NSString *idName = totalData[@"id"];
    int isLeft = [totalData[@"isLeft"] intValue];
    //    int isOpen = [totalData[@"isOpen"] intValue];
    //    int isCancel = [totalData[@"isCancel"] intValue];
    //    NSString *target = totalData[@"target"];
    
    GCLog(@"👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻关机倒计时:  👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻");
    
    int deviceId=0;
    int moden=0;
    long long recordTime = 0;
    int maxtime=0;
    
   // NSString *s=dict[@"deviceId"];
    
    @try {
        
        deviceId = isLeft;
        moden = curMode;
        recordTime = [cursystemtime longLongValue];       //当前时间戳
        maxtime = maxcookTime;
        
//        GCLog(@"deviceId = %d\n moden = %d \n time = %llf \n maxtime = %d",deviceId,moden,time,maxtime);
        
//        moden=[dict[@"moden"] intValue];
        //记录存储当前关机耗时
//        time=[dict[@"time"] longLongValue];
        maxtime=[dict[@"stoptime"] intValue];
        
        //获取当前的时间戳，来自1970年毫秒数
        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
        long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
//        NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
        
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
        
        //记录存储当前关机耗时
        long time = house*60*60 + minute*60 + second;

        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"time = %d",time]];
//        curTime =
//
//        int time = workTimeHour*60+workTimeMin;
//        double date = (startUpTimeHour - house)*60 + (startUpTimeMin - minute);
//
//
//
        
        
        
        
//        deviceId=[dict[@"deviceId"] intValue];
//        moden=[dict[@"moden"] intValue];
//        time=[dict[@"time"] doubleValue];
//        maxtime=[dict[@"stoptime"] intValue];
        
    } @catch (NSException *exception) {
        return;
    }
    
    int modenId=self.deviceId==1?self.moden.modenId:self.moden.modenId%100;
    
    if (self.deviceId!=deviceId||modenId!=moden) {
        return;
    }
    
    self.maxTime=maxtime;
    
    self.countdown=self.maxTime-(int)time;
    
    [self setWorkTimeState];

}


- (void) receiveTimingNoti:(NSNotification* )noti
{
    
    
    NSDictionary *dict=[noti userInfo][@"data"];
    
//    [0]    (null)    @"deviceId" : @"0"
//    [1]    (null)    @"worktime" : (long)0
//    [2]    (null)    @"stoptime" : (long)0
//    [3]    (null)    @"code" : @"8"
//    [4]    (null)    @"success" : @"1"
//    [5]    (null)    @"error" : @"0"
//    [6]    (null)    @"setting" : @"1"
    
    int code=[dict[@"code"] intValue];
    
    int deviceId=0;
    
    BOOL setting=NO;
    
    @try {
         if (dict[@"deviceId"]) {
            deviceId=[dict[@"deviceId"] intValue];
        }else{
            return;
        }
        
        setting=[dict[@"setting"] boolValue];
        
    } @catch (NSException *exception) {
        
        
        return;
    }
    
    
    if (self.deviceId!=deviceId) {
        return;
    }
    
    
    
    switch (code) {
       case 8:
        {
            
            if (!setting) {
                [[MQHudTool shareHudTool] addTipHudWithTitle:@"解除预约成功"];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}



@end

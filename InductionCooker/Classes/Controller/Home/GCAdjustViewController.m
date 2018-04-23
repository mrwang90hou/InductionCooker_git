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
  
    int modenId=self.deviceId==0?self.moden.modenId:self.moden.modenId%100;
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getWorkTimeWithDeviceId:self.deviceId moden:modenId] timeout:-1 tag:5];
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
    
    int modenId=self.moden.modenId<100?self.moden.modenId:(self.moden.modenId%100);
    
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
        
        GCModen *moden=self.deviceId==0?[GCUser getInstance].device.leftDevice.selModen:[GCUser getInstance].device.rightDevice.selModen;
        [self updateViewWithModen:moden];
        
    }
    
    
    
}


#pragma mark -获取工作时间通知
- (void) receiveWorkTime:(NSNotification *)noti
{
    
   NSDictionary *dict=[noti userInfo][@"data"];
    
   // GCLog(@"关机倒计时:  %@",dict);
    
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
    
    int modenId=self.deviceId==0?self.moden.modenId:self.moden.modenId%100;
    
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

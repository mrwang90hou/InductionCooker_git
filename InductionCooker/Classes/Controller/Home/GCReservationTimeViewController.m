//
//  GCReservationTimeViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationTimeViewController.h"

#import "UIView+NTES.h"
#import "GCReservationProgressView.h"
#import "Masonry.h"
#import "GCReservationPreviewViewController.h"

#import "RHSocketConnection.h"
#import "NSDate+TimeCategory.h"
#import "NSNumber+Category.h"
#import "GCReservationModen.h"
#import "MQHudTool.h"
#import "GCReservationStallViewController.h"


#define KTopViewScale  603/115
#define KDelay         1

@interface GCReservationTimeViewController () <UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;

@property (weak, nonatomic) IBOutlet UIPickerView *minutePickerView;

@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) NSMutableArray *minuteArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewScale;

@property (nonatomic,weak) GCReservationProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *unReservationBt;

@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,assign) BOOL isSetting;

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,assign) int resendCount;


@end

@implementation GCReservationTimeViewController

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


- (NSMutableArray *)timeArray
{
    if (_timeArray==nil) {
        _timeArray=[NSMutableArray array];
    }
    return _timeArray;
}

- (NSMutableArray *)minuteArray
{
    if (_minuteArray==nil) {
        _minuteArray=[NSMutableArray array];
    }
    
    return _minuteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [self getData];
    
    
    [self createUI];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
    
}




#pragma mark -页面逻辑方法
- (void) getData{
    
    self.resendCount=0;
    
    
    for(int k=0;k<50;k++)
    {
        for (int i=0; i<=12; i++) {

            [self.timeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        for (int j=0; j<60; j++) {
            
            if (j<10) {
                
                [self.minuteArray addObject:[NSString stringWithFormat:@"0%d",j]];
            }else
            {
                [self.minuteArray addObject:[NSString stringWithFormat:@"%d",j]];
            }
            
        }

    }
    
    
}


- (void) createUI{
    
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    [self.timePickerView selectRow:299 inComponent:0 animated:NO];
    [self.timePickerView selectRow:1501 inComponent:1 animated:NO];

    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    NSString *rightTitle=@"确定";
    
    
    
    if (self.moden) {
        
       rightTitle=@"完成";
        
        NSArray *tipArr=nil;
        
        int count=0;
        
      
        
        tipArr=@[@"1.选择模式",@"2.预约开机时间",@"3.设置定时"];
        count=3;

        if (self.moden.modenId%100!=7) {
            
            tipArr=@[@"1.选择模式",@"2.预约开机时间",@"3.设置定时",@"设置功率"];
            count=4;
            rightTitle=@"下一步";
        }
        
        
        GCReservationProgressView *progressView=[[GCReservationProgressView alloc] initWithCount:count tips:tipArr];
        
        [self.topView addSubview:progressView];
        self.progressView=progressView;
        
        self.progressView.progress=2;
        self.progressView.progress=3;
        
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.topView.mas_left).offset(0);
            make.right.mas_equalTo(self.topView.mas_right).offset(0);
            make.top.mas_equalTo(self.topView.mas_top);
            make.bottom.mas_equalTo(self.topView.mas_bottom);
            
        }];

        self.unReservationBt.hidden=NO;
        
        
    }else{
        
        self.topViewScale.constant=1000;
        self.unReservationBt.hidden=YES;
        
        
    }
    
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:rightTitle];
    
    
}

- (void) addObserver{
    
    if (self.moden) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiReservation object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiTiming object:nil];
    }
    
    
    
}


- (void) setReservation
{
    
    if (self.resendCount==5) {
        
        [self.hud hudUpdataTitile:@"预约开机设置超时,请重试!" hideTime:KDelay];
        
        [self reciveSuccess];
        
        return;
    }
    
    self.resendCount++;
    
    
   
    
    
    NSInteger row_0=[self.timePickerView selectedRowInComponent:0];
    //／然后是获取这个行中的值，就是数组中的值
    int value_0=[[self.timeArray objectAtIndex:row_0] intValue];
    
    NSInteger row_1=[self.timePickerView selectedRowInComponent:1];
    int value_1=[[self.minuteArray objectAtIndex:row_1] intValue];
    
    
    
    
    self.dict=[NSMutableDictionary dictionary];
    [_dict setObject:[NSNumber numberWithInt:self.deviceId] forKey:KPreferenceDeviceId];
    [_dict setObject:[NSNumber numberWithInt:self.moden.modenId] forKey:KPreferenceModen];
    [_dict setObject:[NSNumber numberWithInt:(value_0*60+value_1)] forKey:KPreferenceTime];
    if (self.date) {
        [_dict setObject:[NSNumber numberWithLong:self.date] forKey:KPreferenceDate];
    }
    [_dict setObject:[NSNumber numberWithLong:-1] forKey:KPreferenceStall];
    
    
//    int moden = self.deviceId==1?self.moden.modenId:self.moden.modenId%100;
    
    int moden = [self getImportModenId:self.deviceId modenId:self.moden.modenId];
    
    
    GCLog(@"🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚发出预约🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚🍚");
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:abs(self.deviceId-1) setting:YES moden:moden bootTime:self.date  appointment:(value_0*60+value_1) stall:-1] timeout:-1 tag:0];
    
  
    [self performSelector:@selector(setReservation) withObject:nil afterDelay:3];
    
    

}

- (void) setPowerOffTime
{
    
    if (self.resendCount==5) {
        
        [self.hud hudUpdataTitile:@"设置关机定时超时,请重试!" hideTime:KDelay];
        
        [self reciveSuccess];
        
        return;
    }
    
    self.resendCount++;
    

    
    
    GCModen *moden=self.deviceId==1?[GCUser getInstance].device.leftDevice.selModen:[GCUser getInstance].device.rightDevice.selModen;
    
    NSInteger row_0=[self.timePickerView selectedRowInComponent:0];
    //／然后是获取这个行中的值，就是数组中的值
    int value_0=[[self.timeArray objectAtIndex:row_0] intValue];
    
    NSInteger row_1=[self.timePickerView selectedRowInComponent:1];
    int value_1=[[self.minuteArray objectAtIndex:row_1] intValue];
    
    //    long time=(value_0*60+value_1)*60000;
    long time=(value_0*60+value_1);
    
    int modenId=moden.modenId<100?moden.modenId:(moden.modenId%100);
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getTimingBytesWithDeviceId:self.deviceId setting:YES moden:modenId timing:time] timeout:-1 tag:0];
    
    [self performSelector:@selector(setPowerOffTime) withObject:nil afterDelay:3];
    
}


- (void)reciveSuccess
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.resendCount=0;
    self.isSetting=NO;
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
   
    NSInteger row_0=[self.timePickerView selectedRowInComponent:0];
    //／然后是获取这个行中的值，就是数组中的值
    int value_0=[[self.timeArray objectAtIndex:row_0] intValue];
    
    NSInteger row_1=[self.timePickerView selectedRowInComponent:1];
    int value_1=[[self.minuteArray objectAtIndex:row_1] intValue];
    int time=value_0*60+value_1;
    
    if (self.moden) {
        
        
        if ((self.moden.modenId%100)==7) {
            
            if (self.isSetting) {
                return;
            }
            
            [self.hud addNormHudWithSupView:self.view title:@"正在设置开机预约"];
            [self setReservation];
            
            self.isSetting=YES;
        }else{
            
            GCReservationStallViewController *vc=[[GCReservationStallViewController alloc] initWithNibName:@"GCReservationStallViewController" bundle:nil];
            vc.deviceId=self.deviceId;
            vc.moden=self.moden;
            vc.date=self.date;
            vc.time=time;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
       

    }else{
        
     
        if (self.isSetting) {
            return;
        }
        
        [self.hud addNormHudWithSupView:self.view title:@"正在设置关机定时"];
        [self setPowerOffTime];
        
        self.isSetting=YES;
    }
    
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





- (void) leftButtonClick
{
     [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)unReservationBtuttonClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



#pragma mark - 数据源方法
// PickerView 2列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.timeArray.count;
        
    }else{
        
        return self.minuteArray.count;
        
    }
}

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        
        return self.timeArray[row];
        
    }else{
        
        return  self.minuteArray[row];
        
    }
}

//替换text居中
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UILabel *label = [[UILabel alloc] init];
   
   
    label.font=[UIFont boldSystemFontOfSize:20];
    
    int magrin=0;
    
    if (component == 0) {
         label.textAlignment = NSTextAlignmentRight;
        label.frame=CGRectMake(0.0f+magrin, 0.0f, [pickerView rowSizeForComponent:component].width/2-magrin, [pickerView rowSizeForComponent:component].height);
        label.text = self.timeArray[row];
        
    }else{
        
        label.textAlignment = NSTextAlignmentLeft;
        label.frame=CGRectMake(self.view.width/2, 0.0f, [pickerView rowSizeForComponent:component].width/2-magrin, [pickerView rowSizeForComponent:component].height);
        label.text = self.minuteArray[row];

    }

    
       return label;
}


// 选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
    
}

#pragma mark -接收通知
- (void) receiveNoti0:(NSNotification* )noti
{
    NSDictionary *dict=[noti userInfo][@"data"];

    int code=[dict[@"code"] intValue];
    
    int deviceId=0;
    
    BOOL success=NO;
    
    @try {
        
        //BOOL setting=[dict[@"setting"] boolValue];
        
        success=[dict[@"success"] boolValue];
        
        if (dict[@"deviceId"]) {
            deviceId=[dict[@"deviceId"] intValue];
        }else{
            return;
        }
        
        
    } @catch (NSException *exception) {
        
        
        return;
    }
    
    
    if (self.deviceId!=deviceId) {
        return;
    }
    

    
    switch (code) {
        case 6:
        {
            
            NSString *tip=@"";
            

            if (success) {
                
                
                tip=@"预约开机设置成功";
                
                if (self.deviceId==1) {
                    [GCUser getInstance].device.leftDevice.hasReservation=YES;
                }else{
                    [GCUser getInstance].device.rightDevice.hasReservation=YES;
                    
                }
                
                
                GCReservationPreviewViewController *vc=[[GCReservationPreviewViewController alloc] initWithNibName:@"GCReservationPreviewViewController" bundle:nil];
                
                vc.reservationModen=[GCReservationModen createModelWithDict:self.dict];
                
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                 tip=@"预约开机设置失败";
            }

            
            [self reciveSuccess];
            
            [self.hud hudUpdataTitile:tip hideTime:KDelay];
            
            
        }
            break;
            
        case 8:
        {
            
            [self.hud hudUpdataTitile:@"设置关机定时成功" hideTime:KDelay success:^{
                
                
                [self reciveSuccess];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
           // [NSObject cancelPreviousPerformRequestsWithTarget:self];
           
        }
            break;
            
        default:
            break;
    }
    
    
    
}


- (void) receiveNoti:(NSNotification* )noti
{
    
    NSDictionary *dict=[noti userInfo];
    
    if (self.deviceId != [dict[@"isLeft"] intValue]) {
        return;
    }
    NSString *tip=@"";
    BOOL b1 = self.deviceId == 1 && ![dict[@"LYuYue"] isEqualToString:@""];
    BOOL b2 = self.deviceId == 0 && ![dict[@"RYuYue"] isEqualToString:@""];
    
    if (b1||b2) {
        if (b1) {
            [GCUser getInstance].device.leftDevice.hasReservation=YES;
        }
        if (self.deviceId == 0 && ![dict[@"RYuYue"] isEqualToString:@""]) {
            [GCUser getInstance].device.rightDevice.hasReservation=YES;
        }
        
        tip=@"预约开机设置成功";
        GCReservationPreviewViewController *vc=[[GCReservationPreviewViewController alloc] initWithNibName:@"GCReservationPreviewViewController" bundle:nil];
        
        vc.reservationModen=[GCReservationModen createModelWithDict:self.dict];
        
        [self.navigationController pushViewController:vc animated:YES];
        [self reciveSuccess];
        [SVProgressHUD showSuccessWithStatus:tip];
    }
    else{
        
    }
    
    [self.hud hudUpdataTitile:tip hideTime:1];
}






@end

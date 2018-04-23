//
//  GCReservationStartViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationStartViewController.h"

#import "GCReservationProgressView.h"
#import "Masonry.h"
#import "MQBarButtonItemTool.h"
#import "GCReservationTimeViewController.h"
#import "DateTool.h"
#import "GCReservationPreviewViewController.h"
#import "MQHudTool.h"
#import "NSDate+TimeCategory.h"
#import "UIView+NTES.h"

@interface GCReservationStartViewController ()


@property (weak, nonatomic) IBOutlet UIView *topView;



@property (nonatomic, weak)  GCReservationProgressView *progressView;

@property (nonatomic,assign) int deviceId;

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,assign) int resendCount;

@property (nonatomic,assign) BOOL isSetting;

@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,assign) long date;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic,strong) NSMutableArray *timeArray;

@property (nonatomic,strong) NSMutableArray *minuteArray;

@end

@implementation GCReservationStartViewController

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
    
    [self getData];
    
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiReservation object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}


#pragma mark -页面逻辑方法
- (void) getData{
    
    self.deviceId=self.moden.modenId<100?0:1;
    
    for(int k=0;k<50;k++)
    {
        for (int i=0; i<=12; i++) {
            
            //[NSString stringWithFormat:@"%d",i];
            
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
    
   

    [self.pickView selectRow:299 inComponent:0 animated:NO];
    [self.pickView selectRow:1501 inComponent:1 animated:NO];

    
    NSArray *tipArr=@[@"1.选择模式",@"2.预约开机时间",@"3.设置定时"];
    
    int count=3;

    if (self.moden.aotuWork&&self.moden.modenId%100!=7) {
        
        tipArr=@[@"1.选择模式",@"2.预约开机时间"];
        count=2;
    }else if(!self.moden.aotuWork)
    {
        tipArr=@[@"1.选择模式",@"2.预约开机时间",@"3.设置定时",@"设置功率"];
        count=4;
    }
    

    GCReservationProgressView *progressView=[[GCReservationProgressView alloc] initWithCount:count tips:tipArr];

    [self.topView addSubview:progressView];
    self.progressView=progressView;

    self.progressView.progress=2;
 
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.topView.mas_left).offset(0);
        make.right.mas_equalTo(self.topView.mas_right).offset(0);
        make.top.mas_equalTo(self.topView.mas_top);
        make.bottom.mas_equalTo(self.topView.mas_bottom);
        
    }];


    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    NSString *rightStr=self.moden.aotuWork?@"完成":@"下一步";
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:rightStr];

}

- (void)reciveSuccess
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.resendCount=0;
    self.isSetting=NO;
}

- (void) setReservation
{
    
    if (self.resendCount>=5) {
        
        [self.hud hudUpdataTitile:@"预约开机设置超时,请重试!" hideTime:1];
        
        [self reciveSuccess];
        
        return;
    }
    
    self.resendCount++;
    
 
    
    
    int moden= self.deviceId==0?self.moden.modenId:self.moden.modenId%100;
    
    
    GCLog(@"发出预约");
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:self.deviceId setting:YES moden:moden bootTime:self.date appointment:-1 stall:-1] timeout:-1 tag:0];
  
    [self performSelector:@selector(setReservation) withObject:nil afterDelay:3];

    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    
    NSInteger row_0=[self.pickView selectedRowInComponent:0];
    //／然后是获取这个行中的值，就是数组中的值
    int value_0=[[self.timeArray objectAtIndex:row_0] intValue];
    
    NSInteger row_1=[self.pickView selectedRowInComponent:1];
    int value_1=[[self.minuteArray objectAtIndex:row_1] intValue];
    
    long time=value_0*60+value_1;
   
    self.date=time;
    
    
    if(self.moden.aotuWork&&(self.moden.modenId%100)!=7)
    {
        
        if (self.isSetting) {
            return;
        }

        [self.hud addNormHudWithSupView:self.view title:@"正在设置开机预约"];

        self.dict=[NSMutableDictionary dictionary];
        [_dict setObject:[NSNumber numberWithInt:self.deviceId] forKey:KPreferenceDeviceId];
        [_dict setObject:[NSNumber numberWithInt:self.moden.modenId] forKey:KPreferenceModen];
        [_dict setObject:[NSNumber numberWithInt:-1] forKey:KPreferenceTime];
        [_dict setObject:[NSNumber numberWithLong:time] forKey:KPreferenceDate];
        [_dict setObject:[NSNumber numberWithLong:-1] forKey:KPreferenceStall];
        
        [self setReservation];
         self.isSetting=YES;
        
        
        
    }else
    {
        GCReservationTimeViewController *vc=[[GCReservationTimeViewController alloc] initWithNibName:@"GCReservationTimeViewController" bundle:nil];
        vc.moden=self.moden;
        vc.deviceId=self.moden.modenId<100?0:1;

        vc.date=time;
        
        
        vc.title=@"设置定时";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
  
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -预约通知

- (void) receiveNoti:(NSNotification* )noti
{
    NSDictionary *dict=[noti userInfo][@"data"];
    
    int code=[dict[@"code"] intValue];
    
    int deviceId=0;
    
    BOOL success=NO;
    
    @try {
        

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
                
                if (self.deviceId==0) {
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
            
            [self.hud hudUpdataTitile:tip hideTime:1];
            
            
        }
            break;
    
            
        default:
            break;
    }
    
    
    
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


















@end

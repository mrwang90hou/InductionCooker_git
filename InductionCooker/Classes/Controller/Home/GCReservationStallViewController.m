//
//  GCReservationStallViewController.m
//  InductionCooker
//
//  Created by csl on 2017/9/29.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationStallViewController.h"

#import "MQBarButtonItemTool.h"
#import "Masonry.h"
#import "GCReservationProgressView.h"
#import "GCAgreementHelper.h"
#import "GCReservationPreviewViewController.h"

@interface GCReservationStallViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,weak) GCReservationProgressView *progressView;

@property (nonatomic,strong) NSMutableArray *dataSoucre;


@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,assign) BOOL isSetting;

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,assign) int resendCount;

@end

@implementation GCReservationStallViewController

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


- (NSMutableArray *)dataSoucre
{
    if (_dataSoucre==nil) {
        _dataSoucre=[NSMutableArray array];
    }
    return _dataSoucre;
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
    

    NSDictionary *dict= [GCAgreementHelper getStallsDictWith:self.deviceId moden:self.moden.modenId];
    
    for (int i=0;i<dict.allValues.count;i++) {
        
        NSString *str=dict[[NSString stringWithFormat:@"%d",i]];
        
        [self.dataSoucre addObject:[str stringByAppendingString:@"W"]];
        
    }
    
    
    
}


- (void) createUI{
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"完成"];
    
    
    NSArray *tipArr;
    
    int count=4;
    
    tipArr=@[@"1.选择模式",@"2.预约开机时间",@"3.设置定时",@"设置功率"];
    
    
    
    GCReservationProgressView *progressView=[[GCReservationProgressView alloc] initWithCount:count tips:tipArr];
    
    [self.topView addSubview:progressView];
    self.progressView=progressView;
    self.progressView.progress=2;
    self.progressView.progress=3;
    self.progressView.progress=4;
    
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.topView.mas_left).offset(0);
        make.right.mas_equalTo(self.topView.mas_right).offset(0);
        make.top.mas_equalTo(self.topView.mas_top);
        make.bottom.mas_equalTo(self.topView.mas_bottom);
        
    }];
    

    
    
}


- (void) setReservation
{
    
    if (self.resendCount>=5) {
        
        [self.hud hudUpdataTitile:@"预约开机设置超时,请重试!" hideTime:1];
        
        [self reciveSuccess];
        
        return;
    }
    
    self.resendCount++;
    
    
    
    
    int moden= self.deviceId==1?self.moden.modenId:self.moden.modenId%100;
    
    
    GCLog(@"发出预约");
    
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getReservationBytesWithDeviceId:self.deviceId setting:YES moden:moden bootTime:self.date appointment:self.time stall:(int)[self.pickView selectedRowInComponent:0]] timeout:-1 tag:0];
    
    [self performSelector:@selector(setReservation) withObject:nil afterDelay:3];
    
    
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
    if (self.isSetting) {
        return;
    }
    
    [self.hud addNormHudWithSupView:self.view title:@"正在设置开机预约"];
    
    self.dict=[NSMutableDictionary dictionary];
    [_dict setObject:[NSNumber numberWithInt:self.deviceId] forKey:KPreferenceDeviceId];
    [_dict setObject:[NSNumber numberWithInt:self.moden.modenId] forKey:KPreferenceModen];
    [_dict setObject:[NSNumber numberWithInt:self.time] forKey:KPreferenceTime];
    [_dict setObject:[NSNumber numberWithLong:self.date] forKey:KPreferenceDate];
    [_dict setObject:[NSNumber numberWithLong:[self.pickView selectedRowInComponent:0]] forKey:KPreferenceStall];
    
    [self setReservation];
    self.isSetting=YES;
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 数据源方法
// PickerView 2列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  self.dataSoucre.count;
}

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.dataSoucre[row];
        
   
}

//替换text居中
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UILabel *label = [[UILabel alloc] init];
    
    
 
    label.textAlignment = NSTextAlignmentCenter;
    label.frame=CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height);
    label.text = self.dataSoucre[row];
  
    
    return label;
}


// 选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
}

#pragma mark -接收通知
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
            
            [self.hud hudUpdataTitile:tip hideTime:1];
            
            
        }
        break;
        
        
        default:
        break;
    }
    
    
    
}












@end

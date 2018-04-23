//
//  GCPurviewVerifyCodeViewController.m
//  InductionCooker
//
//  Created by csl on 2017/9/29.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCPurviewVerifyCodeViewController.h"

#import "MQButtonCountDownTool.h"
#import "SIAlertView.h"
#import "GCHttpDataTool.h"
#import "MQHudTool.h"
#import "GCUser.h"

@interface GCPurviewVerifyCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (nonatomic,strong) MQHudTool *hud;

@end

@implementation GCPurviewVerifyCodeViewController

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
    
    
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MQButtonCountDownTool startTimeWithButton:self.codeButton];
    
}

#pragma mark -页面逻辑方法
- (void) getData{
    
  
    
}


- (void) createUI{
    
    self.title=@"权限转移";
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"返回"];
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"完成转移"];
}

#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    if(self.codeTextFeild.text.length==0)
    {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"请先填入验证码"];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  
                                  [alertView dismissAnimated:NO];
                              }];
        
        
        [alertView show];
        return;
    }
    
    //functype=tp&curruser=13763085121&transfer=13800138000&devCode=d0001&token=xxxxxx&vcode=112233
    
    [self.hud addNormHudWithSupView:self.view title:@"正在转移产品权限"];
    
    NSDictionary *dict=@{
                         @"functype":@"tp",
                         @"curruser":[GCUser getInstance].mobile,
                         @"transfer":self.phone,
                         @"devCode":self.device.deviceId,
                         @"token":[GCUser getInstance].token,
                         @"vcode":self.codeTextFeild.text
                         };
    
    [GCHttpDataTool deviceChangeUserWithDict:dict success:^(id responseObject) {
        
        [self.hud hide];
        
        //[GCUser getInstance].device.deviceId=nil;
        
        [[GCUser getInstance].deviceList removeObject:self.device];
        
        if ([GCUser getInstance].deviceList.count==0) {
            
            [GCUser getInstance].device=[[GCDevice alloc] init];
            [self chagneSuccess];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
            
        }else{
            
            
            if (self.device==[GCUser getInstance].device) {
                
                
                [self getSelectDev];
                
            }else{
                
                [self chagneSuccess];
                
            }
            
            
        }
        
    } failure:^(MQError *error) {
        
        [self.hud hudUpdataTitile:error.msg hideTime:1];
        
    }];
    
  
    
    
    
}



- (void) leftButtonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)getSmsCodeButtonClick:(id)sender {
    
    
      [MQButtonCountDownTool startTimeWithButton:sender];
    
    
}

- (void) chagneSuccess
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"权限转移成功!"];
    [alertView addButtonWithTitle:@"返回"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              
                              [alertView dismissAnimated:NO];
                            
                              
                              [self.navigationController popToRootViewControllerAnimated:YES];
                              
                          }];
    [alertView show];
}

- (void) getSelectDev
{
    [self.hud addNormHudWithSupView:self.view title:@"正在获取当前选中电磁炉..."];
    
    NSDictionary *selDevDict=@{
                               @"mobile":[GCUser getInstance].mobile,
                               @"token":[GCUser getInstance].token
                               };
    
    [GCHttpDataTool selectDeviceWithDict:selDevDict success:^(id responseObject) {
        
        
        NSArray *selDevs=responseObject[@"list"];
        
        for (GCDevice *dev in [GCUser getInstance].deviceList) {
            
            if ([dev.deviceId isEqualToString:selDevs[0]]) {
                [GCUser getInstance].device=dev;
                break;
            }
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
        [self chagneSuccess];
        
    } failure:^(MQError *error) {
        
        
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"获取当前选中电磁炉失败,请重试!"];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  
                                  [self getSelectDev];
                                  
                                  [alertView dismissAnimated:NO];
                                  
                              }];
        
        [alertView show];
        
        
    }];
}





















@end

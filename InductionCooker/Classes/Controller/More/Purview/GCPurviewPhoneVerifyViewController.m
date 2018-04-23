//
//  GCPurviewPhoneVerifyViewController.m
//  InductionCooker
//
//  Created by csl on 2017/9/28.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCPurviewPhoneVerifyViewController.h"

#import "MQBarButtonItemTool.h"
#import "GCPurviewVerifyCodeViewController.h"
#import "SIAlertView.h"
#import "GCHttpDataTool.h"
#import "GCUser.h"
#import "MQHudTool.h"

@interface GCPurviewPhoneVerifyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFeild;

@property (nonatomic,strong) MQHudTool *hud;

@end

@implementation GCPurviewPhoneVerifyViewController

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
    
    
    [self getData];
    
    
    
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
}


- (void) createUI{
    
    self.title=@"权限转移";
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"下一步"];
    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    if (self.phoneTextFeild.text.length==0) {
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"请输入对方的手机号码!"];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
          
                                  [alertView dismissAnimated:NO];
                                  
                              }];
        
        
        [alertView show];
        
        return;
    }
    
    
    [self.hud addNormHudWithSupView:self.view title:@"正在校验用户..."];
    
    //functype=pt&curruser=13763085121&transfer=13800138000&devCode=d0001&token=xxxxxx
    NSDictionary *dict=@{
                        @"functype":@"pt",
                        @"devcode":self.device.deviceId,
                        @"curruser":[GCUser getInstance].mobile,
                        @"transfer":self.phoneTextFeild.text,
                        @"token":[GCUser getInstance].token
                        };

    GCLog(@"传入参数 %@",dict);
    
    [GCHttpDataTool deviceChangeUserSmsCodeWithDict:dict success:^(id responseObject) {
        
       //functype=vc&mobile=13763085121
        NSDictionary *smsDict=@{
                                @"functype":@"vc",
                                @"mobile":self.phoneTextFeild.text
                                };
        [GCHttpDataTool getLoginSmsCodeWithDict:smsDict success:^(id responseObject) {
            
            [self.hud hide];
            
            GCPurviewVerifyCodeViewController *vc=[[GCPurviewVerifyCodeViewController alloc] initWithNibName:@"GCPurviewVerifyCodeViewController" bundle:nil];
            
            
            
            vc.phone=self.phoneTextFeild.text;
            
            vc.device=self.device;

            [self.navigationController pushViewController:vc animated:YES];
            
            
        } failure:^(MQError *error) {
            
            [self.hud hudUpdataTitile:error.msg hideTime:1];
            
        }];
        
        
        
    } failure:^(MQError *error) {
        
         [self.hud hide];
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:error.msg];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  
                                  [alertView dismissAnimated:NO];
                                  
                              }];
        
        
        [alertView show];
        
        
    }];
    
    
  
    
   
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end

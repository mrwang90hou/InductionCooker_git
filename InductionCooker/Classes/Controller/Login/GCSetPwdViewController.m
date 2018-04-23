//
//  GCSetPwdViewController.m
//  InductionCooker
//
//  Created by csl on 2017/7/19.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCSetPwdViewController.h"

#import "MQBarButtonItemTool.h"
#import "GCLoginViewController.h"

@interface GCSetPwdViewController ()


@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;

@property (weak, nonatomic) IBOutlet UITextField *again_tf;

@property (nonatomic,strong) MQHudTool *hud;


@end

@implementation GCSetPwdViewController

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


- (void) createUI{
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"完成"];
    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    if (self.pwd_tf.text.length==0||self.again_tf.text.length==0) {
        [self.hud addTipHudWithTitle:@"请填写密码并确认" timeInterval:KHudTitleShowShortTime];
        return;
        
    }
    if (![self.pwd_tf.text isEqualToString:self.again_tf.text]) {
        
        [self.hud addTipHudWithTitle:@"密码不一致" timeInterval:KHudTitleShowShortTime];
        return;
        
    }
    
    if (self.verifyPhoneState==VerifyPhoneStateRegist) {
        
        [self.hud addNormHudWithSupView:self.view title:@"正在注册..."];
        
    }else if (self.verifyPhoneState==VerifyPhoneStateFogetPwd)
    {
         [self.hud addNormHudWithSupView:self.view title:@"正在设置密码..."];
    }
    
    
    if (self.verifyPhoneState==VerifyPhoneStateFogetPwd) {
        
        //functype=rp&mobile=13763085121&vcode=1122&new=1234
        NSDictionary *dict=@{
                             @"functype":@"rp",
                             @"mobile":self.phoneNum,
                             @"vcode":self.smsCode,
                             @"new":self.pwd_tf.text
                             };
        
        [GCHttpDataTool forgetPwdWithDict:dict success:^(id responseObject) {
            
            [self.hud hide];
          // [self.navigationController popToRootViewControllerAnimated:YES];
            
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                
                if ([vc isKindOfClass:[GCLoginViewController class]] ) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    
                    break ;
                }
                
            }
            
           
            
            
        } failure:^(MQError *error) {
           
            [self.hud hudUpdataTitile:error.msg hideTime:KHudTitleShowShortTime];
            
            
        }];
        
        
        
    }else if (self.verifyPhoneState==VerifyPhoneStateRegist)
    {
     
        //functype=cu&mobile=13763085121&vcode=6000
        NSDictionary *dict=@{
                             @"functype":@"cu",
                             @"mobile":self.phoneNum,
                             @"vcode":self.smsCode,
                             @"pwd":self.pwd_tf.text
                             };
        
        [GCHttpDataTool registerWithDict:dict success:^(id responseObject) {
            
            [[GCUser getInstance] updateUserInfoWithdict:responseObject[@"userInfo"]];
            [MQSaveLoadTool preferenceSaveUserInfo:responseObject[@"userInfo"] whitKey:KPreferenceUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiLoginSuccess object:nil];
            
            [self.hud hide];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } failure:^(MQError *error) {
            
            
              [self.hud hudUpdataTitile:error.msg hideTime:KHudTitleShowShortTime];
            
            
            
        }];

        
    }
    
   
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

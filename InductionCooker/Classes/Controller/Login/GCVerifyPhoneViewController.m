//
//  GCVerifyPhoneViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/22.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCVerifyPhoneViewController.h"

#import "MQBarButtonItemTool.h"
#import "GCFillinSmsCodeViewController.h"
#import "MQHudTool.h"


@interface GCVerifyPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFeild;
@property (nonatomic,strong) MQHudTool *hud;


@end

@implementation GCVerifyPhoneViewController

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

#pragma mark -页面逻辑方法
- (void) getData{
    
    
}


- (void) createUI{
    
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"下一步"];
    

}

#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    if (self.phoneTextFeild.text.length==0 || !(self.phoneTextFeild.text.length==11)) {
        
        [self.hud addTipHudWithTitle:@"请填入正确的手机号码"];
//        [SVProgressHUD showErrorWithStatus:@"请填入手机号码"];
        return;
    }
    
    //注册前对手机号是否存在的验证方法
    //functype=cu&mobile=13763085121&vcode=6000
    NSDictionary *dict1=@{
                         @"functype":@"rg",
                         @"mobile":self.phoneTextFeild.text
                         };
    
    [GCHttpDataTool registerBeforeWithDict:dict1 success:^(id responseObject) {
        
//        [[GCUser getInstance] updateUserInfoWithdict:responseObject[@"userInfo"]];
//        [MQSaveLoadTool preferenceSaveUserInfo:responseObject[@"userInfo"] whitKey:KPreferenceUserInfo];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiLoginSuccess object:nil];
        [self.hud isShow];
        [self.hud addNormHudWithSupView:self.view title:@"用户已存在！"];
        [self.hud hudUpdataTitile:@"用户已存在！" hideTime:KHudTitleShowShortTime];
//        [self.hud hide];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    } failure:^(MQError *error) {
        
        [self.hud hudUpdataTitile:@"" hideTime:KHudTitleShowShortTime];
        [self.hud addNormHudWithSupView:self.view title:@"正在获取验证码..."];
        
        //functype=vc&mobile=13763085121
        
        NSDictionary *dict=@{
                             @"functype":@"vc",
                             @"mobile":self.phoneTextFeild.text
                             };
        
        [GCHttpDataTool getForgetSmsCodeWithDict:dict success:^(id responseObject) {
            
            [self.hud hide];
            
            GCFillinSmsCodeViewController *vc=[[GCFillinSmsCodeViewController alloc] initWithNibName:@"GCFillinSmsCodeViewController" bundle:nil];
            
            vc.title=@"填写验证码";
            
            vc.verifyPhoneState=self.verifyPhoneState;
            
            vc.phoneNum=self.phoneTextFeild.text;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(MQError *error) {
            
            [self.hud hudUpdataTitile:error.msg hideTime:1];
            
        }];
    }];
    
    
    
    
  
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


















@end

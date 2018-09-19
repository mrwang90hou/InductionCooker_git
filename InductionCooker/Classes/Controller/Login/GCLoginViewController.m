//
//  GCLoginViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/22.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCLoginViewController.h"

#import "CATransitionHelper.h"
#import "MQBarButtonItemTool.h"
#import "GCVerifyPhoneViewController.h"
#import "MQHudTool.h"
#import "MQButtonCountDownTool.h"
#import "GCHttpDataTool.h"


#define  KDuration 0.25

@interface GCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *pwdLoginView;


@property (weak, nonatomic) IBOutlet UIView *smsLoginView;

@property (weak, nonatomic) IBOutlet UITextField *pwdPhone_tf;

@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;

@property (weak, nonatomic) IBOutlet UITextField *smsPhone_tf;

@property (weak, nonatomic) IBOutlet UITextField *smsCode_tf;

@property (nonatomic, strong) MQHudTool *hud;

@property (weak, nonatomic) IBOutlet UIButton *smsCode_bt;


@end

@implementation GCLoginViewController

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
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self imageName:@"title_back"];
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"注册"];
    
    self.title=@"手机快捷登录";
}

#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    GCVerifyPhoneViewController *vc=[[GCVerifyPhoneViewController alloc] initWithNibName:@"GCVerifyPhoneViewController" bundle:nil];
    
    vc.title=@"验证手机号码";
    
     vc.verifyPhoneState=VerifyPhoneStateRegist;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -用户交互方法
- (IBAction)changeModenSmsLoginButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    [CATransitionHelper  addTransitionWithLayer:self.smsLoginView.layer animationType:kCATransitionPush subtype:kCATransitionFromLeft duration:KDuration];
    [CATransitionHelper  addTransitionWithLayer:self.pwdLoginView.layer animationType:kCATransitionPush subtype:kCATransitionFromLeft duration:KDuration];

    self.title=@"手机快捷登录";
    self.pwdLoginView.hidden=YES;
    self.smsLoginView.hidden=NO;
    
    
}

- (IBAction)changeModenPwdLoginButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    [CATransitionHelper  addTransitionWithLayer:self.smsLoginView.layer animationType:kCATransitionPush subtype:kCATransitionFromRight duration:KDuration];
    [CATransitionHelper  addTransitionWithLayer:self.pwdLoginView.layer animationType:kCATransitionPush subtype:kCATransitionFromRight duration:KDuration];
    
    self.title=@"密码登录";
    
    self.smsLoginView.hidden=YES;
    self.pwdLoginView.hidden=NO;
    
}


- (IBAction)getSmsButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.smsPhone_tf.text.length==0) {
        
        [self.hud addTipHudWithTitle:@"请输入手机号码" timeInterval:KHudTitleShowShortTime];
        return;
    }
    
    //functype=vc&mobile=13763085121
    
    [self.hud addNormHudWithSupView:self.view title:@"正在获取验证码..."];
    
    NSDictionary *dict=@{
                         @"functype":@"vc",
                         @"mobile":self.smsPhone_tf.text,
                      };

    
    [GCHttpDataTool getLoginSmsCodeWithDict:dict success:^(id responseObject) {
        
        
        [self.hud hide];
        
        [MQButtonCountDownTool startTimeWithButton:self.smsCode_bt];
        
        
    } failure:^(MQError *error) {
        
        [self.hud hudUpdataTitile:error.msg hideTime:1.0];
        
    }];
}


- (IBAction)forgetButtonClick:(id)sender {
    [self.view endEditing:YES];
    
    GCVerifyPhoneViewController *vc=[[GCVerifyPhoneViewController alloc] initWithNibName:@"GCVerifyPhoneViewController" bundle:nil];
    
    vc.title=@"验证手机号码";
    
    vc.verifyPhoneState=VerifyPhoneStateFogetPwd;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)smsCodeLoginClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.smsPhone_tf.text.length==0||self.smsCode_tf.text.length==0) {
        
        [self.hud addTipHudWithTitle:@"请输入手机号码和验证码" timeInterval:KHudTitleShowShortTime];
        return;
    }
    
    [self.hud addNormHudWithSupView:self.view title:@"正在登录中..."];
    
    //functype=tl&mobile=13763085121&vcode=&token=64f62f5341b6455981ed456bdb95eb80&pwd=123
    NSDictionary *dict=@{
                         @"functype":@"tl",
                         @"mobile":self.smsPhone_tf.text,
                         @"vcode":self.smsCode_tf.text,
                         @"token":@"",
                         @"pwd":@""
                         };
    
    [GCHttpDataTool smsLoginWithDict:dict success:^(id responseObject) {
        
        
        __weak typeof(self) ws = self;
        
        [[GCUser getInstance] updateUserInfoWithdict:responseObject[@"userInfo"]];

        [MQSaveLoadTool preferenceSaveUserInfo:responseObject[@"userInfo"] whitKey:KPreferenceUserInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiLoginSuccess object:nil];
        
        [self.hud hudUpdataTitile:@"登录成功" hideTime:1 success:^{
            [ws.navigationController popViewControllerAnimated:YES];
        }];
        
        
        
    } failure:^(MQError *error) {
        
        
        [self.hud hudUpdataTitile:error.msg hideTime:1.5];
        
        
    }];
    
    
    
    
}

- (IBAction)pwdLoginClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.pwd_tf.text.length==0||self.pwdPhone_tf.text.length==0) {
        
        [self.hud addTipHudWithTitle:@"请输入手机号码和密码" timeInterval:1.0];
        return;
        
    }
    
    [self.hud addNormHudWithSupView:self.view title:@"正在登录..."];
    
    //functype=pl&mobile=13763085121&pwd=1234
    NSDictionary *dict=@{
                         @"functype":@"pl",
                         @"mobile":self.pwdPhone_tf.text,
                         @"pwd":self.pwd_tf.text
                         };
    
    [GCHttpDataTool pwdLoginWithDict:dict success:^(id responseObject) {
        
        [[GCUser getInstance] updateUserInfoWithdict:responseObject[@"userInfo"]];
        
        [MQSaveLoadTool preferenceSaveUserInfo:responseObject[@"userInfo"] whitKey:KPreferenceUserInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiLoginSuccess object:nil];
        
        __weak typeof(self) ws = self;
        [self.hud hudUpdataTitile:@"登录成功" hideTime:KHudSuccessShowShortTime success:^{
            [ws.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
    } failure:^(MQError *error) {
        
        
        [self.hud hudUpdataTitile:error.msg hideTime:KHudTitleShowShortTime];
        
    }];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end

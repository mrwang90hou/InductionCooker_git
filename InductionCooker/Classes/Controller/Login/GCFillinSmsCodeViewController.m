//
//  GCFillinSmsCodeViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/22.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCFillinSmsCodeViewController.h"

#import "MQBarButtonItemTool.h"
#import "GCSetPwdViewController.h"
#import "MQButtonCountDownTool.h"
#import "MQHudTool.h"
#import "MQButtonCountDownTool.h"

@interface GCFillinSmsCodeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic,strong) MQHudTool *hud;

@property (weak, nonatomic) IBOutlet UITextField *smsCode_tf;

@property (weak, nonatomic) IBOutlet UIButton *smsCode_bt;


@end

@implementation GCFillinSmsCodeViewController

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
    
    self.phoneLabel.text=[NSString stringWithFormat:@"手机号码%@",self.phoneNum];
    
    [MQButtonCountDownTool startTimeWithButton:self.smsCode_bt];
    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    GCSetPwdViewController *vc=[[GCSetPwdViewController alloc] initWithNibName:@"GCSetPwdViewController" bundle:nil];
    vc.title=@"设置密码";
    
    vc.verifyPhoneState=self.verifyPhoneState;
    
    vc.phoneNum=self.phoneNum;
    
    vc.smsCode=self.smsCode_tf.text;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getSmsCodeButtonClick:(id)sender {
    
    if (self.smsCode_tf.text.length==0) {
        
        [self.hud addTipHudWithTitle:@"请先填写手机号码" timeInterval:KHudTitleShowShortTime];
        return;
        
    }
    
    [self.hud addNormHudWithSupView:self.view title:@"正在获取验证码..."];
    
    //functype=vc&mobile=13763085121
    
    NSDictionary *dict=@{
                         @"functype":@"vc",
                         @"mobile":self.phoneNum
                         };
    
    [GCHttpDataTool getForgetSmsCodeWithDict:dict success:^(id responseObject) {
        
        [self.hud hide];
        
        [MQButtonCountDownTool startTimeWithButton:self.smsCode_bt];
       
        
    } failure:^(MQError *error) {
        
        [self.hud hudUpdataTitile:error.msg hideTime:1];
        
    }];

    
    
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

























@end

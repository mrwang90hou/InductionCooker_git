//
//  GCUpdatePwdViewController.m
//  InductionCooker
//
//  Created by csl on 2017/7/19.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCUpdatePwdViewController.h"

#import "MQBarButtonItemTool.h"
#import "MQHudTool.h"


@interface GCUpdatePwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwd_tf;


@property (weak, nonatomic) IBOutlet UITextField *pwd_tf;

@property (weak, nonatomic) IBOutlet UITextField *again_tf;

@property (nonatomic,strong) MQHudTool *hud;

@end

@implementation GCUpdatePwdViewController

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
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"确定"];
    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    NSLog(@"您点击了 rightButtonClick ！");
    if (self.oldPwd_tf.text.length==0||self.pwd_tf.text.length==0||self.again_tf.text.length==0) {
        
        NSLog(@"请填写本页面的所有项 ！");
        [self.hud addTipHudWithTitle:@"请填写本页面的所有项"];
//        [_hud isShow];
        return;
        
    }
    [_hud isShow];
    if(![self.pwd_tf.text isEqualToString:self.again_tf.text])
    {
        NSLog(@"新密码填写不一致!");
        [_hud isShow];
        [self.hud addTipHudWithTitle:@"新密码填写不一致"];
        return;
    }
    [_hud isShow];
    NSLog(@"正在修改密码...!");
    [self.hud addNormHudWithSupView:self.view title:@"正在修改密码..."];
//    [_hud isShow];
    //functype=ch&mobile=13763085121&token=64f62f5341b6455981ed456bdb95eb80&old=123&new=456
    NSDictionary *dict=@{
                         @"functype":@"ch",
                         @"mobile":[GCUser getInstance].mobile,
                         @"old":self.oldPwd_tf.text,
                         @"new":self.pwd_tf.text,
                         @"token":[GCUser getInstance].token
                         };
    
    [GCHttpDataTool resetPasswordWithDict:dict success:^(id responseObject) {
        
        __weak typeof(self) ws = self;

        
        [_hud isShow];
        [self.hud hudUpdataTitile:@"修改密码成功" hideTime:KHudSuccessShowShortTime success:^{
            NSLog(@"修改密码成功!");
            [ws.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
    } failure:^(MQError *error) {
        
        NSLog(@"error.msg = %@",error.msg);
        [self.hud hudUpdataTitile:error.msg hideTime:KHudSuccessShowShortTime];
        [_hud isShow];
    }];
    [_hud isShow];
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

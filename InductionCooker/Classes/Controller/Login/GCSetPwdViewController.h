//
//  GCSetPwdViewController.h
//  InductionCooker
//
//  Created by csl on 2017/7/19.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCSetPwdViewController : UIViewController

@property (nonatomic,assign) VerifyPhoneState verifyPhoneState;

@property (nonatomic,copy) NSString *phoneNum;

@property (nonatomic,copy) NSString *smsCode;

@end

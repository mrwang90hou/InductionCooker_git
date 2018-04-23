//
//  GCFillinSmsCodeViewController.h
//  InductionCooker
//
//  Created by csl on 2017/6/22.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCFillinSmsCodeViewController : UIViewController

@property (nonatomic,copy) NSString *phoneNum;

@property (nonatomic,assign) VerifyPhoneState verifyPhoneState;

@end

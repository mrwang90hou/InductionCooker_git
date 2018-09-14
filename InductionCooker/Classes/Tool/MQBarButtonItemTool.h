//
//  MQBarButtonItemTool.h
//  goockr_cat_eye
//
//  Created by csl on 2016/11/17.
//  Copyright © 2016年 蔡敏权. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQBarButtonItemTool : NSObject

+ (UIBarButtonItem *) rightBarButttonItemWithViewController:(UIViewController *)vc title:(NSString *)title;

+ (UIBarButtonItem *) leftBarButttonItemWithViewController:(UIViewController *)vc title:(NSString *)title;

+ (UIBarButtonItem *) leftBarButttonItemWithViewController:(UIViewController *)vc imageName:(NSString *)imageName;

+ (UIButton *) setUpButtonWithTitle:(NSString *)title action:(SEL) action vc:(UIViewController *)vc;
@end

//
//  Common.h
//  NIMVideoDEMO
//
//  Created by 张茜倩 on 16/5/3.
//  Copyright © 2016年 Xiqian Zhang. All rights reserved.
//

#ifndef Common_h
#define Common_h


//尺寸
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define myAppDelegate  (AppDelegate*)([UIApplication sharedApplication].delegate)


//获取UIApplication
#define myWindow [UIApplication sharedApplication].keyWindow

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

/**
 *  通过hex设置颜色
 */
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define KScreenScaleValue(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width)

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)  




#endif /* Common_h */






















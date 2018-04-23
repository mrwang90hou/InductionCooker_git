//
//  MyAlertView.h
//  AlertViewDemo
//
//  Created by csl on 2017/12/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAlertView;

typedef void (^AlterViewClickedButtonAtIndex)(MyAlertView *alertView,NSInteger index);

@interface MyAlertView : UIView

+ (void) appearanceWithCancelColor:(UIColor *)cancelColor actionColor:(UIColor *)actionColor;

/**
 初始化MyAlertView
 
 @param title 标题
 @param msg 消息
 @param titles 按钮标题
 @param listener 按钮点击回调
 @return MyAlertView对象
 */
- (instancetype) initWithTitle:(NSString *)title message:(NSString *)msg otherButtonTitles:(NSArray *) titles listener:(AlterViewClickedButtonAtIndex)listener;

/**
 初始化MyAlertView
 
 @param title 标题
 @param msg 消息
 @param titles 按钮标题
 @param cancelIndex 取消按钮索引,以titles数组为界限
 @param listener 按钮点击回调
 @return MyAlertView对象
 */
- (instancetype) initWithTitle:(NSString *)title message:(NSString *)msg otherButtonTitles:(NSArray *) titles cancelIndex:(int) cancelIndex listener:(AlterViewClickedButtonAtIndex)listener;

- (void) show;

- (void) hide;

@end

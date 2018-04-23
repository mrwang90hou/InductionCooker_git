//
//  MQHudTool.h
//  goockr_dustbin
//
//  Created by csl on 2016/11/8.
//  Copyright © 2016年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MQHudTool;

@protocol MQHudToolDelegate <NSObject>

- (void) MQHudWasHidWithhud:(MQHudTool *)hud;

@end

@interface MQHudTool : NSObject

@property (nonatomic,weak) id<MQHudToolDelegate> delegate;

@property (nonatomic,assign) BOOL isShow;

/**
 创建hud单利

 @return 返回hud对象
 */
+ (instancetype) shareHudTool;



/**
 添加自动隐藏的提示hud

 @param title hud 标题
 */
- (void) addTipHudWithTitle:(NSString *) title;



/**
  添加自动隐藏的提示hud

 @param title 标题
 @param time 隐藏时间
 */
- (void) addTipHudWithTitle:(NSString *) title timeInterval:(NSTimeInterval) time;

/**
 添加一个hud在supview上

 @param supView 父view
 @param title hud标题
 */
- (void) addNormHudWithSupView:(UIView *) supView title:(NSString *)title;


/**
 在time秒后隐藏hud

 @param time 时间
 */
- (void) hidHudWithHideTime:(NSTimeInterval)time;


/**
 <#Description#>

 @param title <#title description#>
 */
//- (void) successShowHudWithTitle:(NSString *)title;


/**
 更新hud标题,并在time秒后隐藏,无回调

 @param title hud标题
 @param time 时间
 */
- (void) hudUpdataTitile:(NSString *)title hideTime:(NSTimeInterval)time;



/**
 更新hud标题,并在time秒后隐藏,有回调

 @param title hud标题
 @param time 时间
 @param succ hud隐藏回调
 */
- (void) hudUpdataTitile:(NSString *)title hideTime:(NSTimeInterval)time success:(onSuccess)succ;


/**
 添加一个hud在Window上

 @param title 标题
 @param window Window
 */
- (void) addHudWithTitle:(NSString *) title onWindow:(UIWindow *)window;


/**
 隐藏hud
 */
- (void) hide;





















@end

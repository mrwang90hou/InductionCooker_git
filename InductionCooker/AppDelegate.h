//
//  AppDelegate.h
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL hadShowAlert;

- (void) getDeviceListWithShowTip:(BOOL)show;

+ (AppDelegate *)sharedAppDelegate;

@end


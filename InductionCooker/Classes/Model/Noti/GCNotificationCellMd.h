//
//  GCNotificationCellMd.h
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCNotificationCellMd : NSObject

@property (nonatomic,assign) int msgId;

@property (nonatomic,assign) int notiState;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) NSString *date;

+ (instancetype) createModelWithDict:(NSDictionary *)dict;

+ (instancetype) createModelWithNotiState:(int)notiState text:(NSString *)text date:(NSDate *)date;

@end

//
//  GCNotificationCellMd.m
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCNotificationCellMd.h"

#import "NSDate+TimeCategory.h"

@implementation GCNotificationCellMd

+(instancetype)createModelWithDict:(NSDictionary *)dict
{
    
    GCNotificationCellMd *model=[[GCNotificationCellMd alloc] init];
    
    //[model setValuesForKeysWithDictionary:dict];
    model.notiState=[dict[@"notiState"] intValue];
    
    model.text=dict[@"text"];
    
    //@"2017.06.08  16:00"
    model.date=dict[@"date"] ;//[NSDate datestrFromDate:withDateFormat:@"YYYY.MM.dd HH:mm"] ;

    model.msgId=[dict[@"msgId"] intValue];
    
    
    return model;
    
}

+ (instancetype)createModelWithNotiState:(int)notiState text:(NSString *)text date:(NSDate *)date
{
    GCNotificationCellMd *model=[[GCNotificationCellMd alloc] init];
    
    //[model setValuesForKeysWithDictionary:dict];
    model.notiState=notiState;
    
    model.text=text;
    
    //@"2017.06.08  16:00"
    model.date=[NSDate datestrFromDate:date withDateFormat:@"YYYY.MM.dd HH:MM"] ;
    
    
    
    return model;
}


@end

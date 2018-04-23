//
//  GCSetBasicCellMd.h
//  goockr_heart
//
//  Created by csl on 16/10/5.
//  Copyright © 2016年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCSetBasicCellMd : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic ,copy) NSString *describeText;

@property (nonatomic,assign) BOOL isDiscover;

@property (nonatomic,assign) BOOL isSwitch;

+ (instancetype) createWithTitle:(NSString *)title describe:(NSString *)describe isDiscover:(BOOL) isDiscover;

+ (instancetype) createWithTitle:(NSString *)title  isSwitch:(BOOL) isSwitch;

@end

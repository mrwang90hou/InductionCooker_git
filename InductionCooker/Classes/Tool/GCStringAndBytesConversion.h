//
//  GCStringAndBytesConversion.h
//  InductionCooker
//
//  Created by csl on 2017/7/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCStringAndBytesConversion : NSObject


/**
 将date转成带,的字符串

 @param data data
 @return 字符串
 */
+ (NSString *) hexDataToListHexString:(NSData *)data;

@end

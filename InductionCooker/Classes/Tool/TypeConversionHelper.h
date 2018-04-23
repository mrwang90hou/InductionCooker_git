//
//  TypeConversionHelper.h
//  InductionCooker
//
//  Created by csl on 2017/7/10.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeConversionHelper : NSObject

+ (void) dataToStrng:(NSData *)data;

+ (void) dataToStrng:(NSData *)data count:(int)count;


+ (void) bytesToStrng:(Byte *)bytes length:(NSInteger)length;

@end

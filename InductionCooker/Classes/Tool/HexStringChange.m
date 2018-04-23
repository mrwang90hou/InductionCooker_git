//
//  HexStringChange.m
//  InductionCooker
//
//  Created by csl on 2017/9/18.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "HexStringChange.h"

@interface HexStringChange ()

@end

@implementation HexStringChange


+ (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}

@end

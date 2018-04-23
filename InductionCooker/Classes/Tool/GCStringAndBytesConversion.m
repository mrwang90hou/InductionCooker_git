//
//  GCStringAndBytesConversion.m
//  InductionCooker
//
//  Created by csl on 2017/7/20.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCStringAndBytesConversion.h"

@implementation GCStringAndBytesConversion

+(NSString *)hexDataToListHexString:(NSData *)data
{
    
    NSString *str=@"";
    
    Byte *bytes=(Byte *)[data bytes];
    
    for (int i=0; i<data.length; i++) {
        
        uint8_t bit=(uint8_t)bytes[i];
        
        if (i<data.length-1) {
        
            
           str= [str stringByAppendingString:[NSString stringWithFormat:@"%d,",bit]];
            
        }else{
            str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",bit]];
        }
        
    }
    
    return str;
}

@end

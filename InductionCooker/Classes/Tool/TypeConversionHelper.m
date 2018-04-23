//
//  TypeConversionHelper.m
//  InductionCooker
//
//  Created by csl on 2017/7/10.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "TypeConversionHelper.h"

@implementation TypeConversionHelper

+ (void) dataToStrng:(NSData *)data
{
    
    Byte *bytes = (Byte *)[data bytes];
    
    NSString *s =@"";
    
    for(int i=0;i<data.length;i++)
    {
        s= [s stringByAppendingString:[NSString stringWithFormat:@"%d,",bytes[i]]];
    }
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"接收到消息" message:s delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

+ (void) dataToStrng:(NSData *)data count:(int)count
{
    
    Byte *bytes = (Byte *)[data bytes];
    
    NSString *s =@"";
    
    for(int i=0;i<data.length;i++)
    {
        s= [s stringByAppendingString:[NSString stringWithFormat:@"%d,",bytes[i]]];
    }
    
    
    GCLog(@"第%d次 数据:%@",count,s);
    
    
}

+(void)bytesToStrng:(Byte *)bytes length:(NSInteger)length
{
    
    NSString *s =@"";
    
    for(int i=0;i<length;i++)
    {
        s= [s stringByAppendingString:[NSString stringWithFormat:@"%d,",bytes[i]]];
    }
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"接收到消息" message:s delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];

}

@end

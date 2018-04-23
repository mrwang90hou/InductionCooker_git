//
//  NSDictionary+Category.m
//  InductionCooker
//
//  Created by csl on 2017/8/4.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

- (void)toIntWthKey:(NSString *)key success:(void (^)(int result))result exp:(void (^)())exp
{
    NSNumber *number=self[key];

   // int a= [number intValue];
    
    int value=0;
    
    if (number) {
        value= [number intValue];
        result(value);
    }else{
        
        exp();
        
    }
    
   
}

- (void)toBoolWthKey:(NSString *)key success:(void (^)(BOOL result))result exp:(void (^)())exp
{
    NSNumber *number=self[key];
    
    BOOL value=NO;
    
    if (number) {
        value= [number boolValue];
         result(value);
    }else{
         exp();
    }
    
   
}

- (void)toLongWthKey:(NSString *)key success:(void (^)(long result))result exp:(void (^)())exp
{
    NSNumber *number=self[key];
    
    long value=0;
    
    if (number) {
        value= [number longValue];
        result(value);
    }else{
         exp();
    }
    
    
}



//字典转json格式字符串：
- (NSString*)dictionaryToJson
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}























@end

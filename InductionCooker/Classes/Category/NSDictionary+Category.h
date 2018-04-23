//
//  NSDictionary+Category.h
//  InductionCooker
//
//  Created by csl on 2017/8/4.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

- (void) toIntWthKey:(NSString *)key success:(void (^)(int result))result exp:(void (^)())exp;

- (void) toBoolWthKey:(NSString *)key success:(void (^)(BOOL result))result exp:(void (^)())exp;

- (void) toLongWthKey:(NSString *)key success:(void (^)(long result))result exp:(void (^)())exp;

- (NSString*)dictionaryToJson;

@end

//
//  MQSaveLoadTool.h
//  goockr_dustbin
//
//  Created by csl on 2017/2/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQSaveLoadTool : NSObject

+ (void) preferenceSaveValue:(id) value whitKey:(NSString *)key;

+ (id) preferenceGetValueForKey:(NSString *) key;

+ (void) preferenceRemoveValueForKey:(NSString *) key;

+ (BOOL) archiverSaveValue:(id)object fileName:(NSString *)fileName;

+ (NSArray *)getArchiverWithFileName:(NSString *)fileName;

+(void)removeArchiverValueWithFilename:(NSString *)fileName;

+(BOOL) isExistFile:(NSString *)fileName;


+ (void) preferenceSaveUserInfo:(id) value whitKey:(NSString *)key;


@end

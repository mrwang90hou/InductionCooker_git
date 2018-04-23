//
//  MQSaveLoadTool.m
//  goockr_dustbin
//
//  Created by csl on 2017/2/13.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "MQSaveLoadTool.h"

#define KRecordFile @"sealrecord"

@implementation MQSaveLoadTool

+ (void)preferenceSaveValue:(id)value whitKey:(NSString *)key
{
    // 获取用户偏好设置对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 保存用户偏好设置
    //  [defaults setBool:self.one.isOn forKey:@"one"];
    [defaults setObject:value forKey:key];
    // 注意：UserDefaults设置数据时，不是立即写入，而是根据时间戳定时地把缓存中的数据写入本地磁盘。所以调用了set方法之后数据有可能还没有写入磁盘应用程序就终止了。
    // 出现以上问题，可以通过调用synchornize方法强制写入
    // 现在这个版本不用写也会马上写入 不过之前的版本不会
    [defaults synchronize];
}

+ (id) preferenceGetValueForKey:(NSString *) key;
{
    
    // 读取用户偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
    
}


+ (void) preferenceRemoveValueForKey:(NSString *) key;
{
    GCLog(@"移除偏好设置: %@",key);
    // 读取用户偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:key];
    
    [defaults synchronize];
    
}


+ (BOOL) archiverSaveValue:(id)object fileName:(NSString *)fileName
{
    
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *newFilePath = [filePath stringByAppendingPathComponent:KRecordFile];
    
    [self createFileDirectories:newFilePath];
    
    newFilePath = [newFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    
    
    //如果success为true则代表成功
    
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:newFilePath];
    
    return success;
    
}


+ (NSArray *)getArchiverWithFileName:(NSString *)fileName

{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //  NSString *newFilePath = [filePath stringByAppendingPathComponent:@"devices.txt"];
    
    NSString *newFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",KRecordFile,fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *array =[NSArray array];
    
    if([fileManager fileExistsAtPath:newFilePath]) //如果存在
        
    {
        
        //解档得到数组
        
        array = [NSKeyedUnarchiver unarchiveObjectWithFile:newFilePath];
        
        
    }
    
    return  array;
    
    
}

+(void)removeArchiverValueWithFilename:(NSString *)fileName
{
    
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //  NSString *newFilePath = [filePath stringByAppendingPathComponent:@"devices.txt"];
    
    NSString *newFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",KRecordFile,fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:newFilePath])
    {
        [fileManager removeItemAtPath:newFilePath error:nil];
    }
    
}


+ (void)createFileDirectories:(NSString *)path

{
    
    // 判断存放音频、视频的文件夹是否存在，不存在则创建对应文件夹
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist= [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    //  = [fileManager fileExistsAtPath:@"" :&isDir];
    
    
    
    if(!(isDirExist && isDir))
        
    {
        
        // BOOL bCreateDir = [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER_AUDIOwithIntermediateDirectories:YESattributes:nilerror:nil];
        
        
        BOOL bCreateDir=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(!bCreateDir){
            
            GCLog(@"Create Audio Directory Failed.");
            
        }
        
        GCLog(@"%@",path);
        
    }
    
}


+(BOOL)isExistFile:(NSString *)fileName
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *newFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.txt",KRecordFile,fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist= [fileManager fileExistsAtPath:newFilePath isDirectory:&isDir];
    
    if(isDirExist)
    {
        return YES;
       
    }else{
        return NO;
    }

    
}


+ (void) preferenceSaveUserInfo:(id) value whitKey:(NSString *)key
{
    
    NSString *name=value[@"name"];
    
    NSString *mobile=value[@"mobile"];
    
    NSString *userId=value[@"id"];
    
    NSString *token=value[@"token"];
    
    NSDictionary *dictionary=@{
                               @"name":name,
                               @"mobile":mobile,
                               @"id":userId,
                               @"token":token,
                               };
    
    [self preferenceSaveValue:dictionary whitKey:key];
    
    
    
}

























@end

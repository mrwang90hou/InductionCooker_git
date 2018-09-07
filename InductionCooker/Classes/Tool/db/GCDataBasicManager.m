//
//  GCDataBasicManager.m
//  goockr_heart
//
//  Created by csl on 16/10/9.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCDataBasicManager.h"

#import "FMDB.h"
#import "NSDate+TimeCategory.h"

@interface GCDataBasicManager ()

@property (nonatomic, retain) FMDatabase *database;


@end

@implementation GCDataBasicManager

#pragma mark - Public

+(instancetype)shareManager{
    
    
    NSString *dbName =@"InductionCooker.sqlite";
    
    static GCDataBasicManager *dbmain = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        dbmain = [[GCDataBasicManager alloc] init];
        [dbmain configurationDataBase:dbName];
    });
    
    return dbmain;
    
}



-(BOOL)createTableWithName:(NSString *)tableName paramters:(NSDictionary *)param{
    
    NSArray *keysArray = [param allKeys];
    NSArray *valuesArray = [param allValues];
    
    //判断一下valuesArray是否是数据库中的数据类型
    
    NSArray *sqlTypeArray = @[@"int",@"float",@"char",@"varchar",@"text",@"integer",@"date",@"time"];
    int correct = 0;
    for (NSString *value in valuesArray) {
        
        for (NSString *sqlTypeStr in sqlTypeArray) {
            if ([value isEqualToString:sqlTypeStr]) {
                correct++;
                break;
            }
        }
    }
    
    if (correct!=valuesArray.count) {
        NSLog(@"sql数据类型错误");
        return NO;
    }
    //拼接keys values
    NSMutableArray *muArray = [NSMutableArray array];
    for (int i=0; i<keysArray.count; i++) {
        
        NSString *keys_values = [NSString stringWithFormat:@"%@ %@",keysArray[i],valuesArray[i]];
        [muArray addObject:keys_values];
        
    }
    
    NSString *keyTypeString = [muArray componentsJoinedByString:@","];
    
    keyTypeString=[NSString stringWithFormat:@"id INTEGER PRIMARY KEY AUTOINCREMENT, %@",keyTypeString];

    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(%@);",tableName,keyTypeString];
    
    NSLog(@"sqlStr:%@",sqlStr);
    
    return  [self.database executeUpdate:sqlStr];
}

-(BOOL)dropTableWithName:(NSString *)tableName{
    NSString *sqlStr = [NSString stringWithFormat:@"drop table %@;", tableName];
    
    return [self.database executeUpdate:sqlStr];
}


-(BOOL)insertOneDataOnTable:(NSString *)tableName model:(id)model{
    
    
    NSString *sqlStr=nil;
    
    GCNotificationCellMd *item=model;
        
    sqlStr = [NSString stringWithFormat:@"insert into %@ (notiState,date,text) values(?,?,?);",tableName];
        
    return [self.database executeUpdate:sqlStr,[NSString stringWithFormat:@"%d",item.notiState],item.date,item.text];

  
}


-(BOOL)deleteOneDataFromTable:(NSString *)tableName model:(GCNotificationCellMd *)model{
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where date = ? ;",tableName];
    
    return [self.database executeUpdate:sqlStr,model.date];
}

-(BOOL)deleteAllDataFromTable:(NSString *)tableName{
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@;",tableName];
    return [self.database executeUpdate:sqlStr];
}


-(BOOL)updateOneDataWithTable:(NSString *)tableName model:(GCNotificationCellMd *)model{
    
//    NSString *sqlStr = [NSString stringWithFormat:@"update %@ set age = ? where name = ?;",tableName];
//    return [self.database executeUpdate:sqlStr,model.age,model.name];
    
    return NO;
}

-(NSArray *)selecteFromTable:(NSString *)tableName name:(id)name{
    
    NSString *sqlStr=nil;
    
    
    FMResultSet *result=nil;
    NSNumber *value=nil;
    
    NSMutableArray *array  = [NSMutableArray array];;

        //when createTime = ?
        
       // value=@([NSDate cTimestampFromDate:name]);

        //关键字where错写成when
        sqlStr = [NSString stringWithFormat:@"select * from %@ ",tableName];
        
        
        
        result = [self.database executeQuery:sqlStr];
        
        NSLog(@"查询【通知】结果列表：路径和参数 %@%@",sqlStr,value);
        
        while (result.next) {
            
            NSString *state=[result stringForColumn:@"notiState"];
            
            NSString *date=[result stringForColumn:@"date"];
            
            NSString *text=[result stringForColumn:@"text"];
            
            NSString *msgId=[result stringForColumn:@"id"];
            
            NSDictionary *dict=@{
                                 @"msgId":msgId,
                                 @"notiState":state,
                                 @"text":text,
                                 @"date":date
                                 };
            
            
            
            GCNotificationCellMd *model = [GCNotificationCellMd createModelWithDict:dict];
            
            [array addObject:model];
        }

    

      return array;
}


#pragma mark - Private

-(void)configurationDataBase:(NSString *)dbName{
    
    NSString *documentPath = [self documentPath];
    
    self.database = [FMDatabase databaseWithPath:[documentPath stringByAppendingPathComponent:dbName]];
    
   // NSLog(@"数据库路径%@",[documentPath stringByAppendingPathComponent:dbName]);
    
    //    self.databaseName = dbName;
    if (![self.database open]) {
        NSLog(@"数据库打开失败！");
        return;
    }
}

-(NSString *)documentPath{
    
    return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}



@end

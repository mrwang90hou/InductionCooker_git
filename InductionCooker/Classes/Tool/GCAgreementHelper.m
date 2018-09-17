//
//  GCAgreementHelper.m
//  InductionCooker
//
//  Created by csl on 2017/7/7.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCAgreementHelper.h"

#import "TypeConversionHelper.h"

typedef NS_ENUM(NSInteger, WorkModen) {
    
    WorkModenSoup = 0,                         // no button type
    
    WorkModenLeftPorridge=1,
    
    WorkModenLeftRice=2,
    
    WorkModenLeftWater=3,
    
    WorkModenLeftHotpot=4,
    
    WorkModenLeftFried=5,
    
    WorkModenLeftBarbecue=6,
    
    WorkModenLeftInsulation=7,
    
    
    WorkModenRightBaked=8,
    
    WorkModenRightStewed=9,
    
    WorkModenRightInsulation=10,
    
    WorkModenRightStirFry=11,
    
    WorkModenRightFried=12,
    
    WorkModenRightSlowFire=13,
    
    
};


@implementation GCAgreementHelper

static NSDictionary *stallsOfModenDict;

static NSDictionary *leftModens;

static NSDictionary *rightModens;

- (void) test{
    Byte b={0x10};
}



+ (NSData *) handlerData:(NSMutableArray *) list{
    
    
    
    
    int checkByte = 0;//校验位
    NSMutableArray *newlist =[NSMutableArray array];//缓存数组
    
    /**
     * 指令只有一个字节的情况
     * */
    if (list.count == 1) {
        checkByte = [list[0] intValue] ^ [list[0] intValue];
        
        [newlist addObject:@0xAA];
        
     
        //转义过程
        if ([list[0] intValue] == 0xAA) {
            
            [newlist addObject:@0x56];
            [newlist addObject:@0xAB];
            
        } else if ([list[0] intValue] == 0x55) {
            
            [newlist addObject:@0x56];
            [newlist addObject:@0x56];
            
//            newlist.add(0x56);
//            newlist.add(0x56);
            
        } else if ([list[0] intValue] == 0x56) {
            
//            newlist.add(0x56);
//            newlist.add(0x57);
            
            [newlist addObject:@0x56];
            [newlist addObject:@0x57];
            
            
        } else {
            
            [newlist addObject:list[0]];
            
        }
        
        [newlist addObject:[NSNumber numberWithInteger:checkByte]];
        [newlist addObject:@0x55];//包尾
    }
    
    
    if (list.count > 1) {
        
        for (int i = 0; i < list.count; i++) {
            if (i == 0) {
                checkByte = [list[i] intValue];
            } else {
                checkByte = checkByte ^ [list[i] intValue];
            }
        }
        
        [newlist addObject:@0xAA];
        
        for (NSNumber *value in list) {
            
            int i=[value intValue];
            
            if (i == 0xAA) {
                
                [newlist addObject:@0x56];
                [newlist addObject:@0xAB];
                
//                newlist.add(0x56);
//                newlist.add(0xAB);
                
            } else if (i == 0x55) {
                
                [newlist addObject:@0x56];
                [newlist addObject:@0x56];
                
//                newlist.add(0x56);
//                newlist.add(0x56);
                
            } else if (i == 0x56) {
                
                [newlist addObject:@0x56];
                [newlist addObject:@0x57];
                
//                newlist.add(0x56);
//                newlist.add(0x57);
                
            } else {
                
                [newlist addObject:value];
                
              //  newlist.add(i);
                
            }
        }

        [newlist addObject:[NSNumber numberWithInteger:checkByte]];
        [newlist addObject:@0x55];
        
//        newlist.add(checkByte);
//        newlist.add(0x55);//包尾
        
    }
    
    
    
 //   Byte buff[] = new byte[newlist.size()];
    
    Byte buff[newlist.count];
    
    for (int i = 0; i < newlist.count; i++) {
        buff[i] = [newlist[i] intValue];
    }
    
    NSData *data=[NSData dataWithBytes:buff length:newlist.count];
    
    return data;
}


+ (NSData *) getDataWithModen:(int)moden device:(int) deviecId{
 
    NSMutableArray *list=[NSMutableArray array];
    
    [list addObject:@0x02];
    [list addObject:[NSNumber numberWithInt:deviecId]];
    [list addObject:[NSNumber numberWithInt:moden]];
    
    
    return [self handlerData:list];
}


+ (NSData *)getBytesWithDeviceId:(int)deviceId Stalls:(int) stall
{
    
    NSMutableArray *list=[NSMutableArray array];
    
    [list addObject:@0x03];
    [list addObject:[NSNumber numberWithInt:deviceId]];
    [list addObject:[NSNumber numberWithInt:stall]];
    
    
    return [self handlerData:list];

    
}


+ (NSData *) getRootBytesWithDeviceId:(int)deviceId status:(int) status
{

    
    NSMutableArray *list=[NSMutableArray array];
    
    [list addObject:@0x01];
    [list addObject:[NSNumber numberWithInt:deviceId]];
    [list addObject:[NSNumber numberWithInt:status]];
    
    
    return [self handlerData:list];
    
}


+ (NSData *) BCCCheck:(NSData *)data
{
    
    BOOL isSuccess=false;
    
    Byte *bytes = (Byte *)[data bytes];

    NSInteger count=data.length-1;
    
    int BCC=0;
    
    NSMutableData *mData=[NSMutableData data];
    Byte firstBit[]={bytes[0]};
    [mData appendData:[NSData dataWithBytes:firstBit length:1]];
    
    for (int i=1; i<count; i++) {
        
        
        Byte byte[]={bytes[i]};
        NSData *currentData=[NSData dataWithBytes:byte length:1];
        
        
        if (i==count-1) {
            
            isSuccess=(Byte)BCC==bytes[i]?YES:NO;
            
             [mData appendData:currentData];
            
        }else{

            
            if (bytes[i]==0x56&&bytes[i+1]==0x57) {
                
                BCC = BCC ^ 0x56;
                
                Byte bit[]={0x56};
                [mData appendData:[NSData dataWithBytes:bit length:1]];
                i++;
                
                continue;
                
            }else if (bytes[i]==0x56&&bytes[i+1]==0x56)
            {
                BCC = BCC ^ 0x55;
                
                Byte bit[]={0x55};
                [mData appendData:[NSData dataWithBytes:bit length:1]];
                i++;
                
                continue;
                
            }else if (bytes[i]==0x56&&bytes[i+1]==0xAB)
            {
                BCC = BCC ^ 0xAA;
                
                Byte bit[]={0xAA};
                [mData appendData:[NSData dataWithBytes:bit length:1]];
                i++;
                
                continue;
                
            }else{
                
                if (i==1) {
                    BCC=bytes[i];
                }else
                {
                    int a=bytes[i];
                    BCC = BCC ^ a;

                }
                
                
                [mData appendData:currentData];

            }

        }

    }
    
    
    
    Byte endBit[]={bytes[data.length-1]};
    [mData appendData:[NSData dataWithBytes:endBit length:1]];

    //Byte *resultBit=(Byte *)[mData bytes];
    
    //[TypeConversionHelper dataToStrng:mData count:10];
    
    
    if(isSuccess) {
        
        return mData;
        
    }else
    {
        return nil;
    }
       
    
    
}


+ (NSString *) getPowerWhithDeivce:(int) deviceId moden:(int)moden stalls:(int) stalls
{
    
    NSDictionary *dict=[self getStallsDict];
    
    NSString *deviceStr=[NSString stringWithFormat:@"%d",deviceId];
    
    //    moden=deviceId==1?moden+100:moden;
    
    NSString *modenStr=[NSString stringWithFormat:@"%d",moden];
    
    NSString *stallsStr=[NSString stringWithFormat:@"%d",stalls];
    
    NSString *str=dict[deviceStr][modenStr][stallsStr];
    
    NSString *powerStr=[NSString stringWithFormat:@"%@W",str];
    
    if (deviceId == 1) {
        if (moden == 5 || moden == 6) {
            powerStr=[NSString stringWithFormat:@"%@℃",str];
        }
    }else{
        if (moden == 111) {
            powerStr=[NSString stringWithFormat:@"%@℃",str];
        }
    }
    if (moden == -1) {
        powerStr = @"已开机";
    }
    
    
    return powerStr;
}

+ (NSDictionary *) getStallsDict
{
    if (stallsOfModenDict==nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stall" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        stallsOfModenDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
    }
    return stallsOfModenDict;
}

+ (NSDictionary *) getStallsDictWith:(int) deviceId moden:(int) moden
{
    if (stallsOfModenDict==nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"stall" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        stallsOfModenDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
    }
    
    
    NSString *deviceStr=[NSString stringWithFormat:@"%d",deviceId];
    
    moden=moden;
    
    NSString *modenStr=[NSString stringWithFormat:@"%d",moden];
    
    NSDictionary *dict=stallsOfModenDict[deviceStr][modenStr];
    
    return dict;
}

+ (GCModen *)getLeftModenWithModenId:(int)modenId
{
    
    
    
    if(leftModens==nil)
    {
    
        NSString *path = [[NSBundle mainBundle] pathForResource:@"leftdevice" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableDictionary *mDict=[NSMutableDictionary dictionary];
        
        for (int i=0;i<[dic[@"value"] count];i++) {
            
            NSDictionary *dict = dic[@"value"][i];
            
            GCModen *model=[GCModen createModelWithDict:dict];
            
            [mDict setObject:model forKey:[NSString stringWithFormat:@"%d",i] ];
           
        }
        
        leftModens=mDict;

    }
    
    
    
    return leftModens[[NSString stringWithFormat:@"%d",modenId]];
    
}


+ (GCModen *)getRightModenWithModenId:(int)modenId
{
    
    if(leftModens==nil)
    {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"rightdevice" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableDictionary *mDict=[NSMutableDictionary dictionary];
        
        for (int i=8;i<[dic[@"value"] count]+8;i++) {
            
            
            
            NSDictionary *dict = dic[@"value"][i];
            
            GCModen *model=[GCModen createModelWithDict:dict];
            
            if (i==10) {
                
                 [mDict setObject:model forKey:[NSString stringWithFormat:@"%d",7] ];
                
            }else
            {
              [mDict setObject:model forKey:[NSString stringWithFormat:@"%d",i] ];
            }
            
            
            
        }
        
        rightModens=mDict;
        
    }
    
    
    
    return rightModens[[NSString stringWithFormat:@"%d",modenId]];
    
}















@end

//
//  GCSetBasicCellMd.m
//  goockr_heart
//
//  Created by csl on 16/10/5.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCSetBasicCellMd.h"

@implementation GCSetBasicCellMd

+(instancetype)createWithTitle:(NSString *)title isSwitch:(BOOL)isSwitch
{
    GCSetBasicCellMd *md=[[GCSetBasicCellMd alloc] init];
    
    md.title=title;
    
    md.isSwitch=isSwitch;
    
    return md;
}

+(instancetype)createWithTitle:(NSString *)title describe:(NSString *)describe isDiscover:(BOOL)isDiscover
{
    GCSetBasicCellMd *md=[[GCSetBasicCellMd alloc] init];
    
    md.title=title;
    
    md.isDiscover=isDiscover;
    
    md.describeText=describe;
    
    return md;
    
}


@end

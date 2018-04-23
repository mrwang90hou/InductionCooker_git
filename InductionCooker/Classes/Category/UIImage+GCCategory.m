//
//  UIImage+GCCategory.m
//  goockr_heart
//
//  Created by csl on 16/10/3.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "UIImage+GCCategory.h"

@implementation UIImage (GCCategory)

+(instancetype)originalImageWithName:(NSString *)name
{
    UIImage *image=[UIImage imageNamed:name];
    
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}

@end

//
//  GCImageRightButton.m
//  InductionCooker
//
//  Created by csl on 2017/6/12.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCImageRightButton.h"

#import "UIView+NTES.h"

@implementation GCImageRightButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    
   // self.titleLabel.backgroundColor=[UIColor redColor];
    
    
   
    
}

-(void)setImageVisit:(BOOL) visit
{
   
    if (visit) {
         [self setImage:[UIImage imageNamed:@"home_icon_warning"] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
   
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame=self.imageView.frame;
    
    self.imageView.frame=CGRectMake(self.width-frame.size.width-5, frame.origin.y, frame.size.width, frame.size.height);
    
   // CGSize size = CGSizeMake(320,2000);
    
    
    float x=0;
    float y=self.height/2-(frame.size.height/2);
    self.titleLabel.frame=CGRectMake(x,y,(self.width-frame.size.width-10),frame.size.height);
    
    
}

@end

//
//  MQBarButtonItemTool.m
//  goockr_cat_eye
//
//  Created by csl on 2016/11/17.
//  Copyright © 2016年 蔡敏权. All rights reserved.
//

#import "MQBarButtonItemTool.h"

@implementation MQBarButtonItemTool

+ (UIBarButtonItem *) rightBarButttonItemWithViewController:(UIViewController *)vc title:(NSString *)title
{
//    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:vc action:@selector(rightButtonClick)];

  
   
    
    SEL action=@selector(rightButtonClick);
    
    UIButton *btn=[self setUpButtonWithTitle:title action:action vc:vc];
    
    NSDictionary * attributes = @{NSFontAttributeName:btn.titleLabel.font};
    CGSize size = [title boundingRectWithSize:CGSizeMake(KScreenWidth, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat width = size.width;
    if (width < 44) {
        width = 44;
    }
    
    btn.frame = CGRectMake(0, 0, width, 44);
 
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    vc.navigationItem.rightBarButtonItem=rightitem;
    
    
    
    return rightitem;
}

+ (UIBarButtonItem *) leftBarButttonItemWithViewController:(UIViewController *)vc title:(NSString *)title
{
     SEL action=@selector(leftButtonClick);
    
    UIButton *btn=[self setUpButtonWithTitle:title action:action vc:vc];
    
    NSDictionary * attributes = @{NSFontAttributeName:btn.titleLabel.font};
    CGSize size = [title boundingRectWithSize:CGSizeMake(KScreenWidth, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat width = size.width;
    if (width < 44) {
        width = 44;
    }
    
    btn.frame = CGRectMake(0, 0, width, 44);
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    vc.navigationItem.leftBarButtonItem=leftButton;
    
    return leftButton;
    
}

+ (UIBarButtonItem *)leftBarButttonItemWithViewController:(UIViewController *)vc imageName:(NSString *)imageName
{
    
   // UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:vc action:@selector(leftButtonClick)];
    
    UIImage *image=[UIImage imageNamed:imageName];
    
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:vc action:@selector(leftButtonClick)];
    
    
    
    vc.navigationItem.leftBarButtonItem=leftButton;
    
    return leftButton;
    
}

+ (UIButton *) setUpButtonWithTitle:(NSString *)title action:(SEL) action vc:(UIViewController *)vc
{
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    //btn.frame=CGRectMake(0, 0, 44, 44);
    
    btn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    
    [btn setTitleColor:UIColorFromRGB(KMainColor) forState:UIControlStateNormal];
    
    return btn;
    
}

- (void)rightButtonClick{
    
}

- (void)leftButtonClick{
    
}

@end

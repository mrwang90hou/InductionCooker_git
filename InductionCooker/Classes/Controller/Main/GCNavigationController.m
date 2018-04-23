//
//  GCNavigationController.m
//  goockr_dustbin
//
//  Created by csl on 16/9/30.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCNavigationController.h"

@interface GCNavigationController ()
{
    UIImageView *navBarHairlineImageView;
}

@end

@implementation GCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = YES;
}


#pragma mark -页面逻辑方法
- (void) createUI
{
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xf0f0f0)];
    self.navigationBar.translucent=NO;
   
   // navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];

    
  // [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
   //self.navigationBar.tintColor = [UIColor redColor];
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor yellowColor]];
    
    
    
    
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//    
//    if (self.childViewControllers.count==1) {
//        viewController.hidesBottomBarWhenPushed = true; //viewController是将要被push的控制器
//    }
//    //  [super pushViewController:viewController animated:animated];
//    
//    super.pushViewController(viewController, animated: animated);
//    
//    
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.childViewControllers.count==1) {
        
        viewController.hidesBottomBarWhenPushed=YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

































@end

//
//  GCTabBarController.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCTabBarController.h"

#import "GCHomeViewController.h"
#import "GCNavigationController.h"
#import "UIImage+GCCategory.h"
#import "GCNotificationViewController.h"
#import "GCMoreViewController.h"
#import "WifiHelper.h"
#import "GCTestViewController.h"
#import "GCUser.h"


@interface GCTabBarController ()<UIAlertViewDelegate>

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1 alpha:0.6],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    GCHomeViewController *homeVc=[[GCHomeViewController alloc] initWithNibName:@"GCHomeViewController" bundle:nil];
    GCNavigationController *homeNav=[[GCNavigationController alloc] initWithRootViewController:homeVc];
    homeNav.tabBarItem.title=@"首页";
    //heartVc.title=@"设备";
    [homeNav.tabBarItem setImage:[UIImage originalImageWithName:@"tab_icon_home_normal"]];
    [homeNav.tabBarItem setSelectedImage:[UIImage originalImageWithName:@"tab_icon_home_selected"]];
    
    
    GCNotificationViewController *notiVc=[[GCNotificationViewController alloc] initWithNibName:@"GCNotificationViewController" bundle:nil];
    GCNavigationController *notiNav=[[GCNavigationController alloc] initWithRootViewController:notiVc];
    notiNav.tabBarItem.title=@"通知";
    notiVc.title=@"通知";
    [notiNav.tabBarItem setImage:[UIImage originalImageWithName:@"tab_icon_notise_normal"]];
    [notiNav.tabBarItem setSelectedImage:[UIImage originalImageWithName:@"tab_icon_notise_selected"]];

    
    GCMoreViewController *moreVc=[[GCMoreViewController alloc] initWithNibName:@"GCMoreViewController" bundle:nil];
    GCNavigationController *moreNav=[[GCNavigationController alloc] initWithRootViewController:moreVc];
    moreNav.tabBarItem.title=@"更多";
    moreVc.title=@"更多";
    [moreNav.tabBarItem setImage:[UIImage originalImageWithName:@"tab_icon_more_normal"]];
    [moreNav.tabBarItem setSelectedImage:[UIImage originalImageWithName:@"tab_icon_more_selected"]];

    
    GCTestViewController *testVc=[[GCTestViewController alloc] initWithNibName:@"GCTestViewController" bundle:nil];
    
    
//    self.viewControllers =@[homeNav,notiNav,moreNav];
    
    self.viewControllers =@[homeNav,notiNav,moreNav,testVc];

    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    //self.tabBar.backgroundColor=UIColorFromRGB(KMainColor);
    
    
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(KMainColor)];
    [UITabBar appearance].translucent = NO;
    
    //如果需要不显示分割线，只需要将下面一句话
    [self.tabBar setClipsToBounds:YES];
    
    
  //  [self wifiConnectStatus];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [self conectService];

    
    
    
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if ([tabBar.items indexOfObject:item]==1) {
        [GCUser getInstance].device.error=0;
    }
    
}






































@end

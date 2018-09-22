//
//  AppDelegate.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "AppDelegate.h"

#import "GCTabBarController.h"
#import "ViewController.h"
#import "GCNavigationController.h"
#import "GCNetStateHelper.h"
#import "RHSocketConnection.h"
#import "GCDAsyncSocket.h"
#import "SIAlertView.h"
#import "GCDataBasicManager.h"
#import "GCBinddinViewController.h"
#import "GCLoginViewController.h"
#import "NSDictionary+Category.h"
#import "QRCodeReaderViewController.h"
//#import "JRSwizzle.h"
@interface AppDelegate ()

@property (nonatomic,strong) RHSocketConnection *listenSockect;

@property (nonatomic,strong) SIAlertView *alertView;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self setAppearance];
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    GCTabBarController *vc=[[GCTabBarController alloc] init];
    
    
    self.window.rootViewController=vc;
    
//    GCLoginViewController *tvc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
//    
//    GCNavigationController *nav=[[GCNavigationController alloc] initWithRootViewController:tvc];
//    
//    self.window.rootViewController=nav;
    
    
    [self initDataBasic];
    
    
    [self autoLogin];
    
    [self getDeviceListWithShowTip:NO];

    [self addObserver];
    
    
    [self setSVprogressHUD];
    
//    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    return YES;
}


- (void) setAppearance
{
    [[UIBarButtonItem appearance] setTintColor:UIColorFromRGB(KMainColor)];
    
    [[SIAlertView appearance] setButtonColor:UIColorFromRGB(KMainColor)];
    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
   
    
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageNamed:@"pop_btn_cancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageNamed:@"pop_btn_cancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setCancelButtonImage:[[UIImage imageNamed:@"btn_--cancel_reservation_normal-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[[UIImage imageNamed:@"btn_--cancel_reservation_normal-1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setDestructiveButtonImage:[[UIImage imageNamed:@"pop_btn_sure"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[[UIImage imageNamed:@"pop_btn_sure"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    
    [[SIAlertView appearance] setCornerRadius:10];
    

    
}


- (void) initDataBasic
{
    
    NSString *tableName = KErrorTableName;
    
    NSDictionary *dataDict = @{@"notiState":@"text",@"date" : @"text",@"text":@"text"};
    
    [[GCDataBasicManager shareManager] createTableWithName:tableName paramters:dataDict];
    
}

- (void) autoLogin
{
    NSDictionary *dict=[MQSaveLoadTool preferenceGetValueForKey:KPreferenceUserInfo];
    
    [[GCUser getInstance] updateUserInfoWithdict:dict];
    
}




#pragma mark -Appdelegate
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    
   // [self conectService];
    
}





#pragma mark -逻辑方法
- (void) getDeviceListWithShowTip:(BOOL)show
{
    //mobile=13800138000&token=adsafokjdsoaidslakjfsdalkj
    
    if ([GCUser getInstance].userId&&[GCUser getInstance].token) {
        
        [[MQHudTool shareHudTool] addHudWithTitle:@"正在获取产品列表..." onWindow:self.window];
//        [SVProgressHUD showWithStatus:@"正在获取产品列表..."];
        NSDictionary *dict=@{
                             @"mobile":[GCUser getInstance].mobile,
                             @"token":[GCUser getInstance].token,
                             };
        [GCHttpDataTool deviceListWithDict:dict success:^(id responseObject) {
            
            [[MQHudTool shareHudTool] hide];
            
            NSArray *devices=responseObject[@"list"];
            
            if (![devices isKindOfClass:[NSNull class]]&&devices.count>0) {
                
                NSMutableArray *devs=[NSMutableArray array];
                for(int i=0 ;i<devices.count;i++ )
                {
                    GCDevice *device=[[GCDevice alloc] init];
                    device.deviceId=devices[i];
                    device.deviceName=[NSString stringWithFormat:@"电磁炉%d",i+1];
                    [devs addObject:device];
                }
                
                [GCUser getInstance].deviceList=devs;
                
                
                NSDictionary *selDevDict=@{
                                           @"mobile":[GCUser getInstance].mobile,
                                           @"token":[GCUser getInstance].token
                                           };
                
                [GCHttpDataTool selectDeviceWithDict:selDevDict success:^(id responseObject) {
                    
                    
                    NSArray *selDevs=responseObject[@"list"];
                    
                    for (GCDevice *dev in [GCUser getInstance].deviceList) {
                        
                        if ([dev.deviceId isEqualToString:selDevs[0]]) {
                            [GCUser getInstance].device=dev;
                            break;
                        }
                        
                    }
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
                    
                    [self conectService];
//                    [SVProgressHUD showSuccessWithStatus:@"获取设备成功！"];
                } failure:^(MQError *error) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"获取当前选中电磁炉失败,请重试!"];
                    [alertView addButtonWithTitle:@"确定"
                                             type:SIAlertViewButtonTypeCancel
                                          handler:^(SIAlertView *alertView) {
                                              
                                              [self getDeviceListWithShowTip:show];
                                              
                                              [alertView dismissAnimated:NO];
                                              
                                          }];
                    
                    [alertView show];
                    
                }];
                
            }else
            {
                if (show) {
                    [GCDiscoverView showWithTip:@"您未绑定和一电磁炉产品,请先绑定产品,再进行操作!"];
//                    [SVProgressHUD showErrorWithStatus:@"您未绑定和一电磁炉产品,请先绑定产品,再进行操作!"];
                    //跳转到绑定设备页面
                    [self turnToQRCodeReader];
                }
                
               
            }
            
           
            
        } failure:^(MQError *error) {
            
            [[MQHudTool shareHudTool] hudUpdataTitile:@"获取产品列表失败" hideTime:KHudTitleShowShortTime];
            
        }];
    }
}
- (void)turnToQRCodeReader{
    
    UITabBarController *tab = (UITabBarController *)_window.rootViewController;
    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    //                            MessageViewController *vc = [[MessageViewController alloc] init];
    //                            vc.hidesBottomBarWhenPushed = YES;
    if([GCUser getInstance].userId)
    {
        if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
            static QRCodeReaderViewController *reader = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                reader = [QRCodeReaderViewController new];
            });
//            reader.delegate = self;
            
            [reader setCompletionWithBlock:^(NSString *resultAsString) {
                
            }];
            
            reader.title=@"添加电磁炉";
            [nav pushViewController:reader animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机设备不支持二维码扫描功能,请更换设备操作!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        
        GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
        [nav pushViewController:vc animated:YES];
        //                        [self.navigationController pushViewController:vc animated:YES];
        
    }
}



- (void) conectService
{
    // [[RHSocketConnection getInstance] connectWithHost:KIP port:KPort];
    if (![[RHSocketConnection getInstance] isConnected]) {
//        NSLog(@"conectService!!!!!");
        [[RHSocketConnection getInstance] connectWithHost:KIP port:KPort];
    }
    
  
    
}

- (void) setWifiPage
{
    #define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }

}

- (void)setSVprogressHUD{
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
//    [SVProgressHUD setstatus:nil];
//    [SVProgressHUD setSuccessImage:nil];
//    [SVProgressHUD setErrorImage:nil];
//    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"pop_toast_success"]];
//    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"pop_toast_error"]];
//    [SVProgressHUD setFont:GKFont(14)];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
}



- (void) addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:KNotiLoginSuccess object:nil];
}






#pragma mark -登录成功通知
- (void) loginSuccess:(NSNotification *)noti
{
    
    [self getDeviceListWithShowTip:NO];
    
}
















@end

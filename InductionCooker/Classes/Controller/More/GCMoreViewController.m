//
//  GCMoreViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCMoreViewController.h"

#import "GCSetBasicCellMd.h"
#import "GCSetBasicCell.h"
#import "QRCodeReader.h"
#import "QRCodeReaderViewController.h"
#import "GCBinddinViewController.h"
#import "UIView+NTES.h"
#import "GCWebViewController.h"
#import "GCLoginViewController.h"
#import "GCUpdatePwdViewController.h"
#import "SIAlertView.h"
#import "GCPurviewPhoneVerifyViewController.h"
#import "PermissionsDeviceViewController.h"
#import "WifiConnectView.h"


@interface GCMoreViewController ()<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate>
{
    UIButton * _logButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,strong) NSMutableArray *dataSoucre;


@end

@implementation GCMoreViewController

- (NSMutableArray *)dataSoucre
{
    if (_dataSoucre==nil) {
        _dataSoucre=[NSMutableArray array];
    }
    return _dataSoucre;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getData];
    
    [self createUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_logButton && [GCUser getInstance].userId != nil) {
        [_logButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    
    [self reloadTableView];
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
    GCSetBasicCellMd *model00=[GCSetBasicCellMd createWithTitle:@"添加产品" describe:@"" isDiscover:YES];
    
    GCSetBasicCellMd *unBinding=[GCSetBasicCellMd createWithTitle:@"权限转移" describe:@"" isDiscover:YES];
    
    GCSetBasicCellMd *model10=[GCSetBasicCellMd createWithTitle:@"用户名" describe:@"xxxx" isDiscover:NO];
    
    GCSetBasicCellMd *model11=[GCSetBasicCellMd createWithTitle:@"修改登录密码" describe:@"" isDiscover:YES];
    
    GCSetBasicCellMd *model12=[GCSetBasicCellMd createWithTitle:@"版本" describe:@"v1.0.2" isDiscover:YES];
    
    GCSetBasicCellMd *model13=[GCSetBasicCellMd createWithTitle:@"厂家信息" describe:@"" isDiscover:YES];
    
    
    NSMutableArray *arr0=[NSMutableArray array];
    [arr0 addObject:model00];
    [arr0 addObject:unBinding];
  
    NSArray *arr1=@[model10,model11,model12,model13];
    
    [self.dataSoucre addObject:arr0];
    
    [self.dataSoucre addObject:arr1];
    
    
    
}


- (void) createUI{
    
//    UIView *tabelHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.01)];
//    self.tableView.tableHeaderView=tabelHeadView;
    
    _logButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([GCUser getInstance].userId != nil) {
        [_logButton setTitle:@"退出登录" forState:UIControlStateNormal];
    }else
    {
        [_logButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    
    
    _logButton.frame=CGRectMake(0, 0, self.tableView.width, kScreenHeight*0.075);
    
    _logButton.backgroundColor=[UIColor whiteColor];
    
    [_logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_logButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView.tableFooterView=_logButton;
    
    
    
}


- (void) reloadTableView
{
   

    
    GCSetBasicCellMd *model=self.dataSoucre[1][0];
    
    
    
    model.describeText=[GCUser getInstance].userId==nil?@"未登录":[GCUser getInstance].mobile;
    
    [self.tableView reloadData];
    
    // [self.tableView reloadData];

}


#pragma mark -交互方法
- (void) logoutButtonClick:(UIButton *)button
{
    
    if ([GCUser getInstance].userId==nil) {
        
        GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
//        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"您尚未登录"];
//        [alertView addButtonWithTitle:@"确定"
//                                 type:SIAlertViewButtonTypeCancel
//                              handler:^(SIAlertView *alertView) {
//
//                                  [alertView dismissAnimated:NO];
//
//                              }];
//
//        [alertView show];

        return;
    }
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"您是否需要退出账号?"];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              [alertView dismissAnimated:NO];
                              
                          }];
    
            [alertView addButtonWithTitle:@"确定"
                                     type:SIAlertViewButtonTypeDestructive
                                  handler:^(SIAlertView *alertView) {
    
                                      [alertView dismissAnimated:NO];
                                      
                                      [MQSaveLoadTool preferenceRemoveValueForKey:KPreferenceUserInfo];
    
                                      [[RHSocketConnection getInstance] disconnect];
                                      
                                      NSDictionary *dict=@{@"state":[NSNumber numberWithInteger:(NSInteger)WifiConnectTypeDisconnect]};
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNotiConnectSokectServeState object:nil userInfo:dict];
                                      
                                      [[GCUser getInstance] clearUserInfo];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
                                      
                                      [_logButton setTitle:@"登录" forState:UIControlStateNormal];
                                      
                                      [self reloadTableView];
    
                                  }];
    
    [alertView show];
    
   

    
  
}


#pragma mark -tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSoucre.count;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSoucre[section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GCSetBasicCell *cell=[GCSetBasicCell cellWithTableView:tableView];
    
    cell.cellModel=self.dataSoucre[indexPath.section][indexPath.row];
    
    
    return  cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  kScreenHeight *0.075;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 0:
            {
                if([GCUser getInstance].userId)
                {
                    
                    
                    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
                        static QRCodeReaderViewController *reader = nil;
                        static dispatch_once_t onceToken;
                        
                        dispatch_once(&onceToken, ^{
                            reader = [QRCodeReaderViewController new];
                        });
                        reader.delegate = self;
                        
                        [reader setCompletionWithBlock:^(NSString *resultAsString) {
                            
                            
                        }];
                        
                        reader.title=@"添加电磁炉";
                        
                        [self.navigationController pushViewController:reader animated:YES ];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机设备不支持二维码扫描功能,请更换设备操作!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        
                        [alert show];
                        
                        
                    }
                    
                    
                    
                }else{
                    
                    GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }
            }
                break;
                
            case 1:
            {
                
                if([GCUser getInstance].userId)
                {
                    if([GCUser getInstance].deviceList.count>0)
                    {
                       
                        PermissionsDeviceViewController *vc=[[PermissionsDeviceViewController alloc] initWithNibName:@"PermissionsDeviceViewController" bundle:nil];
                        
                        
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        
                        
                    }else{
                        
                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@"您尚未绑定和一电磁炉,无法进行本项操作!"];
                        [alertView addButtonWithTitle:@"确定"
                                                 type:SIAlertViewButtonTypeCancel
                                              handler:^(SIAlertView *alertView) {
                                                  
                                                  [alertView dismissAnimated:NO];
                                                  
                                              }];
                        
                        [alertView show];
                    }
                    
                    
                }else{
                    
                    GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
    }else{
        
        
        
        switch (indexPath.row) {
            case 0:
                
            {
                if ([GCUser getInstance].userId==nil) {
                    GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
            }
                
                break;
                
            case 1:
            {
                
                if ([GCUser getInstance].userId) {
                    
                    GCUpdatePwdViewController *vc=[[GCUpdatePwdViewController alloc] initWithNibName:@"GCUpdatePwdViewController" bundle:nil];
                    vc.title=@"修改密码";
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    GCLoginViewController *vc=[[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
            }
                
                break;
                
            case 2:
            {
                  NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%92%8C%E4%B8%80%E7%94%B5%E7%A3%81%E7%82%89/id1276466874?mt=8"];
                 [[UIApplication sharedApplication] openURL:url];
                
            }
                break;
                
            case 3:
            {
                GCWebViewController *vc=[[GCWebViewController alloc] init];
                vc.url=@"http://www.zhuhaiheyi.com/";
                vc.title=@"厂家信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
                
                
            default:
                break;
        }
        
        
    }
    
}



#pragma mark -QRCodeReaderDelegate
-(void)readerDidCancel:(QRCodeReaderViewController *)reader
{
     [reader dismissViewControllerAnimated:YES completion:NULL];
}

-(void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    
}

























@end

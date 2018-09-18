//
//  PermissionsDeviceViewController.m
//  InductionCooker
//
//  Created by csl on 2017/11/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "PermissionsDeviceViewController.h"
#import "PermissionsDeviceCell.h"
#import "GCDevice.h"
#import "MQBarButtonItemTool.h"
#import "GCPurviewPhoneVerifyViewController.h"

@interface PermissionsDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath * _indexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)  NSMutableArray *dataSoucre;
@property (nonatomic,strong)  MQHudTool *hud;

@end

@implementation PermissionsDeviceViewController

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

#pragma mark -页面逻辑方法
- (void) getData{
    self.dataSoucre=[GCUser getInstance].deviceList;
}


- (void) createUI{
    
    self.title=@"权限转移";
//    self.tableView.tableHeaderView.tintColor = [UIColor grayColor];
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"返回"];
//    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"编辑"];
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (self.editing) {
        self.editButtonItem.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
    } else {
        self.editButtonItem.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark -用户交互方法
//- (void) rightButtonClick
//{
//    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
//        self.navigationItem.rightBarButtonItem.title = @"取消";
////        [[MQBarButtonItemTool setUpButtonWithTitle:<#(NSString *)#> action:<#(SEL)#> vc:<#(UIViewController *)#>]
////        [self.tableView setEditing:YES animated:YES];
//         [self.tableView setAllowsSelectionDuringEditing:true];
//    }else{
//        self.navigationItem.rightBarButtonItem.title = @"编辑";
//        [self.tableView setEditing:NO animated:YES];
//
//    }
//}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoucre.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PermissionsDeviceCell *cell=[PermissionsDeviceCell cellWithTableView:tableView];
    
    cell.cellModel=self.dataSoucre[indexPath.row];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GCPurviewPhoneVerifyViewController *vc=[[GCPurviewPhoneVerifyViewController alloc] initWithNibName:@"GCPurviewPhoneVerifyViewController" bundle:nil];
    
    vc.device=self.dataSoucre[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"向左滑动删除";
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    
//    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 150);
    
//    header.contentView.backgroundColor = [UIColor yellowColor];
//    header.centerX = self.tableView.centerX;
//    header.frame = CGRectMake(KScreenWidth/2-CGRectGetWidth(header.bounds)/2, 0, KScreenWidth, 22);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KScreenScaleValue(55);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KScreenScaleValue(22);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array;
    
//    if ([self.editButtonItem.title isEqualToString:@"编辑"]) {
//        return self.tableView.indexPathsForSelectedRows;;
//    }
//
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        _indexPath = indexPath;
        [self makeSure];
    }];

    array = @[action];
    
    return array;
}

//删除的二次确认
-(void)makeSure
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"确认删除？"];
    
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              [alertView dismissAnimated:NO];
                              
                          }];
    
    [alertView addButtonWithTitle:@"确定"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              [alertView dismissAnimated:NO];
                              [self deleteDeviceWithIndexPath];
                              
                          }];
    
    [alertView show];
}

-(void)deleteDeviceWithIndexPath
{
    [self.hud addNormHudWithSupView:self.view title:@"正在删除..."];
    
    GCDevice * device = self.dataSoucre[_indexPath.row];
    
    NSDictionary * dic = @{@"mobile":[GCUser getInstance].mobile,@"token":[GCUser getInstance].token,@"devcode":device.deviceId};
    [GCHttpDataTool delDeviceRefWithDict:dic success:^(id responseObject) {
        
        [self.hud hide];
        NSLog(@" 删除结果 == %@",responseObject);
        if (responseObject[@"result"] && [responseObject[@"result"] intValue] == 0) {
            
            [[GCUser getInstance].deviceList removeObject:device];
            
            if ([GCUser getInstance].device.deviceId == device.deviceId) {
                if ([GCUser getInstance].deviceList.count > 0) {
                    [GCUser getInstance].device = [GCUser getInstance].deviceList[0];
                }else
                {
                    [GCUser getInstance].device = nil;
                }
            }
            
            [self getData];
            
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
        }
        
    } failure:^(MQError *error) {
        [self.hud hudUpdataTitile:@"删除失败" hideTime:1.2];
    }];
}

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"编辑";
}

//设置进入编辑状态时，Cell不会缩进

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end

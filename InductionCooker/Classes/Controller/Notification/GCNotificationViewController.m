//
//  GCNotificationViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCNotificationViewController.h"

#import "GCNotificationCellMd.h"
#import "GCNotificationCell.h"
#import "GCUser.h"
#import "GCDataBasicManager.h"
#import "NSDate+TimeCategory.h"

@interface GCNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath * _indexPath;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)  NSMutableArray *dataSoucre;

@property (nonatomic,assign) int isShow;

@end

@implementation GCNotificationViewController

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
//    self.tableView.scrollEnabled = false;
    [self addObserver];
    
    [self getData];
    
    [self createUI];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isShow=YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isShow=NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -页面逻辑方法
- (void) getData{
    
   // [GCUser getInstance].device.error=100;
//    NSMutableArray *array  = [NSMutableArray array];;
//    NSString *state=@"1";
//    NSString *date=@"2018.09.06 18:30:40";
//    NSString *text=@"有人在限定时间内打开电磁炉！";
//    NSString *msgId=@"id";
//    NSDictionary *dict=@{
//                         @"msgId":msgId,
//                         @"notiState":state,
//                         @"text":text,
//                         @"date":date
//                         };
//    GCNotificationCellMd *model = [GCNotificationCellMd createModelWithDict:dict];
//
//    [array addObject:model];
//    NSArray *dataSoucre = [NSArray new];
//    dataSoucre = [array mutableCopy];
    
    
    NSArray *dataSoucre=[[GCDataBasicManager shareManager] selecteFromTable:KErrorTableName name:nil];
    
    
    self.dataSoucre = (NSMutableArray *)[[dataSoucre reverseObjectEnumerator] allObjects];
    
    
    
    
}


- (void) createUI{
    
//    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"删除"];
   
    
//    [[GCDataBasicManager shareManager] deleteOneDataFromTable:KErrorTableName model:self.dataSoucre[0]];
}
- (void) rightButtonClick
{
//    GCNotificationCellMd *model = self.dataSoucre[0];
//    if (self.dataSoucre.count>1) {
        GCNotificationCellMd *model = self.dataSoucre[0];
    NSLog(@"model.msgId = %d ",model.msgId);
    NSLog(@"model.notiState = %d ",model.notiState);
    NSLog(@"model.date = %@ ",model.date);
    NSLog(@"model.text = %@ ",model.text);
    
    
    
    
        [[GCDataBasicManager shareManager] deleteOneDataFromTable:KErrorTableName model:model];
//        [SVProgressHUD showInfoWithStatus:@"删除成功！"];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"删除失败"];
//    }
}





- (void) addObserver{
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:KNotiError object:nil];
    
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
    GCNotificationCell *cell=[GCNotificationCell cellWithTableView:tableView];
    
    cell.cellModel=self.dataSoucre[indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
//设置提示头部标签
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.dataSoucre.count != 0) {
        return @"向左滑动删除！";
    }else{
        return @"当前暂无通知消息！";
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
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
//    [self.hud addNormHudWithSupView:self.view title:@"正在删除..."];
//    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld   %ld  正在删除！",(long)_indexPath.section,(long)_indexPath.row]];
//    GCDevice * device = self.dataSoucre[_indexPath.row];
//    [self getData];
//    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
//                                 [NSIndexPath indexPathForRow:1 inSection:0],
//                                 [NSIndexPath indexPathForRow:2 inSection:0],
//                                 nil];
    //删除库内存储！
//    if (self.dataSoucre.count>1) {
        GCNotificationCellMd *model = self.dataSoucre[_indexPath.row];
        [[GCDataBasicManager shareManager] deleteOneDataFromTable:KErrorTableName model:model];
//        [SVProgressHUD showInfoWithStatus:@"删除成功！"];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"删除失败"];
//    }
    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
//    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.dataSoucre removeObjectAtIndex:_indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self.tableView reloadData];
//    NSDictionary * dic = @{@"mobile":[GCUser getInstance].mobile,@"token":[GCUser getInstance].token,@"devcode":device.deviceId};
//    [GCHttpDataTool delDeviceRefWithDict:dic success:^(id responseObject) {
//        [self.hud hide];
//        NSLog(@" 删除结果 == %@",responseObject);
//        if (responseObject[@"result"] && [responseObject[@"result"] intValue] == 0) {
//
//            [[GCUser getInstance].deviceList removeObject:device];
//
//            if ([GCUser getInstance].device.deviceId == device.deviceId) {
//                if ([GCUser getInstance].deviceList.count > 0) {
//                    [GCUser getInstance].device = [GCUser getInstance].deviceList[0];
//                }else
//                {
//                    [GCUser getInstance].device = nil;
//                }
//            }
//
//            [self getData];
//
//            [self.tableView reloadData];
//
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];
//        }
//
//    } failure:^(MQError *error) {
//        [self.hud hudUpdataTitile:@"删除失败" hideTime:1.2];
//    }];
    
//    [SVProgressHUD showInfoWithStatus:@"删除成功！"];
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight*0.095;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCNotificationCell *cell=[GCNotificationCell cellWithTableView:tableView];
    cell.cellModel = self.dataSoucre[indexPath.row];
//    cell.cellModel.text
//    [SVProgressHUD showErrorWithStatus:self.dataSoucre[indexPath.row]];
//    for () {
//        <#statements#>
//    }
//    NSLog(@"self.dataSoucre = %@",cell.cellModel.text);
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *error = cell.cellModel.text;
    
    [GCDiscoverView showWithTip:error];
//    [GCDiscoverView showInSupview:self.tableView tip:error];
    
}


#pragma mark -监听数据变化
- (void) receiveNoti:(NSNotification *)noti
{
    
    if (self.isShow) {
        [GCUser getInstance].device.error=0;
    }
    
    NSDictionary *dict=[noti userInfo];
    
    GCNotificationCellMd *model=dict[@"error"];
    
    [self.dataSoucre insertObject:model atIndex:0];
    
    [self.tableView beginUpdates];
    
    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    
    
    [self.tableView endUpdates];
    
}


@end

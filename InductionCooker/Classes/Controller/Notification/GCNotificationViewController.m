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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight*0.095;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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



































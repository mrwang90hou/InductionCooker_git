//
//  GCDeviceListViewController.m
//  InductionCooker
//
//  Created by csl on 2017/11/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCDeviceListViewController.h"

#import "GSPortableDeviceCell.h"
#import "UIView+NTES.h"

@interface GCDeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;

@end




@implementation GCDeviceListViewController

-(void)setDataSoucre:(NSMutableArray *)dataSoucre
{
    _dataSoucre=dataSoucre;
    
    if(_tableView)
    {
        [_tableView reloadData];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    
    
    
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
}


- (void) createUI{
    
    
    self.view.backgroundColor=[UIColor clearColor];
    
    
    
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height*0.45) style:UITableViewStylePlain];
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource=self;
    
    tableView.delegate=self;
    
    [self.view addSubview:tableView];
    
    self.tableView=tableView;
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KScreenScaleValue(44))];
    
    UILabel *label=[[UILabel alloc] init];
    
    [headerView addSubview:label];
    
    label.frame=CGRectMake(0, 0, headerView.width, headerView.height);
    
    label.text=@"产品切换";
    
    label.textAlignment=NSTextAlignmentCenter;
    
    UIView *lineView=[[UIView alloc] init];
    [headerView addSubview:lineView];
    lineView.frame=CGRectMake(0, headerView.height-1, headerView.width, 1);
    lineView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    self.tableView.tableHeaderView=headerView;
    
    
    
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    GSPortableDeviceCell *cell=[GSPortableDeviceCell cellWithTableView:tableView];
    
    cell.cellModel=self.dataSoucre[indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(portableDeviceSelected:)])
    {
        [self.delegate portableDeviceSelected:self.dataSoucre[indexPath.row]];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(portableDeviceSelected:)])
    {
        [self.delegate portableDeviceSelected:nil];
    }
}


@end

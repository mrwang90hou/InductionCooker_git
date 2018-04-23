//
//  OneViewController.m
//  InductionCooker
//
//  Created by CMQ on 2018/3/14.
//  Copyright © 2018年 csl. All rights reserved.
//

#import "OneViewController.h"

#import "TwoViewController.h"

@interface OneViewController ()

@property (nonatomic,weak) UIBarButtonItem *rightItem;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
   
    
    self.rightItem= [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"下一步"];

    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    
    
    
    self.title=[NSString stringWithFormat:@"%d",++self.count];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self.rightItem setTintColor:[UIColor redColor]];
    

    
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    OneViewController *vc=[[OneViewController alloc] init];
    
    vc.count=self.count;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  GCReservationViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/16.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCReservationViewController.h"

#import "MQBarButtonItemTool.h"
#import "GCReservationModenView.h"
#import "Masonry.h"
#import "GCModen.h"
#import "GCReservationTimeViewController.h"
#import "GCReservationStartViewController.h"


typedef NS_ENUM(NSInteger, ReservationStatus) {
    ReservationStatusModen=0,
    ReservationStatusStartTime=1,
    ReservationStatusWorkTime=2
};


@interface GCReservationViewController ()

@property (nonatomic,assign)ReservationStatus reservationStatus;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) GCReservationModenView *reservationModenView;


@end

@implementation GCReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getData];
    
    [self initData];
    
    [self createUI];
    
}


#pragma mark -页面逻辑方法
- (void) getData{
    
    
}

- (void) initData{
    
    self.restorationClass=ReservationStatusModen;
    
}

- (void) createUI{
    
    
    GCReservationModenView *reservationModenView=[GCReservationModenView loadViewFromXibWithiType:self.state];
    [self.contentView addSubview:reservationModenView];
    [reservationModenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        
    }];
    
    self.reservationModenView=reservationModenView;
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
    
    [MQBarButtonItemTool rightBarButttonItemWithViewController:self title:@"下一步"];

    
    
}

#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
    
//    GCReservationStartViewController *vc=[[GCReservationStartViewController alloc] initWithNibName:@"GCReservationStartViewController" bundle:nil];
//
//    vc.moden=self.reservationModenView.selModen;
//    vc.title=@"预约开机时间";
//    [self.navigationController pushViewController:vc animated:YES];
    
    
   // [self.navigationController pushViewController:vc animated:YES];

    
    
    //if (self.reservationModenView.selModen.aotuWork) {
        
        GCReservationStartViewController *vc=[[GCReservationStartViewController alloc] initWithNibName:@"GCReservationStartViewController" bundle:nil];
        
        vc.moden=self.reservationModenView.selModen;
        vc.title=@"预约开机时间";
        
        [self.navigationController pushViewController:vc animated:YES];
//
//    }else{
//
//
//        GCReservationTimeViewController *vc=[[GCReservationTimeViewController alloc] initWithNibName:@"GCReservationTimeViewController" bundle:nil];
//        vc.moden=self.reservationModenView.selModen;
//        vc.deviceId=self.reservationModenView.selModen.modenId<100?0:1;
//
//
//        vc.title=@"设置定时";
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    
}

- (void) leftButtonClick
{
    switch (self.reservationStatus) {
        case ReservationStatusModen:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
    
    
    
}







@end

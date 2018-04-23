//
//  GCNotificationCell.h
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCNotificationCellMd.h"

@interface GCNotificationCell : UITableViewCell


@property (nonatomic,strong) GCNotificationCellMd *cellModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  PermissionsDeviceCell.h
//  InductionCooker
//
//  Created by csl on 2017/11/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDevice.h"

@interface PermissionsDeviceCell : UITableViewCell

@property (nonatomic,strong) GCDevice* cellModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end


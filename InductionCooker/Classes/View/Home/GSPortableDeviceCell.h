//
//  GSPortableDeviceCell.h
//  goockr_cat_eye
//
//  Created by csl on 2017/8/25.
//  Copyright © 2017年 蔡敏权. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDevice.h"

@interface GSPortableDeviceCell : UITableViewCell


@property (nonatomic,strong) GCDevice *cellModel;



+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

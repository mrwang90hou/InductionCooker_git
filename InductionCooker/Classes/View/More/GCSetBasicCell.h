//
//  GCSetBasicCell.h
//  goockr_heart
//
//  Created by csl on 16/10/5.
//  Copyright © 2016年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCSetBasicCellMd.h"

@interface GCSetBasicCell : UITableViewCell

@property (nonatomic,strong) GCSetBasicCellMd* cellModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setCellTypeWithLabelColor:(UIColor *)color;

@end

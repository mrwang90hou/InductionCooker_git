//
//  PermissionsDeviceCell.m
//  InductionCooker
//
//  Created by csl on 2017/11/23.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "PermissionsDeviceCell.h"

@interface PermissionsDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;

@end

@implementation PermissionsDeviceCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *Id=@"PermissionsDeviceCell";
    
    PermissionsDeviceCell *cell=[tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PermissionsDeviceCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


- (void)setCellModel:(GCDevice *)cellModel
{
    self.nameLabel.text=cellModel.deviceName;
    
    self.deviceIdLabel.text=[NSString stringWithFormat:@"%@%@",@"ID:",cellModel.deviceId];
    
    _cellModel=cellModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

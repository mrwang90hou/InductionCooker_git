//
//  GSPortableDeviceCell.m
//  goockr_cat_eye
//
//  Created by csl on 2017/8/25.
//  Copyright © 2017年 蔡敏权. All rights reserved.
//

#import "GSPortableDeviceCell.h"


@interface GSPortableDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;


@end

@implementation GSPortableDeviceCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *Id=@"GSPortableDeviceCell";
    
    GSPortableDeviceCell *cell=[tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"GSPortableDeviceCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


- (void)setCellModel:(GCDevice *)cellModel
{
    _cellModel=cellModel;
    
    _deviceLabel.text=cellModel.deviceId;
    
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

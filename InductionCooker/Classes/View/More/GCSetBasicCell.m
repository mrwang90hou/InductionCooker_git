//
//  GCSetBasicCell.m
//  goockr_heart
//
//  Created by csl on 16/10/5.
//  Copyright © 2016年 csl. All rights reserved.
//

#import "GCSetBasicCell.h"

@interface GCSetBasicCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *discoverImageView;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;


@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation GCSetBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellModel:(GCSetBasicCellMd *)cellModel
{
    _cellModel=cellModel;
    self.titleLabel.text=cellModel.title;
    
    self.describeLabel.text=cellModel.describeText;
    
    [self.discoverImageView setHidden:!cellModel.isDiscover];
    
    [self.switchButton setHidden:!cellModel.isSwitch];
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{

    static NSString *Id=@"GCSetBasicCell";
    
    GCSetBasicCell *cell=[tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"GCSetBasicCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (IBAction)switchButtonClick:(id)sender {
    
    
    
}

- (void)setCellTypeWithLabelColor:(UIColor *)color
{
    self.titleLabel.textColor=color;
    //self.describeLabel.textColor=color;
}

@end

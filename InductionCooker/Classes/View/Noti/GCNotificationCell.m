//
//  GCNotificationCell.m
//  InductionCooker
//
//  Created by csl on 2017/6/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCNotificationCell.h"

@interface GCNotificationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GCNotificationCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *Id=@"GCNotificationCell";
    
    GCNotificationCell *cell=[tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"GCNotificationCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setCellModel:(GCNotificationCellMd *)cellModel
{
    _cellModel=cellModel;
    
//    switch (cellModel.notiState) {
//        case 0:
//            
//            self.headImageView.image=[UIImage imageNamed:@"notice_icon_avatar_default"];
//            break;
//        case 1:
//            
//            self.headImageView.image=[UIImage imageNamed:@"notice_icon_avatar_default2"];
//            break;
//    }

    
    NSString *imageName=[NSString stringWithFormat:@"notice_icon_avatar_%d",cellModel.notiState];
    self.headImageView.image=[UIImage imageNamed:imageName];
    
    
    _titleLabel.text=cellModel.text;
    
    _dateLabel.text=cellModel.date;
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font=[UIFont systemFontOfSize:KScreenScaleValue(18)];
    
    self.dateLabel.font=[UIFont systemFontOfSize:KScreenScaleValue(17)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

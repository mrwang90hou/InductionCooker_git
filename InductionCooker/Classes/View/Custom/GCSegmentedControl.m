//
//  GCSegmentedControl.m
//  InductionCooker
//
//  Created by csl on 2017/6/9.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCSegmentedControl.h"

#import "GCImageRightButton.h"

@interface GCSegmentedControl ()

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;



@property (nonatomic, strong) NSMutableArray *childrenButtons;

@property (weak, nonatomic) IBOutlet UILabel *leftTipLabel;


@property (weak, nonatomic) IBOutlet UILabel *leftStallLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightStallLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightTipLabel;




@end

@implementation GCSegmentedControl

//- (NSArray *)labels
//{
//    if (_labels==nil) {
//        _labels=[NSArray array];
//    }
//    return _labels;
//}


-(NSMutableArray *)childrenButtons
{
    if (_childrenButtons==nil) {
        _childrenButtons=[NSMutableArray array];
    }
    return _childrenButtons;
}


+ (instancetype)loadViewFromXib
{
    GCSegmentedControl *view=[[[NSBundle mainBundle] loadNibNamed:@"GCSegmentedControl" owner:self options:nil]lastObject];
    
    return view;
    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self.childrenButtons addObject:self.leftButton];
    [self.childrenButtons addObject:self.rightButton];
    
    
    self.selectIndex=0;
    
    
   // [self setLeftButtonTitle:@"L"];
    
  //  [self setRightButtonTitle:@"R"];

    
   
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    
    UIButton *oldSelectBt=self.childrenButtons[_selectIndex];

    oldSelectBt.selected=NO;
    
    UIButton *nowSelectBt=self.childrenButtons[selectIndex];
    nowSelectBt.selected=YES;
    
    _selectIndex=selectIndex;
    
    if (selectIndex==0) {
        
        self.leftTipLabel.textColor=[UIColor whiteColor];
        self.leftStallLabel.textColor=[UIColor whiteColor];
        self.rightTipLabel.textColor=UIColorFromRGB(0xff8212);
        self.rightStallLabel.textColor=UIColorFromRGB(0xff8212);
        
    }else
    {

        self.rightTipLabel.textColor=[UIColor whiteColor];
        self.rightStallLabel.textColor=[UIColor whiteColor];
        self.leftTipLabel.textColor=UIColorFromRGB(0xff8212);
        self.leftStallLabel.textColor=UIColorFromRGB(0xff8212);

        
    }
    
}


- (void) setLeftButtonTitle:(NSString*)leftTile
{
    
    
    
    self.leftStallLabel.text=leftTile;
    
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:leftTile];
//    
//    [AttributedStr addAttribute:NSFontAttributeName
//     
//                          value:[UIFont systemFontOfSize:20.0]
//     
//                          range:NSMakeRange(0, 1)];
//    
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//     
//                          value:UIColorFromRGB(0xff8212)
//     
//                          range:NSMakeRange(0, leftTile.length)];
//    
//    self.leftButton.titleLabel.attributedText = AttributedStr;
//    [self.leftButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//    
//    
//    NSMutableAttributedString *selAttributedStr = [[NSMutableAttributedString alloc]initWithString:leftTile];
//    
//    [selAttributedStr addAttribute:NSFontAttributeName
//     
//                          value:[UIFont systemFontOfSize:20.0]
//     
//                          range:NSMakeRange(0, 1)];
//    
//    [selAttributedStr addAttribute:NSForegroundColorAttributeName
//     
//                          value:[UIColor whiteColor]
//     
//                          range:NSMakeRange(0, leftTile.length)];
//    
//    self.leftButton.titleLabel.attributedText = AttributedStr;
//    
//    [self.leftButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//
//    [self.leftButton setAttributedTitle:selAttributedStr forState:UIControlStateSelected];

    
    
    
    //self.leftButton.titleLabel.text=@"123";
    
}

-(void) setRightButtonTitle:(NSString*)rightTitle
{
    
    self.rightStallLabel.text=rightTitle;
    
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:rightTitle];
//    
//    [AttributedStr addAttribute:NSFontAttributeName
//     
//                          value:[UIFont systemFontOfSize:20.0]
//     
//                          range:NSMakeRange(0, 1)];
//    
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//     
//                          value:UIColorFromRGB(0xff8212)
//     
//                          range:NSMakeRange(0, rightTitle.length)];
//    
//    self.rightButton.titleLabel.attributedText = AttributedStr;
//    [self.rightButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//    
//    
//    NSMutableAttributedString *selAttributedStr = [[NSMutableAttributedString alloc]initWithString:rightTitle];
//    
//    [selAttributedStr addAttribute:NSFontAttributeName
//     
//                             value:[UIFont systemFontOfSize:20.0]
//     
//                             range:NSMakeRange(0, 1)];
//    
//    [selAttributedStr addAttribute:NSForegroundColorAttributeName
//     
//                             value:[UIColor whiteColor]
//     
//                             range:NSMakeRange(0, rightTitle.length)];
//    
//    self.rightButton.titleLabel.attributedText = AttributedStr;
//    
//    [self.rightButton setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//    
//    [self.rightButton setAttributedTitle:selAttributedStr forState:UIControlStateSelected];
}


- (IBAction)buttonClick:(id)sender {
    
    
    GCImageRightButton *button=sender;
    
    self.selectIndex=[self.childrenButtons indexOfObject:button];
    

    //[button setImageVisit];
    
    
    if ([_delegate respondsToSelector:@selector(segmentedValueChange:)]) {
        
        [_delegate segmentedValueChange:self.selectIndex];
    }
    

}


- (void)itemIndex:(int)index isWarm:(BOOL)warm
{

    GCImageRightButton *selectBt=self.childrenButtons[index];
    
    [selectBt setImageVisit:warm];
    
}


- (void)updateItemWithIndex:(int)index title:(NSString *)title
{
    
    if (index==0) {
       
        [GCUser getInstance].device.leftDevice.selModen.aotuWork? [self setLeftButtonTitle:@"Auto"]: [self setLeftButtonTitle:title];
       // [self setLeftButtonTitle:title];
    }else{
        
          [GCUser getInstance].device.rightDevice.selModen.aotuWork? [self setRightButtonTitle:@"Auto"]: [self setRightButtonTitle:title];
        
       // [self setRightButtonTitle:title];
    }
    
}


























@end

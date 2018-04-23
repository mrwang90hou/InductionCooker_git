//
//  GCLinkView.h
//  InductionCooker
//
//  Created by csl on 2017/7/8.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

// 在定义类的前面加上IB_DESIGNABLE宏,确保该控件在xib或storyboard上可以实时渲染
IB_DESIGNABLE
@interface GCLinkView : UIView


- (void) linkStateChange:(DeviceLinkState) state;

@end

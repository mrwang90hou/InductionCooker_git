//
//  GCInputSequenceCodeView.h
//  InductionCooker
//
//  Created by csl on 2017/6/5.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCInputSequenceCodeViewDelegate <NSObject>

- (void)inputSequenceCode:(NSString *)code;


@end

@interface GCInputSequenceCodeView : UIView

+ (instancetype)createView;

@property(nonatomic,weak)      id <GCInputSequenceCodeViewDelegate> delegate;



@end

//
//  GCInputSequenceCodeView.m
//  InductionCooker
//
//  Created by csl on 2017/6/5.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCInputSequenceCodeView.h"

@interface GCInputSequenceCodeView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UITextField *sequenceCodeTextFeild;



@end

@implementation GCInputSequenceCodeView

+ (instancetype)createView
{
    GCInputSequenceCodeView *view=[[[NSBundle mainBundle] loadNibNamed:@"GCInputSequenceCodeView" owner:self options:nil]lastObject];

    return view;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        
       // self.sequenceCodeTextFeild.delegate=self;
        self.backgroundColor=UIColorFromRGB(0xf0f0f0);
    }
    return self;
}


- (IBAction)addButtonClick:(id)sender {
    
    if (self.sequenceCodeTextFeild.text.length==0) {
        return;
    }
    
    [self.sequenceCodeTextFeild endEditing:YES];
 
    
    
    if ([self.delegate respondsToSelector:@selector(inputSequenceCode:)]) {
        
        [self.delegate inputSequenceCode:self.sequenceCodeTextFeild.text];
        
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.sequenceCodeTextFeild endEditing:YES];
    
    return NO;
}



@end

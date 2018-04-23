//
//  MyThread.m
//  Threat
//
//  Created by csl on 2017/8/10.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "MyThread.h"

@interface MyThread ()


@property (nonatomic,strong) NSThread *thread;

@property (nonatomic,assign) BOOL isRun;

@end

@implementation MyThread

-(instancetype)init
{
    if (self=[super init]) {
        
        
    }
    return self;
    
    
}

- (void) run{
    
    self.isRun=YES;
    
   // self.thread=[[NSThread alloc] init];
    // 创建
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(working) object:nil];
    
    // 启动
    [self.thread start];
}

- (void) stop
{
    self.isRun=NO;
}

- (void)working
{
    while (self.isRun) {
       
        if (self.running) {
            self.running();
        }

        [NSThread sleepForTimeInterval:0.2];
    }

    
}





@end

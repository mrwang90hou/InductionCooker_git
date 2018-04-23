//
//  MyThread.h
//  Threat
//
//  Created by csl on 2017/8/10.
//  Copyright © 2017年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ThreadCallBack)();

@interface MyThread : NSObject

- (void) run;

- (void) stop;

@property (nonatomic,strong) ThreadCallBack running;

@end

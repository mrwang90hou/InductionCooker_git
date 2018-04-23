//
//  TXXRHSocketConfig.h
//  iOSMp3Recorder
//
//  Created by csl on 2017/2/18.
//  Copyright © 2017年 xiaoxuan Tang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RHSocketConnectionDelegate <NSObject>

- (void)didDisconnectWithError:(NSError *)error;
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)didReceiveData:(NSData *)data tag:(long)tag;

@end

@interface TXXRHSocketConfig : NSObject

@property (nonatomic, weak) id<RHSocketConnectionDelegate> delegate;

- (void)connectWithHost:(NSString *)hostName port:(int)port;
- (void)disconnect;

- (BOOL)isConnected;
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag;

@end

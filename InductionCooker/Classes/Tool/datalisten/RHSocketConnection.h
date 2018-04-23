#import <Foundation/Foundation.h>
#import "RHSocketConfig.h"

@protocol RHSocketConnectionDelegate <NSObject>

- (void)didDisconnectWithError:(NSError *)error;
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)didReceiveData:(NSData *)data tag:(long)tag;

@end

@interface RHSocketConnection : NSObject

@property (nonatomic, weak) id<RHSocketConnectionDelegate> delegate;

@property (nonatomic,strong) ReceiveBlock receiveBlock;

@property (nonatomic,assign) BOOL isDeviceDisconnect;

+ (instancetype) getInstance;

- (void) connectWithCount:(int) count result:(void (^)(BOOL result))block;

- (BOOL)connectWithHost:(NSString *)hostName port:(int)port;
- (void)disconnect;

- (BOOL)isConnected;
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

//- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(void (^)(NSData *data,int tag))block;

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag;

//- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(void (^)(NSData *data,int tag))block;


- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(ReceiveBlock)block;


@end

#import <Foundation/Foundation.h>
#import "RHSocketConfig.h"

@protocol RHSocketConnectionDelegate <NSObject>

/**
 没有断开连接错误
 @param error 传入错误参数
 */
- (void)didDisconnectWithError:(NSError *)error;
/**
 连接到主机+端口
 
 @param host 主机
 @param port 端口
 */
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;
/**
 收到了数据
 
 @param data 收到的数据
 @param tag tag值
 */
- (void)didReceiveData:(NSData *)data tag:(long)tag;

@end

@interface RHSocketConnection : NSObject

@property (nonatomic, weak) id<RHSocketConnectionDelegate> delegate;

@property (nonatomic,strong) ReceiveBlock receiveBlock;

@property (nonatomic,assign) BOOL isDeviceDisconnect;

+ (instancetype) getInstance;           //获取实例
/**
 连接长度
 
 @param count 传入字典
 @param block 请求成功的回调
 */
- (void)connectWithCount:(int) count result:(void (^)(BOOL result))block;
/**
 连接主机+端口
 
 @param hostName 主机
 @param port 端口
 */
- (BOOL)connectWithHost:(NSString *)hostName port:(int)port;

- (void)disconnect;

- (BOOL)isConnected;
/**
 读取数据时间超时
 
 @param timeout 读取数据的时间限制
 @param tag tag值
 */
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

//- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(void (^)(NSData *data,int tag))block;
/**
 写入数据
 
 @param data 传入数据
 @param timeout 请求时间
 @param tag  tag值
 */
- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag;

//- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(void (^)(NSData *data,int tag))block;

/**
 写入数据
 
 @param data 传入数据
 @param timeout 请求时间
 @param tag tag值
 @param block  请求成功的回调ReceiveBlock
 */
- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(ReceiveBlock)block;


@end

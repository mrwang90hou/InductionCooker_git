




#import "RHSocketConnection.h"
#import "GCDAsyncSocket.h"
#import "MQHudTool.h"
#import "GCAgreementHelper.h"
#import "TypeConversionHelper.h"
#import "SIAlertView.h"
#import "WifiHelper.h"
#import "GCSokectDataDeal.h"
#import "NSDictionary+Category.h"
#import "MyThread.h"
#import "WifiConnectView.h"



#define KMaxConnectCount   3

#define KDataKey                @"data"
#define KTagKey                 @"tag"
#define KTimeOutKey             @"timeout"

@interface RHSocketConnection () <GCDAsyncSocketDelegate,UIAlertViewDelegate>
{
    GCDAsyncSocket *_asyncSocket;
}

@property (nonatomic,strong) MQHudTool *hud;

@property (nonatomic,strong) NSMutableData *buffer;

@property (nonatomic,assign) int connectCount;

@property (nonatomic,strong) MyThread *heartBeatThread;

@property (nonatomic,strong) NSMutableArray *dataQueue;

@property (nonatomic,assign) int writeCount;

//


@property (nonatomic,weak) UITextView *textView;

@end

@implementation RHSocketConnection

- (NSMutableData *)buffer
{
    if (_buffer==nil) {
        _buffer=[NSMutableData data];
    }
    return _buffer;
}


-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


static  RHSocketConnection *tool;

+ (instancetype) getInstance
{
    
    if (tool==nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            tool=[[RHSocketConnection alloc] init];
            
        });
        
    }
    return tool;
    
}

+ (void)connectWithCountOut:(int)count
{
    
}

- (instancetype)init
{
    if (self = [super init]) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        _dataQueue=[NSMutableArray array];
        
        _writeCount=0;
        
        _isDeviceDisconnect=YES;
        
       // [self debugView];
        
    }
    return self;
}


- (void) debugView
{
    
    UITextView *textView=[[UITextView alloc] init];
    
    textView.frame=CGRectMake(0, kScreenHeight-350, KScreenWidth, 300);
    
    [myWindow addSubview:textView];
    
    self.textView=textView;
    
    self.textView.editable=NO;

    textView.hidden=YES;
    
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [bt setTitle:@"Hiden" forState:UIControlStateNormal];
    
    bt.frame=CGRectMake(KScreenWidth-40, 40, 40, 40);
    
    bt.backgroundColor=[UIColor blackColor];
    
    [myWindow addSubview:bt];
    
    [bt addTarget:self action:@selector(debugClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cearBt=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [cearBt setTitle:@"clear" forState:UIControlStateNormal];
    
    cearBt.frame=CGRectMake(KScreenWidth-100, 40, 40, 40);
    
    cearBt.backgroundColor=[UIColor blackColor];
    
    [myWindow addSubview:cearBt];
    
    [cearBt addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
}

- (void)debugClick:(UIButton *)bt
{
    bt.selected=!bt.selected;
    self.textView.hidden=bt.selected;
}

- (void)clearClick:(UIButton *)bt
{
   
    self.textView.text=@"";
    
}



- (void)connectWithCount:(int)count result:(void (^)(BOOL))block
{
    BOOL isSuccess=false;
    
    for (int i=0; i<count; i++) {
        
         isSuccess=[self connectWithHost:KIP port:KPort];
        
        if (isSuccess) {
            
            block(isSuccess);
            return;
        }

    }
    
    block(isSuccess);
    
}

- (void)dealloc
{
    _asyncSocket.delegate = nil;
    _asyncSocket = nil;
}



- (BOOL)connectWithHost:(NSString *)hostName port:(int)port
{
    
    if ( [self isConnected]) {
        
        if (_hud) {
            [_hud hide];
        }
        
        return YES ;
    }
    
    [self.hud addHudWithTitle:@"正在连接产品..." onWindow:myWindow];
    NSLog(@"[RHSocketConnection]正在连接产品...");
    self.connectCount++;
    
    
    
    NSError *error = nil;
    BOOL isSuccess= [_asyncSocket connectToHost:hostName onPort:port withTimeout:3 error:&error];
    
    if (error) {
        RHSocketLog(@"[RHSocketConnection] connectWithHost error: %@", error.description);
        if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
            [_delegate didDisconnectWithError:error];
        }
        
        if (self.connectCount<KMaxConnectCount) {
            
            [self connectWithHost:KIP port:KPort];
        }else{
            [self hideHud];
            self.connectCount=0;
        }
        
    }
    
    return isSuccess;
}





- (void)disconnect
{
    [_asyncSocket disconnect];
    
    [self stopHeartBeat];
    
    
    
}



- (BOOL)isConnected
{
    return [_asyncSocket isConnected];
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [_asyncSocket readDataWithTimeout:timeout tag:tag];
}

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag
{
    NSDictionary *d=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    GCLog(@"输出数据  %@", d);
    
    NSDictionary *dict=@{
                         KDataKey:data,
                         KTagKey:[NSNumber numberWithLong:tag],
                         KTimeOutKey:[NSNumber numberWithDouble:timeout]
                         };
    
    [self.dataQueue addObject:dict];
    
    //[_asyncSocket writeData:data withTimeout:timeout tag:tag];
    
    
}



- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag ReceiveBlock:(ReceiveBlock)block
{
  //  NSDictionary *d=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
   // GCLog(@"输出数据  %@", d);
    
    NSDictionary *dict=@{
                         KDataKey:data,
                         KTagKey:[NSNumber numberWithLong:tag],
                         KTimeOutKey:[NSNumber numberWithDouble:timeout]
                         };

    [self.dataQueue addObject:dict];
    
    
    self.receiveBlock = block;
  //  [_asyncSocket writeData:data withTimeout:timeout tag:tag];
    
    
    
}


- (void)sendData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag
{
 
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    //GCLog(@"socket发出数据%@   超时时间:%f",weatherDic,timeout);
    
    
     [_asyncSocket writeData:data withTimeout:timeout tag:tag];
    
    
//    int code=[weatherDic[KSokectOrder][@"code"] intValue];
//
//
//    switch (code) {
//        case 6:
//        {
//            GCLog(@"发出数据: %@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]);
//
//            if (self.textView) {
//
//                NSString *s = [NSString stringWithFormat:@"发出数据: %@%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding],@"\n"];
//
//
//                dispatch_sync(dispatch_get_main_queue(), ^{
//
//                    if(self.textView)
//                    {
//                        self.textView.text=[s stringByAppendingString:self.textView.text];
//                    }
//
//                });
//            }
//
//
//        }
//            break;
//
//        case 7:
//        {
//
//        }
//            break;
//
//        default:
//            break;
//    }
    
}


#pragma mark -
#pragma mark GCDAsyncSocketDelegate method

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
    if (err) {
        
        [self.heartBeatThread stop];
        
        NSDictionary *dict=@{@"state":[NSNumber numberWithInteger:(NSInteger)WifiConnectTypeDisconnect]};
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiConnectSokectServeState object:nil userInfo:dict];
        
    }else{
        return;
    }
    
    
    if (self.connectCount>=KMaxConnectCount) {
        
       
        [self hideHud];
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"连接产品失败,请检查后重试!"];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  
                                  [alertView dismissAnimated:NO];
                                  
                              }];
        
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                               
                                  [alertView dismissAnimated:NO];
                                
                                  self.connectCount=0;
                                  [self connectWithHost:KIP port:KPort];
                                  
                              }];
       
        [alertView show];
        

    }else
    {
   
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
          //  [[MQHudTool shareHudTool] addTipHudWithTitle:[NSString stringWithFormat:@"断开连接:%d次",self.connectCount]];
            
             [self connectWithHost:KIP port:KPort];
        });
        
       
    }

    
    RHSocketLog(@"[RHSocketConnection] didDisconnect...%@", err.description);
    if (_delegate && [_delegate respondsToSelector:@selector(didDisconnectWithError:)]) {
        [_delegate didDisconnectWithError:err];
        
        
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    RHSocketLog(@"[RHSocketConnection] didConnectToHost: %@, port: %d", host, port);

    NSDictionary *dict=@{@"state":[NSNumber numberWithInteger:WifiConnectTypeConnected]};
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiConnectSokectServeState object:nil userInfo:dict];
    
    self.connectCount=0;
    
    [self hideHud];
    
    
     [_asyncSocket readDataWithTimeout:-1 tag:0];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didConnectToHost:port:)]) {
        [_delegate didConnectToHost:host port:port];

    }

    //保持心跳
    [self keepHeartbeat];
    
    
    
   // [self writeData:[GCSokectDataDeal getInitData] timeout:-1 tag:0];
    
}



- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   // RHSocketLog(@"[RHSocketConnection] didReadData length: %lu, tag: %ld", (unsigned long)data.length, tag);
    
    //继续读取sokect
    [sock readDataWithTimeout:-1 tag:tag];
    
    
    

    NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    RHSocketLog(@"[RHSocketConnection] didReadData %@",result);
    
    
    
//    NSString *s=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    
//    if (s==nil) {
//        s=@"收到不能解析的数据";
//    }
//    
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:s delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    
//    [alert show];
//    
//    Byte *bytes=(Byte *)data.bytes;
//    
//    for (int i=0; i<data.length; i++) {
//        
//        char b=bytes[i];
//        NSLog(@"char类型数据: %c",b);
//        
//    }
    
    
//    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
//    
//    NSString *s1= [NSString stringWithCString:data encoding:enc];
    
    
    if (result==nil) {
        return;
    }
    
    if (result[KSokectOrder]==nil) {
        return;
    }

    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveData:tag:)]) {
        [_delegate didReceiveData:data tag:tag];
    }

    NSDictionary *orderDict=result[KSokectOrder];
    
    
    int code=0;
    
    @try {
        
         code=[orderDict[@"code"] intValue];
        
    } @catch (NSException *exception) {
        
        return;
        
    }

    //        如果连接状态改变，UI做相应改变
    GCUser * user = [GCUser getInstance];
    if (user.device.code != code) {
        user.device.code = code;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"conectionStatus" object:@{@"code":@(code)}];
    }
    
    if (code<0) {
        
        switch (code) {
            case -1:
            {
                if (self.isDeviceDisconnect) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDeviceDisconnectFormServe object:nil];
                    [GCDiscoverView showWithTip:@"电磁炉未连接服务器,您将无法控制电磁炉,请检查电磁炉状态!"];

                }
                self.isDeviceDisconnect=NO;
               
            }
                break;
                
            default:
                break;
        }
        
    }else{
    
        
        if(![result[@"id"] isEqualToString:[GCUser getInstance].device.deviceId])return;
        
        
        if (code==6) {
            
            
            GCLog(@"接收到数据: %@",orderDict);
            NSString *s = [NSString stringWithFormat:@"接收到数据: %@%@",[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding],@"\n"];
            
            
            if(self.textView)
            {
                self.textView.text=[s stringByAppendingString:self.textView.text];
            }
            
            
        }
        
        
        self.isDeviceDisconnect=YES;
        
        switch (code) {
            
            
            
            case 5:
            {
                NSDictionary *dict=@{
                                     @"data":orderDict,
                                     @"tag":[NSNumber numberWithLong:tag]
                                     };
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiWorkTime object:nil userInfo:dict];
            }
                break;

            case 6:
            {
                NSDictionary *dict=@{
                                     @"data":orderDict,
                                     @"tag":[NSNumber numberWithLong:tag]
                                     };
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiReservation object:nil userInfo:dict];
            }
                break;

            case 7:
            {
                NSDictionary *dict=@{
                                     @"data":orderDict,
                                     @"tag":[NSNumber numberWithLong:tag]
                                     };
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiReservation object:nil userInfo:dict];
            }
                break;
            case 8:
            {
                NSDictionary *dict=@{
                                     @"data":orderDict,
                                     @"tag":[NSNumber numberWithLong:tag]
                                     };
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiTiming object:nil userInfo:dict];
            }
                break;

            default:
            {
                NSDictionary *dict=@{
                                     @"data":orderDict,
                                     @"tag":[NSNumber numberWithLong:tag]
                                     };
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotiDevoceStateChange object:nil userInfo:dict];
            }
                break;
        }
        
    }
    
   
 
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{

    if (self.receiveBlock!=nil) {
        self.receiveBlock(nil, tag);
    }
    
   // RHSocketLog(@"[RHSocketConnection] didWriteDataWithTag: %ld", tag);
    [sock readDataWithTimeout:-1 tag:tag];
}


#pragma mark -数据处理
- (NSData *) calibrateWithData:(NSData *)data
{
    
    Byte *bytes = (Byte *)[data bytes];
    
    NSString *s =@"";
    
    int headIndex=0;
    
    for(int i=0;i<data.length;i++)
    {
        Byte value=bytes[i];
        
        Byte byte[]={value};
        
        NSData *currentData=[NSData dataWithBytes:byte length:1];
        
        
        s= [s stringByAppendingString:[NSString stringWithFormat:@"%d,",bytes[i]]];
        
        if (value==0xAA) {
            
            //NSMutableData 清空
            [self.buffer resetBytesInRange:NSMakeRange(0, [self.buffer length])];
            [self.buffer setLength:0];
            
     
            
            [self.buffer appendData:currentData];
            
            
            headIndex=i;
            
            
            
        }else if(value==0x55)
        {
            
            [self.buffer appendData:currentData];
            
            return self.buffer;
            
        }
        
        
        if (i>headIndex) {

            [self.buffer appendData:currentData];
            

        }

    }

    
    return nil;

}





#pragma mark -ui操作
- (void) hideHud{
    
    [self.hud hide];
    self.hud=nil;
}


#pragma mark -保持心跳
- (void) keepHeartbeat
{
    self.heartBeatThread = [[MyThread alloc] init];
    
    
    __weak typeof(self) ws = self;
    
    self.heartBeatThread.running = ^{

         //[ws writeData:[GCSokectDataDeal heartbeat] timeout:-1 tag:0];
        
        if (self.dataQueue.count>0) {
            
            NSDictionary *dict=ws.dataQueue[0];
            
            [ws sendData:dict[KDataKey] timeout:[dict[KTimeOutKey] doubleValue] tag:[dict[KTagKey] longValue]];
            
            [ws.dataQueue removeObjectAtIndex:0];
            
        }
        
        ws.writeCount++;
        
        if (ws.writeCount%10==0) {
            
             //GCLog(@"查询状态");
            
             [ws writeData:[GCSokectDataDeal getDataWithdevice:0] timeout:-1 tag:10];
             [ws writeData:[GCSokectDataDeal getDataWithdevice:1] timeout:-1 tag:12];
           
        }
        
        if (ws.writeCount>=10) {
            
            //发送心跳
           [ws writeData:[GCSokectDataDeal heartbeat] timeout:-1 tag:0];
            
            //[ws writeData:[GCSokectDataDeal test] timeout:-1 tag:0];
            
            ws.writeCount=0;
        }

        
    };
    
    [self.heartBeatThread run];

}

- (void) stopHeartBeat
{
    if (_heartBeatThread) {
        [_heartBeatThread stop];
    }
    
}

- (void)heartbeatRun
{
    while (YES) {
        
        
        
        NSLog(@"当前心跳线程%@",_heartBeatThread);
        
//        if (!_heartBeatThread.isCancelled) {
//            
//            
//            [self writeData:[GCSokectDataDeal heartbeat] timeout:-1 tag:0];
//            
//            
//        }else{
//            
//            [[NSThread currentThread] cancel];
//            break;
//        }
        
        sleep(4);
        
    }

}


#pragma mark -获取设备状态
- (void) getDeviceState
{
    [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getStateDataWithModen:0] timeout:-1 tag:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[RHSocketConnection getInstance] writeData:[GCSokectDataDeal getStateDataWithModen:1] timeout:-1 tag:1];
    });


   
    
}


















@end

//
//  GCTestViewController.m
//  InductionCooker
//
//  Created by csl on 2017/7/7.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCTestViewController.h"

#import "AsyncSocket.h"
#import "GCDAsyncSocket.h"
#import "RHSocketConnection.h"


@interface GCTestViewController ()

@end

@implementation GCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)buttonClick:(id)sender {
    
//    AsyncSocket *asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
//    NSError *error;
//    BOOL connectOK = [asyncSocket connectToHost: @"192.168.1.43" onPort: 1234 error: &error];
//    
//    if (!connectOK){
//        NSLog(@"connect error: %@", error);
//    }

     [[RHSocketConnection getInstance] connectWithHost:KIP port:KPort];
    
}

- (IBAction)send:(id)sender {
    
    NSData *data=[@"123456" dataUsingEncoding:NSUTF8StringEncoding];
    
    [[RHSocketConnection getInstance] writeData:data timeout:-1 tag:0];

}


//- (void) test
//{
//
//    NSString *a;
//    switch (a) {
//        case "00":
//            if (!curError.split("___")[0].equals("00")) {
//                curError = "00___";
//                isneedtouploaderror = false;
//                App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "no"));
//            }
//            break;
//        case "01":
//            if (!curError.split("___")[0].equals("E1")) {
//                isneedtouploaderror = true;
//                curError = "E1___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉无锅、锅具过小或锅具材质不对,\n请放置正确的锅具。"));
//            Log.i(TAG, "无锅或锅材质不对或锅具小于 8cm（故障代码：E1）" + curError);
//            break;
//        case "02":
//            if (!curError.split("___")[0].equals("E3")) {
//                isneedtouploaderror = true;
//                curError = "E3___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉电压过高，请检查或更换供电电源"));
//            Log.i(TAG, "高压保护（故障代码：E3） " + curError);
//            break;
//        case "04":
//            if (!curError.split("___")[0].equals("E4")) {
//                isneedtouploaderror = true;
//                curError = "E4___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉电压过低，请检查或更换供电电源"));
//            Log.i(TAG, "低压保护（故障代码：E4） " + curError);
//            break;
//        case "08":
//            if (!curError.split("___")[0].equals("E2")) {
//                isneedtouploaderror = true;
//                curError = "E2___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉器件温度过高，请联系售后维修。\n售后电话400-8888-8888"));
//            Log.i(TAG, " IGBT超温（故障代码：E2） " + curError);
//            break;
//        case "10":
//            if (!curError.split("___")[0].equals("E5")) {
//                isneedtouploaderror = true;
//                curError = "E5___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉炉面温检失败,请联系售后维修。\n售后电话400-8888-8888"));
//            Log.i(TAG, "炉面开路（热敏开路）（故障代码：E5） " + curError);
//            break;
//        case "20":
//            if (!curError.split("___")[0].equals("E6")) {
//                isneedtouploaderror = true;
//                curError = "E6___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉炉面温度过高,请联系售后维修。\n售后电话400-8888-8888"));
//            Log.i(TAG, "炉面超温保护，短路保护（故障代码：E6） " + curError);
//            break;
//        case "40":
//            if (!curError.split("___")[0].equals("E0")) {
//                isneedtouploaderror = true;
//                curError = "E0___" + System.currentTimeMillis();
//            }
//            App.getContext().sendBroadcast(new Intent(LeftCookerManager.COOKERERROR).putExtra("info", "左炉电路故障,请联系售后维修.\n售后电话400-8888-8888"));
//            Log.i(TAG, "线盘开路短路，振荡电路故障（大电容开路短路）（故障代码：E0） " + curError);
//            break;



//}


@end

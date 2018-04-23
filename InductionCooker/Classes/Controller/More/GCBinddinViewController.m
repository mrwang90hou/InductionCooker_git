//
//  GCBinddinViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/2.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCBinddinViewController.h"

#import "QRCodeReader.h"
#import "QRCodeReaderViewController.h"
#import "UIView+NTES.h"
#import "QRCodeReaderView.h"

@interface GCBinddinViewController ()<QRCodeReaderDelegate>

@property (nonatomic, strong)  QRCodeReaderViewController *reader;


@end

@implementation GCBinddinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getData];
    
    
    [self createUI];
    
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
}


- (void) createUI{
    
    
    
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
       
//        static dispatch_once_t onceToken;
//        
//        dispatch_once(&onceToken, ^{
//            self.reader = [QRCodeReaderViewController new];
//        });
//        self.reader.delegate = self;
//        
//        [self.reader setCompletionWithBlock:^(NSString *resultAsString) {
//            
//            
//        }];
//        
//        self.reader.view.frame=CGRectMake(0, 0, self.view.width, self.view.height);
//        
//        [self.view addSubview:self.reader.view];
        
        
        QRCodeReaderView *readView=[[QRCodeReaderView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:readView];
        
        [readView startScanning];
        
        
     }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机设备不支持二维码扫描功能,请更换设备操作!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        
    }

   
    
      
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -QRCodeReaderDelegate
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    
    
    
}

-(void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

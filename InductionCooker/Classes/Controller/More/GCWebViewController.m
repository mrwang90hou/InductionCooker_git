//
//  GCWebViewController.m
//  goockr_dustbin
//
//  Created by csl on 2017/5/4.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "GCWebViewController.h"

#import <WebKit/WebKit.h>
#import "MQBarButtonItemTool.h"

@interface GCWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation GCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.bounds.size.height )];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 1, CGRectGetWidth(self.view.frame),2)];
    [self.view addSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];

//    self.view.backgroundColor=[UIColor whiteColor];
//
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 40)];
//
//    [self.view addSubview:label];
//
//    label.text=@"页面优化中，敬请期待!";
//
//    label.textAlignment=NSTextAlignmentCenter;
    
    
    [MQBarButtonItemTool leftBarButttonItemWithViewController:self imageName:@"title_back"];
    
}

#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
   // NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

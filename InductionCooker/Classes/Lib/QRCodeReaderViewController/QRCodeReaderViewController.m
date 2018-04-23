/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderViewController.h"
#import "QRCameraSwitchButton.h"
#import "QRCodeReaderView.h"
#import "UIView+NTES.h"
#import "Masonry.h"
#import "GCInputSequenceCodeView.h"
#import "MQBarButtonItemTool.h"
#import "MQHudTool.h"

@interface QRCodeReaderViewController ()<GCInputSequenceCodeViewDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) QRCodeReader         *codeReader;
@property (assign, nonatomic) BOOL                 startScanningAtLoad;
@property (strong, nonatomic) GCInputSequenceCodeView               *bottomView;

@property (copy, nonatomic) void (^completionBlock) (NSString * __nullable);

@property (nonatomic,strong) MQHudTool *hud;

@end

@implementation QRCodeReaderViewController

-(MQHudTool *)hud
{
    if (_hud==nil) {
        _hud=[[MQHudTool alloc] init];
    }
    
    return _hud;
}


- (void)dealloc
{
    [self stopScanning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
}

- (id)init
{
    return [self initWithCancelButtonTitle:nil];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle
{
    return [self initWithCancelButtonTitle:cancelTitle metadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
}

- (id)initWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [self initWithCancelButtonTitle:nil metadataObjectTypes:metadataObjectTypes];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes
{
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:metadataObjectTypes];
    
    return [self initWithCancelButtonTitle:cancelTitle codeReader:reader];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader
{
    return [self initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:true];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];
        self.codeReader           = codeReader;
        self.startScanningAtLoad  = startScanningAtLoad;
        
        if (cancelTitle == nil) {
            //cancelTitle = NSLocalizedString(@"Cancel", @"Cancel");
            cancelTitle = NSLocalizedString(@"取消", @"取消");

        }
        
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        
        
        
        [self setupAutoLayoutConstraints];
        
        [_cameraView.layer insertSublayer:_codeReader.previewLayer atIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        __weak typeof(self) weakSelf = self;
        
        [codeReader setCompletionWithBlock:^(NSString *resultAsString) {
            
            NSArray* array = [resultAsString componentsSeparatedByString:@"@_@"];
            
            if (array.count<2||array.count!=2||![array[0] isEqualToString:@"GoockrCooker"])
            {
                return ;
            }
            
            
            
            [self bindingDevice:array[1]];
            
            if (weakSelf.completionBlock != nil) {
                weakSelf.completionBlock(resultAsString);
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [weakSelf.delegate reader:weakSelf didScanResult:resultAsString];
            }
            
          
            
        }];
    }
    return self;
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle
{
    return [[self alloc] initWithCancelButtonTitle:cancelTitle];
}

+ (instancetype)readerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [[self alloc] initWithMetadataObjectTypes:metadataObjectTypes];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle metadataObjectTypes:(NSArray *)metadataObjectTypes
{
    return [[self alloc] initWithCancelButtonTitle:cancelTitle metadataObjectTypes:metadataObjectTypes];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader
{
    return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader];
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle codeReader:(QRCodeReader *)codeReader startScanningAtLoad:(BOOL)startScanningAtLoad
{
    return [[self alloc] initWithCancelButtonTitle:cancelTitle codeReader:codeReader startScanningAtLoad:startScanningAtLoad];
}

#pragma mark -view的生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getData];
    
    [self createUI];
    
    [self addObserver];
    
  
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_startScanningAtLoad) {
        [self startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopScanning];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _codeReader.previewLayer.frame = self.view.bounds;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark -页面逻辑方法
- (void) getData{
    
    
}


- (void) createUI{
    
      [MQBarButtonItemTool leftBarButttonItemWithViewController:self title:@"取消"];
}

- (void) addObserver
{
    //注册观察键盘的变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


//移动UIView
-(void)transformView:(NSNotification *)aNSNotification
{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    NSLog(@"看看这个变化的Y值:%f",deltaY);
    
    float bottomMargin=0;
    if(deltaY<0)bottomMargin=deltaY;
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(bottomMargin);
        make.height.mas_equalTo(kScreenHeight*0.195);
        
        
    }];

    
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        
        //self.bottomView.constant=self.loginViewBottoMargin.constant+(-1*deltaY);
        [self.view layoutIfNeeded];
        
        
    }];
}


#pragma mark -用户交互方法
- (void) rightButtonClick
{
    
}

- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.view endEditing:YES];
}


#pragma mark - Controlling the Reader

- (void)startScanning {
    [_codeReader startScanning];
    
    [_cameraView startScanning];
}

- (void)stopScanning {
    [_codeReader stopScanning];
    
    [_cameraView stopScanning];
}


- (void) bindingDevice:(NSString *)code
{
     [self stopScanning];
    
    [self.hud addNormHudWithSupView:self.view title:@"正在绑定产品..."];
    
    //mobile=13800138000&token=adsafokjdsoaidslakjfsdalkj&devCode=test01
    NSDictionary *dict=@{
                         @"mobile":[GCUser getInstance].mobile,
                         @"token":[GCUser getInstance].token,
                         @"devCode":code
                         };
    
    [GCHttpDataTool bindingWithDict:dict success:^(id responseObject) {
        
        GCDevice *device=[[GCDevice alloc] init];
        
        device.deviceId=code;
        
        device.deviceName=[NSString stringWithFormat:@"电磁炉%lu" ,[GCUser getInstance].deviceList.count+1];
        [GCUser getInstance].device=device;
         [[GCUser getInstance].deviceList addObject:device];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiSelectDeviceChange object:nil];

        __weak typeof(self) ws = self;
        
        [self.hud hudUpdataTitile:@"绑定产品成功" hideTime:KHudSuccessShowShortTime success:^{
            
            [ws.navigationController popViewControllerAnimated:YES];
            
        }];
        
        if (![[RHSocketConnection getInstance] isConnected]) {
            
            [[RHSocketConnection getInstance] connectWithHost:KIP port:KPort];
        }
        
        
    } failure:^(MQError *error) {
        
        [self.hud hudUpdataTitile:error.msg hideTime:KHudTitleShowShortTime];
        
        [self startScanning];
        
    }];

}

#pragma mark - Managing the Orientation

- (void)orientationChanged:(NSNotification *)notification
{
    [_cameraView setNeedsDisplay];
    
    if (_codeReader.previewLayer.connection.isVideoOrientationSupported) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:
                                                                orientation];
    }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    [self.view addSubview:_cameraView];
    
    [_codeReader.previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // [_codeReader.previewLayer setFrame:CGRectMake(0, 0, 200, 100)];
    
    if ([_codeReader.previewLayer.connection isVideoOrientationSupported]) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        _codeReader.previewLayer.connection.videoOrientation = [QRCodeReader videoOrientationFromInterfaceOrientation:orientation];
    }
    
    self.cancelButton                                       = [[UIButton alloc] init];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:_cancelButton];
    
    
  
    _bottomView=[GCInputSequenceCodeView createView];
    [self.view addSubview:_bottomView];
    _bottomView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    _bottomView.delegate=self;
    
}

- (void)setupAutoLayoutConstraints
{
//    NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
//    
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(40)]|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
//    
//    if (_switchCameraButton) {
//        NSDictionary *switchViews = NSDictionaryOfVariableBindings(_switchCameraButton);
//        
//        [self.view addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchCameraButton(50)]" options:0 metrics:nil views:switchViews]];
//        [self.view addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchCameraButton(70)]|" options:0 metrics:nil views:switchViews]];
//    }
    
    
    
    float height=kScreenHeight*0.195;
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(height);
        
    }];
    
    [self.cameraView  mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-1*height);
        make.top.mas_equalTo(self.view.mas_top);

//        make.left.mas_equalTo(40);
//        make.top.mas_equalTo(40);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(100);
        
    }];
    
    
}

- (void)switchDeviceInput
{
    [_codeReader switchDeviceInput];
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
    [_codeReader stopScanning];
    
    if (_completionBlock) {
        _completionBlock(nil);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
        [_delegate readerDidCancel:self];
    }
}

- (void)switchCameraAction:(UIButton *)button
{
    [self switchDeviceInput];
}


#pragma mark -GCInputSequenceCodeViewDelegate
- (void)inputSequenceCode:(NSString *)code
{
    
    [self bindingDevice:code];
}

























@end

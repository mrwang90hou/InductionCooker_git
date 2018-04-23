


//角度转弧度
#define   DegreesToRadians(degrees)  ((M_PI * (degrees)) / 180)

#import "CircularProgressBar.h"

@interface CircularProgressBar ()

@property (assign, nonatomic) CircularProgressBarType type;

//控件的属性
@property (assign, nonatomic) CGFloat BarRedius;
@property (assign, nonatomic) CGPoint BarCenter;

@end

@implementation CircularProgressBar {
    CAShapeLayer *bgLayer;
    CAShapeLayer *contentLayer;
    CAShapeLayer *grayContentLayer;
    
    
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CircularProgressBarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
        self.type = type;
    }
    return self;
}


- (void)defaultInit {
    
    bgLayer=[CAShapeLayer layer];
    contentLayer = [CAShapeLayer layer];
    grayContentLayer = [CAShapeLayer layer];
    [self.layer addSublayer:bgLayer];
    [self.layer addSublayer:grayContentLayer];
    [self.layer addSublayer:contentLayer];
    
    
    self.barStartAngle = 120;
    self.barEndAngle=420;
   
    self.count=25;
    
    self.type = CircularProgressBarTypeCircular;
    self.progress = 0;
    
    self.greyProgressColor = [UIColor lightGrayColor];
    self.progressTintColor = [UIColor orangeColor];
    
    self.BarCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    

    self.circularRedius = 10.0;
       
    self.BarRedius = self.frame.size.width/2;

    
    self.bgCircularColor=[UIColor blueColor];
    
}





- (CAShapeLayer *)layerMaskWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    return [self shapeLayerWithStartAngle:startAngle endAngle:endAngle color:[UIColor blackColor]];
}


- (void)drawCircularChart {
    
    CAShapeLayer *layer=[self drawBgLayer];
    
    [bgLayer addSublayer:layer];

    
    float marginAngle=(self.barEndAngle-self.barStartAngle)/(self.count-1);
    
    int red=255;
    
    int greenMin=92;
    
    int greenMax=201;
    
    int blueMin=0;
    
    int blueMax=51;
    
    float greenArg=(float)(greenMax-greenMin)/(self.count-1);
    
    float blueArg=(float)(blueMax-blueMin)/(self.count-1);
    
    for (int i=0; i<self.count; i++) {
        
        
        CAShapeLayer *layer = [self circularLayerPathWithCAngle:self.barStartAngle+(i*marginAngle) count:i  color:self.greyProgressColor];
        
        [grayContentLayer addSublayer:layer];
        
        UIColor *progressColor=[UIColor colorWithRed:red/255.0 green:(201-(greenArg*i))/255.0 blue:(51-(blueArg*i))/255.0 alpha:1.0];
        
        //NSLog(@"color: greenArg:%f g:%f blueMax:%f b:%f",greenArg,201-(greenArg*i),blueArg,51-(blueArg*i));
        
        CAShapeLayer *layer1 = [self circularLayerPathWithCAngle:self.barStartAngle+(i*marginAngle) count:i  color:progressColor]
        ;
        [contentLayer addSublayer:layer1];
    }
    
    
    contentLayer.mask = [self layerMaskWithStartAngle:self.barStartAngle endAngle:self.barEndAngle];
    self.progress = 0;

}

- (CAShapeLayer *)drawBgLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.BarCenter radius:self.bounds.size.width/2-self.circularRedius/2 startAngle:DegreesToRadians(0) endAngle:DegreesToRadians(360) clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = self.bgCircularColor.CGColor;
    layer.fillColor =[UIColor clearColor].CGColor;
    layer.lineWidth = self.circularRedius;
    layer.path = path.CGPath;

    return layer;
}

- (CAShapeLayer *)shapeLayerWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color {
    

    float marginAngle=(self.barEndAngle-self.barStartAngle)/(self.count-1);
    
    startAngle=startAngle-marginAngle/2;
    
    endAngle=endAngle+marginAngle/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.BarCenter radius:self.BarRedius startAngle:DegreesToRadians(startAngle) endAngle:DegreesToRadians(endAngle) clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.strokeColor = [UIColor redColor].CGColor;
    
    layer.fillColor = [UIColor clearColor].CGColor;
    
    layer.lineWidth = self.circularRedius*2;
    
    layer.path = path.CGPath;
    
    return layer;
}



//生成进度条的图层
- (CAShapeLayer *)circularLayerPathWithCAngle:(CGFloat)total count:(int)count color:(UIColor *)color {
    
    CGFloat a = self.BarCenter.x;
    CGFloat b = self.BarCenter.y;
    
    CGFloat x = self.BarRedius * cos(DegreesToRadians(total)) + a;
    CGFloat y = self.BarRedius * sin(DegreesToRadians(total)) + b;
    
    
    
    CGFloat radiiX = _circularRedius/2;
    
    //根据半径的正弦和余弦计算刻度圆心的位置
    x=x-radiiX*cos(DegreesToRadians(total));
    y=y-radiiX*sin(DegreesToRadians(total));

    float marginAngle=(self.barEndAngle-self.barStartAngle)/self.count;
    
    float e= (total-self.barStartAngle)/marginAngle;
    
    //NSLog(@"刻度的x值:%f  y值:%f  第%f个点",x,y,e);
    
    UIBezierPath *path =[UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radiiX startAngle:DegreesToRadians(0) endAngle:DegreesToRadians(360) clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = color.CGColor;
    layer.lineWidth = 1;
   
    layer.path = path.CGPath;
   
    if (self.showCircular) {
        
        if ( [self.showCircular objectForKey:[NSString stringWithFormat:@"%d",count+1]]) {
            
          //  layer.fillColor= [self.showCircular objectForKey:[NSString stringWithFormat:@"%d",count+1]]?color.CGColor:[UIColor clearColor].CGColor;

            layer.fillColor=color.CGColor;
        }else{
            layer.fillColor=[UIColor clearColor].CGColor;
        }
        
              
    }
    
    return layer;
    
}




//请设置好属性后调用。
- (void)strokeChart {
    
    [self.layer removeFromSuperlayer];

    [self drawCircularChart];

}


- (void)setProgress:(CGFloat )progress {
    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;
    
    _progress = progress;
    
    ((CAShapeLayer *)contentLayer.mask).strokeEnd = progress;//顺时针
}


@end

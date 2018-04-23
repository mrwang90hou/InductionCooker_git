





#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CircularProgressBarType) {
    CircularProgressBarTypeRect,
    CircularProgressBarTypeCircular
    
};



@interface CircularProgressBar : UIView

//进度
@property (assign, nonatomic) CGFloat progress;

//进度条的颜色
/**
 未选中颜色
 */
@property (strong, nonatomic) UIColor *greyProgressColor;

/**
 选中颜色
 */
@property (strong, nonatomic) UIColor *progressTintColor;


/**
 背景环形颜色
 */
@property (strong, nonatomic) UIColor *bgCircularColor;

/**
 刻度圆的直径
 */
@property (assign, nonatomic) CGFloat circularRedius;


//设置开始的角度和弧形要的角度  0 ～360。
@property (assign, nonatomic) CGFloat barStartAngle;


/**
  结束弧形的度数
 */
@property (assign, nonatomic) CGFloat barEndAngle;


/**
 刻度的数量
 */
@property (assign, nonatomic) int count;



@property (strong, nonatomic) NSDictionary *showCircular;


- (instancetype)initWithFrame:(CGRect)frame type:(CircularProgressBarType)type;

- (void)strokeChart;


@end

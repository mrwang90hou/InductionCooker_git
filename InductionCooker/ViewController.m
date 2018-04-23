//
//  ViewController.m
//  InductionCooker
//
//  Created by csl on 2017/6/1.
//  Copyright © 2017年 csl. All rights reserved.
//

#import "ViewController.h"

#import "CircularProgressBar.h"

@interface ViewController ()
{
    CircularProgressBar *bar;
    UISlider *sw;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize size = self.view.frame.size;
    
    float width=200;
    float x=self.view.bounds.size.width/2-(width/2);
    float y=self.view.bounds.size.height/2-(width/2);
    
    bar = [[CircularProgressBar alloc]initWithFrame:CGRectMake(x, y, width, width)];
    
    NSMutableDictionary *mDict=[NSMutableDictionary dictionary];
    
    for (int i=0; i<25; i++) {
        
        NSString *str=[NSString stringWithFormat:@"%d",i];
        
        if (i%5==0) {
            continue;
        }
        
        [mDict setObject:str forKey:str];
        
    }
    
    bar.showCircular=mDict;
    
    [bar strokeChart];
    // bar.backgroundColor=[UIColor grayColor];
    [self.view addSubview:bar];
    
    float v_view_width=1;
    float v_x=self.view.bounds.size.width/2-(v_view_width/2);
    UIView *v_view=[[UIView alloc] initWithFrame:CGRectMake(v_x, 0, v_view_width, self.view.bounds.size.height)];
    v_view.backgroundColor=[UIColor greenColor];
    [self.view addSubview:v_view];
    
    float h_view_height=1;
    float h_y=self.view.bounds.size.height/2-(h_view_height/2);
    UIView *h_view=[[UIView alloc] initWithFrame:CGRectMake(0, h_y, self.view.bounds.size.width,h_view_height) ];
    h_view.backgroundColor=[UIColor greenColor];
    [self.view addSubview:h_view];
    
    
    
    
    
    
    sw = [[UISlider alloc]initWithFrame:CGRectMake(size.width/2 - 100, size.height - 60, 200, 50)];
    [self.view addSubview:sw];
    [sw addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    
    UIButton *bt_1=[UIButton buttonWithType:UIButtonTypeCustom];
    bt_1.frame=CGRectMake(20, 100, 40, 40);
    bt_1.backgroundColor= [UIColor redColor];
    [self.view addSubview:bt_1];
    [bt_1 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bt_2=[UIButton buttonWithType:UIButtonTypeCustom];
    bt_2.frame=CGRectMake(200, 100, 40, 40);
    bt_2.backgroundColor= [UIColor blackColor];
    [self.view addSubview:bt_2];
    [bt_2 addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void) add{
    
    double b=1/25.0;
    double va=sw.value+b;
    
    sw.value=va;
    
    bar.progress = sw.value;
    
}

- (void)reduce{
    
    sw.value=sw.value-1/25.0;
    
    bar.progress = sw.value;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  [bar strokeChart];
    
    // OneViewController *vc=[[OneViewController alloc] init];
    
    //[self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)changeValue:(UISlider *)slider {
    bar.progress = slider.value;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

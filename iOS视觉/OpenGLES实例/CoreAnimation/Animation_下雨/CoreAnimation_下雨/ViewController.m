//
//  ViewController.m
//  CoreAnimation_下雨
//
//  Created by xyj on 2019/5/30.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CAEmitterLayer * rainLayer;
@property (nonatomic, weak) UIImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    [self setupEmitter];
}

- (void)setupUI{
    
    // 背景图片
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    imageView.image = [UIImage imageNamed:@"rain"];
    
    // 下雨按钮
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:startBtn];
    startBtn.frame = CGRectMake(20, self.view.bounds.size.height - 60, 80, 40);
    startBtn.backgroundColor = [UIColor whiteColor];
    [startBtn setTitle:@"雨停了" forState:UIControlStateNormal];
    [startBtn setTitle:@"下雨" forState:UIControlStateSelected];
    [startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [startBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 雨量按钮
    UIButton * rainBIgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rainBIgBtn];
    rainBIgBtn.tag = 100;
    rainBIgBtn.frame = CGRectMake(140, self.view.bounds.size.height - 60, 80, 40);
    rainBIgBtn.backgroundColor = [UIColor whiteColor];
    [rainBIgBtn setTitle:@"下大点" forState:UIControlStateNormal];
    [rainBIgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rainBIgBtn addTarget:self action:@selector(rainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * rainSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rainSmallBtn];
    rainSmallBtn.tag = 200;
    rainSmallBtn.frame = CGRectMake(240, self.view.bounds.size.height - 60, 80, 40);
    rainSmallBtn.backgroundColor = [UIColor whiteColor];
    [rainSmallBtn setTitle:@"太大了" forState:UIControlStateNormal];
    [rainSmallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rainSmallBtn addTarget:self action:@selector(rainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)buttonClick:(UIButton *)sender{
    
    if (!sender.selected) {
        
        sender.selected = !sender.selected;
        NSLog(@"雨停了");
        
        // 停止下雨
        [self.rainLayer setValue:@0.f forKeyPath:@"birthRate"];
        
    }else{
        
        sender.selected = !sender.selected;
        NSLog(@"开始下雨了");
        
        // 开始下雨
        [self.rainLayer setValue:@1.f forKeyPath:@"birthRate"];
    }
}

- (void)rainButtonClick:(UIButton *)sender{
    
    NSInteger rate = 1;
    CGFloat scale = 0.05;
    if (sender.tag == 100) {
        
        NSLog(@"下大了");
        
        if (self.rainLayer.birthRate < 30) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate + rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale + scale) forKeyPath:@"scale"];
        }
        
    }else if (sender.tag == 200){
        
        NSLog(@"变小了");
        
        if (self.rainLayer.birthRate > 1) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate - rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale - scale) forKeyPath:@"scale"];
        }
    }
}

- (void)setupEmitter{
    
    // 1. 设置CAEmitterLayer
    CAEmitterLayer * rainLayer = [CAEmitterLayer layer];
    // 2.在背景图上添加粒子图层
    [self.imageView.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    //发射模式
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    //发射源大小
    rainLayer.emitterSize = self.view.frame.size;
    //发射源位置 y最好不要设置为0 最好<0
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    // 2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    //粒子内容
    snowCell.contents = (id)[[UIImage imageNamed:@"rain_white"] CGImage];
    //每秒产生的粒子数量的系数
    snowCell.birthRate = 25.f;
    //粒子的生命周期
    snowCell.lifetime = 20.f;
    //speed粒子速度.图层的速率。用于将父时间缩放为本地时间，例如，如果速率是2，则本地时间的进度是父时间的两倍。默认值为1。
    snowCell.speed = 10.f;
    //粒子速度系数, 默认1.0
    snowCell.velocity = 10.f;
    //每个发射物体的初始平均范围,默认等于0
    snowCell.velocityRange = 10.f;
    //粒子在y方向的加速的
    snowCell.yAcceleration = 1000.f;
    //粒子缩放比例: scale
    snowCell.scale = 0.1;
    //粒子缩放比例范围:scaleRange
    snowCell.scaleRange = 0.f;
    
    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  Animation_红包雨
//
//  Created by xyj on 2019/5/27.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CAEmitterLayer * rainLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //PS.图片随便找的.想要更好看的.可以自己配图.
    //㊗️.大家端午安康--CC.
    
    //粽子雨
    //[self rainZongzi];
   
    //红包雨
    //[self hongBaoRain];
    
    //金币雨
    //[self jingbiRain];
    
    //综合效果
    [self allRain];
}

-(void)rainZongzi
{
    
    //1. 设置CAEmitterLayer
    CAEmitterLayer * rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"zongzi2.jpg"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.05;
    snowCell.scaleRange = 0.f;
    
    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell];
    
}

-(void)hongBaoRain
{
    
    //1. 设置CAEmitterLayer
    CAEmitterLayer * rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.05;
    snowCell.scaleRange = 0.f;
    
    
    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell];
    
    
}


-(void)jingbiRain
{
    
    //1. 设置CAEmitterLayer
    CAEmitterLayer * rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"jinbi.png"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.1;
    snowCell.scaleRange = 0.f;

    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell];
    
    
}

-(void)allRain
{
    
    //1. 设置CAEmitterLayer
    CAEmitterLayer * rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"jinbi.png"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.1;
    snowCell.scaleRange = 0.f;
    
    CAEmitterCell * hongbaoCell = [CAEmitterCell emitterCell];
    hongbaoCell.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    hongbaoCell.birthRate = 1.0;
    hongbaoCell.lifetime = 30;
    hongbaoCell.speed = 2;
    hongbaoCell.velocity = 10.f;
    hongbaoCell.velocityRange = 10.f;
    hongbaoCell.yAcceleration = 60;
    hongbaoCell.scale = 0.05;
    hongbaoCell.scaleRange = 0.f;
    
    CAEmitterCell * zongziCell = [CAEmitterCell emitterCell];
    zongziCell.contents = (id)[[UIImage imageNamed:@"zongzi2.jpg"] CGImage];
    zongziCell.birthRate = 1.0;
    zongziCell.lifetime = 30;
    zongziCell.speed = 2;
    zongziCell.velocity = 10.f;
    zongziCell.velocityRange = 10.f;
    zongziCell.yAcceleration = 60;
    zongziCell.scale = 0.05;
    zongziCell.scaleRange = 0.f;
    
    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell,hongbaoCell,zongziCell];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

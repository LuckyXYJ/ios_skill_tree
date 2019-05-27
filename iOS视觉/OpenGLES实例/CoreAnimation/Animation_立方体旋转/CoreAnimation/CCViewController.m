//
//  CCViewController.m
//  CoreAnimation
//
//  Created by xyj on 2019/04/24.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) IBOutlet UIView *view0;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;


@property(nonatomic,strong)NSArray *faces;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger angle;
@end

@implementation CCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加面
    [self addCFaces];
    
    //添加CADisplayLink
    [self addCADisplayLink];
}

-(void) addCADisplayLink{
    
    self.angle = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)addCFaces
{
    self.faces = @[_view0,_view1,_view2,_view3,_view4,_view5];
    
    //父View的layer图层
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform
{
    //获取face视图并将其添加到容器中
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    //将face视图放在容器的中心
    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    //添加transform
    face.layer.transform = transform;
}

- (void)update {
    //1.计算旋转度数
    self.angle = (self.angle + 5) % 360;
    float deg = self.angle * (M_PI / 180);
    CATransform3D temp = CATransform3DIdentity;
    temp = CATransform3DRotate(temp, deg, 0.3, 1, 0.7);
    self.containerView.layer.sublayerTransform = temp;
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

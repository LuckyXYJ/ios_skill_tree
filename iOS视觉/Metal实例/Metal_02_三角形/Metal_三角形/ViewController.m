//
//  ViewController.m
//  Metal_三角形
//
//  Created by xyj on 2019/6/14.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "ViewController.h"
//导入MetalKit 工具类
@import MetalKit;
#import "XZRenderer.h"

@interface ViewController ()
{
    MTKView *_view;
    
    XZRenderer *_renderer;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the view to use the default device
    _view = (MTKView *)self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    
    if(!_view.device)
    {
        NSLog(@"Metal is not supported on this device");
        return;
    }
    
    _renderer = [[XZRenderer alloc] initWithMetalKitView:_view];
    
    if(!_renderer)
    {
        NSLog(@"Renderer failed initialization");
        return;
    }
    
    // Initialize our renderer with the view size
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    
    _view.delegate = _renderer;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

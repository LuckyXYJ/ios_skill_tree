//
//  XZRenderer.h
//  Metal_三角形
//
//  Created by xyj on 2019/6/14.
//  Copyright © 2019年 xyj. All rights reserved.
//


//导入MetalKit工具包
@import MetalKit;

//这是一个独立于平台的渲染类
//MTKViewDelegate协议:允许对象呈现在视图中并响应调整大小事件
@interface XZRenderer : NSObject<MTKViewDelegate>

//初始化一个MTKView
- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

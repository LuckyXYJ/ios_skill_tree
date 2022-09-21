//
//  XZRenderer.h
//  Metal_BasicTexture
//
//  Created by xyj on 2019/6/18.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MetalKit;

@interface XZRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end

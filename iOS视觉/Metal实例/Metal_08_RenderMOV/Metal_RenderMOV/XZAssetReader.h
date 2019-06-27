//
//  XZAssetReader.h
//  Metal_RenderMOV
//
//  Created by xyj on 2019/5/7.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface XZAssetReader : NSObject

//初始化
- (instancetype)initWithUrl:(NSURL *)url;

//从MOV文件读取CMSampleBufferRef 数据
- (CMSampleBufferRef)readBuffer;

@end

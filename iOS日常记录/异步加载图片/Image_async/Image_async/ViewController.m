//
//  ViewController.m
//  Image_async
//
//  Created by xyj on 2018/9/6.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self image];
    
//    self.view.frame = CGRectMake(0, 0, 100, 100);
    
//    self.view.frame = CGRectMake(1, 0, 100, 100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)text
{
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(100, 200, 100, 56);
//    [self.view addSubview:label];
    
    // 文字计算
    [@"text" boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    
    // 文字绘制
    [@"text" drawWithRect:CGRectMake(0, 200, 100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
}

- (void)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 100, 56);
    [self.view addSubview:imageView];
    self.imageView = imageView;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取CGImage
        CGImageRef cgImage = [UIImage imageNamed:@"timg"].CGImage;

        // alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }

        // bitmapInfo
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;

        // size
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);

        // context
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);

        // draw
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

        // get CGImage
        cgImage = CGBitmapContextCreateImage(context);

        // into UIImage
        UIImage *newImage = [UIImage imageWithCGImage:cgImage];

        // release
        CGContextRelease(context);
        CGImageRelease(cgImage);

        // back to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
        });
    });
}

@end

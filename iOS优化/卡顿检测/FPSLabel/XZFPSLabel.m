//
//  XZFPSLabel.m
//  BaseProject
//
//  Created by xingyajie on 2021/4/21.
//  Copyright © 2021 ios. All rights reserved.
//

#import "XZFPSLabel.h"
#import "XZWeakProxy.h"


@interface XZFPSLabel ()

@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@end

@implementation XZFPSLabel

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.fpsLabel];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.fpsLabel addGestureRecognizer:pan];
    }
    return self;
}


- (UILabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, kScreenWidth, 55, 24)];
        _fpsLabel.layer.cornerRadius = 5;
        _fpsLabel.clipsToBounds = YES;
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.userInteractionEnabled = YES;
        _fpsLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    }
    return _fpsLabel;
}

- (void)showFPSLabel {
    
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:[XZWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender{
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;
    if (newX < 55/2) {
        newX = 55/2;
    }
    if (newX > kScreenWidth - 55/2) {
        newX = kScreenWidth - 55/2;
    }
    if (newY < 34+ 24/2) {
        newY = 34+ 24/2;
    }
    if (newY > kScreenHeight - 24/2) {
        newY = kScreenHeight - 24/2;
    }
    panView.center = CGPointMake(newX, newY);
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
//        NSLog(@"==========%f",link.timestamp);
        _lastTime = link.timestamp;
        return;
    }

//    NSLog(@"------------%f",link.duration);

    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    
//    float fps = 1 / link.duration;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length - 3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    self.fpsLabel.font = [UIFont systemFontOfSize:14];
    self.fpsLabel.attributedText = text;
}

- (void)hideFpsLabel {
    
}



@end

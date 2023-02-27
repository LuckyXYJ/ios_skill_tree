//
//  ViewController.m
//  NativeDemo
//
//  Created by xingyajie on 2022/10/27.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()

@property(nonatomic, strong) FlutterEngine* flutterEngine;
@property(nonatomic, strong) FlutterViewController* flutterVc;
@property(nonatomic, strong) FlutterBasicMessageChannel * msgChannel;

@end

@implementation ViewController

-(FlutterEngine *)flutterEngine
{
    if (!_flutterEngine) {
        FlutterEngine * engine = [[FlutterEngine alloc] initWithName:@"hank"];
        if (engine.run) {
            _flutterEngine = engine;
        }
    }
    return _flutterEngine;
}

- (IBAction)pushFlutter:(id)sender {
    
    self.flutterVc.modalPresentationStyle = UIModalPresentationFullScreen;

    //创建channel
    FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"one_page" binaryMessenger:self.flutterVc.binaryMessenger];
    //告诉Flutter对应的页面
    [methodChannel invokeMethod:@"one" arguments:nil];
    
    //弹出页面
    [self presentViewController:self.flutterVc animated:YES completion:nil];
    
    
    //监听退出
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //如果是exit我就退出页面！
        if ([call.method isEqualToString:@"exit"]) {
            [self.flutterVc dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)pushFlutterTwo:(id)sender {
    
    self.flutterVc.modalPresentationStyle = UIModalPresentationFullScreen;

    //创建channel
    FlutterMethodChannel * methodChannel = [FlutterMethodChannel methodChannelWithName:@"two_page" binaryMessenger:self.flutterVc.binaryMessenger];
    //告诉Flutter对应的页面
    [methodChannel invokeMethod:@"two" arguments:nil];
    
    //弹出页面
    [self presentViewController:self.flutterVc animated:YES completion:nil];
    
    
    //监听退出
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //如果是exit我就退出页面！
        if ([call.method isEqualToString:@"exit"]) {
            [self.flutterVc dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flutterVc = [[FlutterViewController alloc] initWithEngine:self.flutterEngine nibName:nil bundle:nil];
    self.msgChannel = [FlutterBasicMessageChannel messageChannelWithName:@"messageChannel" binaryMessenger:self.flutterVc.binaryMessenger];
    
    [self.msgChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"收到Flutter的：%@",message);
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int a = 0;
    [self.msgChannel sendMessage:[NSString stringWithFormat:@"%d",a++]];
}


@end

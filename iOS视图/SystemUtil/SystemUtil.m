//
//  SystemUtil.m
//  workers
//
//  Created by ios on 2020/11/25.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import "SystemUtil.h"
#import <SafariServices/SafariServices.h>
#import <Photos/Photos.h>

@implementation SystemUtil
+ (void)callPhone:(NSString *)phoneNumber {
    //挂断，自动切换回来
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您的设备当前无法拨打电话，请使用其它设备拨打%@",phoneNumber] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

+ (void)presentAppStoreForAppId:(NSString *)appStoreId {
    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software", appStoreId];
    NSURL *finalUrl = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:finalUrl]) {
        [[UIApplication sharedApplication] openURL:finalUrl];
    }
}

+ (BOOL)remoteNotificationIsOn {
      return [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
}

+ (void)openSafariVC:(NSURL *)url entersReaderIfAvailable:(BOOL)available {
    if (@available(iOS 11.0, *)) {
        SFSafariViewControllerConfiguration *configuration = [[SFSafariViewControllerConfiguration alloc] init];
        configuration.entersReaderIfAvailable = available;
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url configuration:configuration];
        safariVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[SystemUtil topViewController] presentViewController:safariVC animated:YES completion:nil];
    } else {
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:available];
            safariVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [[SystemUtil topViewController] presentViewController:safariVC animated:YES completion:nil];
        } else {
            // Fallback on earlier versions
        }
    }
}
+ (UIViewController *)topViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return rootVC;
}

+ (void)saveImageToAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
              switch ( status ) {
                  case PHAuthorizationStatusNotDetermined:
                  case PHAuthorizationStatusRestricted:
                  case PHAuthorizationStatusDenied: {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [JYBAlertView showAlert:@"" withTitle:@"需要访问您的照片。\n请启用设置-隐私-照片"];
                      });
                  }
                      break;
                  case PHAuthorizationStatusAuthorized: {
                        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                               [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                           } completionHandler:completionHandler];
                  }
                      break;
              }
          }];
}

+ (void)changeStatusBarLight:(BOOL)isLight {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = isLight?UIStatusBarStyleLightContent:UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = isLight?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
        }
    });
}
@end

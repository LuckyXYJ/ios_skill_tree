//
//  SystemUtil.h
//  workers
//
//  Created by ios on 2020/11/25.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemUtil : NSObject
// 应用内拨打系统电话
+ (void)callPhone:(NSString *)phoneNumber;

// 跳转AppStore
+ (void)presentAppStoreForAppId:(NSString *)appStoreId;

// 判断应用通知是否开启
+ (BOOL)remoteNotificationIsOn;

+ (void)openSafariVC:(NSURL *)url entersReaderIfAvailable:(BOOL)available;

+ (void)saveImageToAlbum:(UIImage *)image completionHandler:(nullable void(^)(BOOL success, NSError *__nullable error))completionHandler;

+ (void)changeStatusBarLight:(BOOL)isLight;

+ (UIViewController *)topViewController;
@end

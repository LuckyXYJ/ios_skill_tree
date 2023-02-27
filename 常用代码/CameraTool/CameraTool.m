//
//  CameraTool.m
//  workers
//
//  Created by xingyajie on 2020/12/4.
//  Copyright © 2020 cnabc. All rights reserved.
//

#import "CameraTool.h"
#import <Photos/Photos.h>

@implementation CameraTool

+ (BOOL)cameraAuthority {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            return NO;
        }
    }
    return YES;
}

+ (void)showCameraAuthorityRequest:(NSString *)message withBlock:(void (^)(void))backBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"需要访问您的相机。\n请启用设置-隐私-相机"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (backBlock) {
            backBlock();
        }
    }];
    [alert addAction:confirm];
    [[self topViewController] presentViewController:alert animated:true completion:nil];
}

+ (void)xz_saveImage:(UIImage *)image completionHandle:(void (^)(NSError *error, NSString *message))completionHandler {
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 照片在相册中的Identifier
    __block NSString *localIdentifier = @"";
    NSError *error =nil;
    
    [library performChangesAndWait:^{
        // 1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest = [self getCurrentPhotoCollectionWithAlbumName:@"工书相机"];
        // 2 根据传入的照片，创建照片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 3 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        localIdentifier = placeholder.localIdentifier;
        // 4 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
    } error:&error];
                                
        
    if (error) {
        completionHandler(error, nil);
    } else {
        completionHandler(nil, localIdentifier);
    }
}

+ (PHAssetCollectionChangeRequest *)getCurrentPhotoCollectionWithAlbumName:(NSString *)albumName {
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:albumName]) {
            PHAssetCollectionChangeRequest *collectionRuquest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            return collectionRuquest;
        }
    }
    
    PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
    return collectionRequest;
}

+ (UIViewController *)topViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)rootVC).topViewController;
    }else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nav = ((UITabBarController *)rootVC).selectedViewController;
        return nav.topViewController;
    }else {
        return [[UIViewController alloc] init];
    }
}

@end

//
//  CameraTool.h
//  workers
//
//  Created by xingyajie on 2020/12/4.
//  Copyright © 2020 cnabc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraTool : NSObject

+ (void)xz_saveImage:(UIImage *)image completionHandle:(void (^)(NSError *error, NSString *message))completionHandler;

+ (BOOL)cameraAuthority;

+ (void)showCameraAuthorityRequest:(NSString *)message withBlock:(void (^)(void))backBlock;
@end

NS_ASSUME_NONNULL_END

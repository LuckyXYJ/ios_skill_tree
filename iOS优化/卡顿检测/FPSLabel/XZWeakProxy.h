//
//  XZWeakProxy.h
//  BaseProject
//
//  Created by xingyajie on 2021/4/21.
//  Copyright © 2021 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZWeakProxy : NSProxy

@property (nullable, nonatomic, weak) id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END

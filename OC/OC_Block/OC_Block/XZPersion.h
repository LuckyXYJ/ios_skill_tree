//
//  XZPersion.h
//  OC_Block
//
//  Created by xyj on 2018/5/5.
//  Copyright © 2022 xyj All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZPersion : NSObject
@property (copy, nonatomic) void (^block)();
@property (copy, nonatomic) NSString *name;

- (void)test;

- (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END

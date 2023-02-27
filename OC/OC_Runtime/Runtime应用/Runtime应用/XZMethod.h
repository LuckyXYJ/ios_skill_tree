//
//  XZMethod.h
//  Runtime应用
//
//  Created by xyj on 2018/5/29.
//  Copyright © 2018 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZMethod : NSObject<NSCoding>
@property (assign, nonatomic) int ID;
@property (assign, nonatomic) int weight;
@property (assign, nonatomic) int age;
@property (copy, nonatomic) NSString *name;

- (void)run;

- (void)test;

@end

NS_ASSUME_NONNULL_END

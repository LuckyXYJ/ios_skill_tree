//
//  ForwardMethod.h
//  OC_Runtime
//
//  Created by xyj on 2018/5/15.
//  Copyright © 2018 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForwardMethod : NSObject

- (void)test;
- (void)test1;

- (void)unknowSelector;


- (void)knowSelectot;
@end

NS_ASSUME_NONNULL_END

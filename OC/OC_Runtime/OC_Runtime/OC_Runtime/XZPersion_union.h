//
//  XZPersion_union.h
//  OC_Runtime
//
//  Created by xingyajie on 2018/5/9.
//  Copyright © 2018 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZPersion_union : NSObject

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;
- (void)setThin:(BOOL)thin;

- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;
- (BOOL)isThin;

@end

NS_ASSUME_NONNULL_END

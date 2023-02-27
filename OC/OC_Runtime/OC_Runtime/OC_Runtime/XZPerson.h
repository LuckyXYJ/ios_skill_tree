//
//  XZPerson.h
//  OC_Runtime
//
//  Created by xyj on 2018/5/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZPerson : NSObject

//@property (assign, nonatomic, getter=isTall) BOOL tall;
//@property (assign, nonatomic, getter=isRich) BOOL rich;
//@property (assign, nonatomic, getter=isHansome) BOOL handsome;

- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;

- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;

@end

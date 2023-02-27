//
//  XZPerson.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "XZPerson.h"

// 掩码，一般用来按位与(&)运算的
//#define XZTallMask 1
//#define XZRichMask 2
//#define XZHandsomeMask 4

//#define XZTallMask 0b00000001
//#define XZRichMask 0b00000010
//#define XZHandsomeMask 0b00000100

#define XZTallMask (1<<0)
#define XZRichMask (1<<1)
#define XZHandsomeMask (1<<2)

@interface XZPerson()
{
    char _tallRichHansome;
}
@end

@implementation XZPerson

- (instancetype)init
{
    if (self = [super init]) {
        _tallRichHansome = 0b00000100;
    }
    return self;
}

- (void)setTall:(BOOL)tall
{
    if (tall) {
        _tallRichHansome |= XZTallMask;
    } else {
        _tallRichHansome &= ~XZTallMask;
    }
}

- (BOOL)isTall
{
    return !!(_tallRichHansome & XZTallMask);
}

- (void)setRich:(BOOL)rich
{
    if (rich) {
        _tallRichHansome |= XZRichMask;
    } else {
        _tallRichHansome &= ~XZRichMask;
    }
}

- (BOOL)isRich
{
    return !!(_tallRichHansome & XZRichMask);
}

- (void)setHandsome:(BOOL)handsome
{
    if (handsome) {
        _tallRichHansome |= XZHandsomeMask;
    } else {
        _tallRichHansome &= ~XZHandsomeMask;
    }
}

- (BOOL)isHandsome
{
    return !!(_tallRichHansome & XZHandsomeMask);
}


@end

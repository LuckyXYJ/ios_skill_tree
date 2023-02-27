//
//  XZPersion_union.m
//  OC_Runtime
//
//  Created by xingyajie on 2018/5/9.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "XZPersion_union.h"

#define XZTallMask (1<<0)
#define XZRichMask (1<<1)
#define XZHandsomeMask (1<<2)
#define XZThinMask (1<<3)


@interface XZPersion_union()
{
    union {
        int bits;
        
        struct {
            char tall : 4;
            char rich : 4;
            char handsome : 4;
            char thin : 4;
        };
    } _tallRichHandsome;
}
@end

@implementation XZPersion_union

- (void)setTall:(BOOL)tall
{
    if (tall) {
        _tallRichHandsome.bits |= XZTallMask;
    } else {
        _tallRichHandsome.bits &= ~XZTallMask;
    }
}

- (BOOL)isTall
{
    return !!(_tallRichHandsome.bits & XZTallMask);
}

- (void)setRich:(BOOL)rich
{
    if (rich) {
        _tallRichHandsome.bits |= XZRichMask;
    } else {
        _tallRichHandsome.bits &= ~XZRichMask;
    }
}

- (BOOL)isRich
{
    return !!(_tallRichHandsome.bits & XZRichMask);
}

- (void)setHandsome:(BOOL)handsome
{
    if (handsome) {
        _tallRichHandsome.bits |= XZHandsomeMask;
    } else {
        _tallRichHandsome.bits &= ~XZHandsomeMask;
    }
}

- (BOOL)isHandsome
{
    return !!(_tallRichHandsome.bits & XZHandsomeMask);
}



- (void)setThin:(BOOL)thin
{
    if (thin) {
        _tallRichHandsome.bits |= XZThinMask;
    } else {
        _tallRichHandsome.bits &= ~XZThinMask;
    }
}

- (BOOL)isThin
{
    return !!(_tallRichHandsome.bits & XZThinMask);
}

@end

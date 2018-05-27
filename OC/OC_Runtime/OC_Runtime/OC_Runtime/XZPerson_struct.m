//
//  XZPerson_struct.m
//  OC_Runtime
//
//  Created by xingyajie on 2018/5/9.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "XZPerson_struct.h"

@interface XZPerson_struct()
{
    // 位域， ’: 1‘ 代表只占一位
    struct {
        char tall : 1;
        char rich : 1;
        char handsome : 1;
    } _tallRichHandsome;
}
@end

@implementation XZPerson_struct

- (void)setTall:(BOOL)tall
{
    _tallRichHandsome.tall = tall;
}

- (BOOL)isTall
{
    
    return !!_tallRichHandsome.tall;
}

- (void)setRich:(BOOL)rich
{
    _tallRichHandsome.rich = rich;
}

- (BOOL)isRich
{
    return !!_tallRichHandsome.rich;
}

- (void)setHandsome:(BOOL)handsome
{
    _tallRichHandsome.handsome = handsome;
}

- (BOOL)isHandsome
{
    return !!_tallRichHandsome.handsome;
}

@end

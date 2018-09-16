//
//  JailbreakTools.m
//  Jailbreak
//
//  Created by xyj on 2018/9/15.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "JailbreakTools.h"

@implementation JailbreakTools

+ (BOOL)judge_isJailbreak {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
}

@end

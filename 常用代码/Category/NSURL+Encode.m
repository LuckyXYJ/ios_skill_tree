//
//  NSURL+Encode.m
//  workers
//
//  Created by xingyajie on 2020/12/27.
//  Copyright © 2020 cnabc. All rights reserved.
//

#import "NSURL+Encode.h"
#import <objc/runtime.h>

@implementation NSURL (Encode)

+ (void)load{
    Method originMethod = class_getClassMethod([self class], @selector(URLWithString:));
    Method changeMethod = class_getClassMethod([self class], @selector(encodeUTF8URLWithString:));
    method_exchangeImplementations(originMethod, changeMethod);
}

+ (NSURL *)encodeUTF8URLWithString:(NSString *)urlString{
    if ([self hasChinese:urlString] == YES) {
        //对URL中的中文进行编码
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL * resultURL = [NSURL encodeUTF8URLWithString:url];
        return resultURL;
    }else{
        NSURL * resultURL = [NSURL encodeUTF8URLWithString:urlString];
        return resultURL;
    }
}

+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end

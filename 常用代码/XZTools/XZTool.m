//
//  XZTool.m
//  workers
//
//  Created by ios on 2020/11/28.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import <objc/runtime.h>

BOOL xz_isNull(id obj){
    return !obj || obj == [NSNull null];
}
BOOL xz_isEmptyString(NSString *string){
    return xz_isNull(string) || [string length] == 0;
}

NSString * xz_makeSureString(NSString *str){
    if([str isKindOfClass:[NSString class]]) return str;
    if([str isKindOfClass:[NSNumber class]]) return [(NSNumber*)str stringValue];
    return @"";
}
NSDictionary * xz_makeSureDictionary(NSDictionary *dic ){
    return [dic isKindOfClass:[NSDictionary class]]?dic:@{};
}
NSArray * xz_makeSureArray(NSArray *array ){
    return [array isKindOfClass:[NSArray class]]?array:@[];
}
NSString * xz_stringFromInt(NSInteger i){
    return [NSString stringWithFormat:@"%ld",(long)i];
}
NSString * xz_timeStamp(){
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}
NSString * xz_documentDirectory(){
    return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

void XZSwizzleInstanceMethod(Class class, SEL originalSelector, SEL alternativeSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(class, alternativeSelector);
    
    if(class_addMethod(class, originalSelector, method_getImplementation(alternativeMethod), method_getTypeEncoding(alternativeMethod))) {
        class_replaceMethod(class, alternativeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, alternativeMethod);
    }
}

void XZSwizzleClassMethod(Class class, SEL originalSelector, SEL alternativeSelector)
{
    class = object_getClass(class);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(class, alternativeSelector);
    
    if(class_addMethod(class, originalSelector, method_getImplementation(alternativeMethod), method_getTypeEncoding(alternativeMethod))) {
        class_replaceMethod(class, alternativeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, alternativeMethod);
    }
}

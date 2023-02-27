//
//  XZTool.h
//  workers
//
//  Created by ios on 2020/11/28.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL xz_isNull(id obj);
BOOL xz_isEmptyString(NSString *string);
NSString * xz_makeSureString(NSString *str);
NSDictionary * xz_makeSureDictionary(NSDictionary *dic );
NSArray * xz_makeSureArray(NSArray *array );
NSString * xz_stringFromInt(NSInteger i);
NSString * xz_timeStamp(void);
NSString * xz_documentDirectory(void);


void XZSwizzleInstanceMethod(Class class, SEL originalSelector, SEL alternativeSelector);
void XZSwizzleClassMethod(Class class, SEL originalSelector, SEL alternativeSelector);

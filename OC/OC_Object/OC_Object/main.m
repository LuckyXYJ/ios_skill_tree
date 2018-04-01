//
//  main.m
//  OC_Object
//
//  Created by xyj on 2018/4/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

@interface Person : NSObject
{
    @public
    int _age;
}
@property (nonatomic, assign) int height;
@end


@implementation Person

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSObject *obj = [[NSObject alloc] init];
//        // 16个字节
//        
//        // 获得NSObject实例对象的成员变量所占用的大小 >> 8
//        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
//        
//        // 获得obj指针所指向内存的大小 >> 16
//        NSLog(@"%zd", malloc_size((__bridge const void *)obj));
    }
    return 0;
}

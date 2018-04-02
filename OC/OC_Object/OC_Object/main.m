//
//  main.m
//  OC_Object
//
//  Created by xyj on 2018/4/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

//struct NSObject_IMPL {
//    Class isa;
//};
//
//struct Person_IMPL {
//    struct NSObject_IMPL NSObject_IVARS; // 8
//    int _age; // 4
//}; // 16 内存对齐：结构体的大小必须是最大成员大小的倍数
//
//struct Student_IMPL {
//    struct Person_IMPL Person_IVARS; // 16
//    int _no; // 4
//}; // 16

@interface Person : NSObject
{
    @public
    int _age;
}
@property (nonatomic, assign) int height;
@end


@implementation Person

@end

// Student
@interface Student : Person
{
    int _no;
//    int _sex;
}
@end

@implementation Student

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSObject *obj = [[NSObject alloc] init];
//        // 16个字节
//        
        // 获得NSObject实例对象的成员变量所占用的大小 >> 8
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        
        // 获得obj指针所指向内存的大小 >> 16
        NSLog(@"%zd", malloc_size((__bridge const void *)obj));
        
        Student *stu = [[Student alloc] init];
        NSLog(@"stu - %zd", class_getInstanceSize([Student class]));
        NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));
        
        
        Person *person = [[Person alloc] init];
//        [person setHeight:10];
//        [person height];
        person->_age = 20;
        
        Person *person1 = [[Person alloc] init];
        person1->_age = 10;
        
        
        Person *person2 = [[Person alloc] init];
        person2->_age = 30;
        
        NSLog(@"person - %zd", class_getInstanceSize([Person class]));
        NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
    }
    return 0;
}

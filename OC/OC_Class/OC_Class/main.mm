//
//  main.m
//  OC_Class
//
//  Created by xyj on 2018/4/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "MJClassInfo.h"

// MJPerson
@interface MJPerson : NSObject <NSCopying>
{
@public
    int _age;
}
@property (nonatomic, assign) int no;
- (void)personInstanceMethod;
+ (void)personClassMethod;
@end

@implementation MJPerson

- (void)test
{
    
}

- (void)personInstanceMethod
{
    
}
+ (void)personClassMethod
{
    
}
- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}
@end

// MJStudent
@interface MJStudent : MJPerson <NSCoding>
{
@public
    int _weight;
}
@property (nonatomic, assign) int height;
- (void)studentInstanceMethod;
+ (void)studentClassMethod;
@end

@implementation MJStudent
- (void)test
{
    
}
- (void)studentInstanceMethod
{
    
}
+ (void)studentClassMethod
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSObject *object1 = [[NSObject alloc] init];
        NSObject *object2 = [[NSObject alloc] init];
        
        Class objectClass1 = [object1 class];
        Class objectClass2 = [object2 class];
        Class objectClass3 = object_getClass(object1);
        Class objectClass4 = object_getClass(object2);
        Class objectClass5 = [NSObject class];
        
        NSLog(@"\n%p==object1\n%p==object2",
              object1,
              object2);
        
        NSLog(@"\n%p==objectClass1\n%p==objectClass2\n%p==objectClass3\n%p==objectClass4\n%p==objectClass5\n",
              objectClass1,
              objectClass2,
              objectClass3,
              objectClass4,
              objectClass5);
        
        
        MJStudent *stu = [[MJStudent alloc] init];
        stu->_weight = 10;
        
        mj_objc_class *studentClass = (__bridge mj_objc_class *)([MJStudent class]);
        mj_objc_class *personClass = (__bridge mj_objc_class *)([MJPerson class]);
        
        class_rw_t *studentClassData = studentClass->data();
        class_rw_t *personClassData = personClass->data();
        
        class_rw_t *studentMetaClassData = studentClass->metaClass()->data();
        class_rw_t *personMetaClassData = personClass->metaClass()->data();

        NSLog(@"1111");
        
        
        NSLog(@"%d", [[NSObject class] isKindOfClass:[NSObject class]]);
        NSLog(@"%d", [[NSObject class] isMemberOfClass:[NSObject class]]);
        NSLog(@"%d", [[MJPerson class] isKindOfClass:[MJPerson class]]);
        NSLog(@"%d", [[MJPerson class] isMemberOfClass:[MJPerson class]]);
        
        
        // 这句代码的方法调用者不管是哪个类（只要是NSObject体系下的），都返回YES
        NSLog(@"%d", [NSObject isKindOfClass:[NSObject class]]); // 1
        NSLog(@"%d", [NSObject isMemberOfClass:[NSObject class]]); // 0
        NSLog(@"%d", [MJPerson isKindOfClass:[MJPerson class]]); // 0
        NSLog(@"%d", [MJPerson isMemberOfClass:[MJPerson class]]); // 0
        
        
        id person = [[MJPerson alloc] init];
        
        NSLog(@"%d", [person isMemberOfClass:[MJPerson class]]);
        NSLog(@"%d", [person isMemberOfClass:[NSObject class]]);
        
        NSLog(@"%d", [person isKindOfClass:[MJPerson class]]);
        NSLog(@"%d", [person isKindOfClass:[NSObject class]]);
        
        
        NSLog(@"%d", [MJPerson isMemberOfClass:object_getClass([MJPerson class])]);
        NSLog(@"%d", [MJPerson isKindOfClass:object_getClass([NSObject class])]);
        
        NSLog(@"%d", [MJPerson isKindOfClass:[NSObject class]]);
    }
    return 0;
}

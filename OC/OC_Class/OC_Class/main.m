//
//  main.m
//  OC_Class
//
//  Created by xyj on 2018/4/2.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MJPerson : NSObject
{
    int _age;
    int _height;
    int _no;
}
@end

@implementation MJPerson
- (void)test {
    
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
    }
    return 0;
}

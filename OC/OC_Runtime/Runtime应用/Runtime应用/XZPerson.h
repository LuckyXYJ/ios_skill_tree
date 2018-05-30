//
//  XZPerson.h
//  Runtime应用
//
//  Created by xyj on 2018/5/29.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZPerson : NSObject
@property (assign, nonatomic) int ID;
@property (assign, nonatomic) int weight;
@property (assign, nonatomic) int age;
@property (copy, nonatomic) NSString *name;
- (void)run;
@end

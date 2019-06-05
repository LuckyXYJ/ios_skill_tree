//
//  FilterBar.h
//  OpenGLES_滤镜处理
//
//  Created by xyj on 2019/6/3.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterBar;

@protocol FilterBarDelegate <NSObject>

- (void)filterBar:(FilterBar *)filterBar didScrollToIndex:(NSUInteger)index;

@end

@interface FilterBar : UIView

@property (nonatomic, strong) NSArray <NSString *> *itemList;

@property (nonatomic, weak) id<FilterBarDelegate> delegate;

@end

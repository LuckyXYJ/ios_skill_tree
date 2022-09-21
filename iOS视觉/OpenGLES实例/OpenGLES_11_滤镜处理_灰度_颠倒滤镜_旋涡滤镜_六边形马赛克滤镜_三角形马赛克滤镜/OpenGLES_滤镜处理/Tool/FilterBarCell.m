//
//  FilterBarCell.m
//  OpenGLES_滤镜处理
//
//  Created by xyj on 2019/6/3.
//  Copyright © 2019年 xyj. All rights reserved.
//


#import "FilterBarCell.h"

@interface FilterBarCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation FilterBarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)commonInit {
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont boldSystemFontOfSize:15];
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 15;
    [self addSubview:self.label];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.label.backgroundColor = isSelect ? [UIColor blackColor] : [UIColor whiteColor];
    self.label.textColor = isSelect ? [UIColor whiteColor] : [UIColor blackColor];
}

@end

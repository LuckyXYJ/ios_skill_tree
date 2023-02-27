//
//  SignatureView.m
//  BaseProject
//
//  Created by ios on 2020/11/20.
//  Copyright © 2020 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Class 描述：签名视图
 */
@interface SignatureView : UIView

@property (nonatomic, strong) UIColor *lineColor;   //画笔颜色
@property (nonatomic, assign) CGFloat lineWidth;    //画笔宽度
@property (nonatomic, strong) UIImage *backgroundImage; //背景图片

@property (nonatomic, assign) BOOL stopDraw;    // 停止绘制操作，默认开启

@property (nonatomic, copy) void (^drawLineBlock)(BOOL showUndo, BOOL showRedo);    // 绘制线头数量 回调

/**
 获取签名图片
 
 @return 签名Image
 */
- (UIImage *)signatureImage;

/**
 撤销上一步绘制
 */
- (void)undoLastDraw;

/**
 恢复上次撤销操作
 */
- (void)redoLastDraw;

/**
 清除所有操作
 */
- (void)clearSignature;

/**
 保存签名
 */
- (void)saveSignature;


/// 获取图片
- (UIImage *)passSignatureImage;


/// 获取标记图片
- (UIImage *)markImage;

- (void)changeSignatureFrame:(CGRect)frame;

@end

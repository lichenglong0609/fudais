//
//  UIView+PPDrawLine.h
//  PostProduct
//
//  Created by 尚宇 on 2018/8/12.
//  Copyright © 2018年 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PPDrawLine)

- (void)cy_drawDashlineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end

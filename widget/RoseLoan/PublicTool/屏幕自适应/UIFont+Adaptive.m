//
//  UIFont+Adaptive.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/20.
//  Copyright © 2019 cython. All rights reserved.
//

#import "UIFont+Adaptive.h"
#import <objc/runtime.h>
@implementation UIFont (Adaptive)

+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/MyUIScreen];
    return newFont;
}

@end

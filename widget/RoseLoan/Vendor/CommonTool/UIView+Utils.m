//
//  UIView+Utils.m
//  PostProduct
//
//  Created by 尚宇 on 2018/7/15.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

@end

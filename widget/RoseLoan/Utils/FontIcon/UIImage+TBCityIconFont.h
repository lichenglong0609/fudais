//
//  UIImage+TBCityIconFont.h
//  UddTrip
//
//  Created by zhanggang on 16/8/10.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBCityIconInfo.h"

@interface UIImage (TBCityIconFont)

+ (UIImage *)iconWithInfo:(TBCityIconInfo *)info;

- (UIImage*)cy_fillImageColor:(UIColor *)color;

@end

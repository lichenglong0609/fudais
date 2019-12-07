//
//  TBCityIconInfo.m
//  UddTrip
//
//  Created by zhanggang on 16/8/10.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "TBCityIconInfo.h"


@implementation TBCityIconInfo

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
    }
    return self;
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    return [[TBCityIconInfo alloc] initWithText:text size:size color:color];
}


@end
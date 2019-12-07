//
//  TBCityIconFont.h
//  UddTrip
//
//  Created by zhanggang on 16/8/10.
//  Copyright © 2016年 scandy. All rights reserved.
//

#define TBCityIconInfoMake(text, imageSize, imageColor) [TBCityIconInfo iconInfoWithText:text size:imageSize color:imageColor]

#import <Foundation/Foundation.h>
#import "UIImage+TBCityIconFont.h"
#import "TBCityIconInfo.h"
#import <CoreText/CoreText.h>

@interface TBCityIconFont : NSObject


+ (UIFont *)fontWithSize: (CGFloat)size;

+ (void)setFontName:(NSString *)fontName;

@end

//
//  ColorDefine.h
//  51Investment
//
//  Created by V 凉夏季 on 2019/1/21.
//  Copyright © 2019 V 凉夏季. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h
#import "UIColor+Extend.h"

#define rgb(r,g,b)                      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define rgba(r,g,b,a)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMainColor hexColor(FF3427)
#define hexColor(colorV)                [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a)         [UIColor colorWithHexColorString:@#colorV alpha:a]
#endif /* ColorDefine_h */

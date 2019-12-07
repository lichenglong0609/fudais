//
//  Font.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/28.
//  Copyright © 2019 cython. All rights reserved.
//

#ifndef Font_h
#define Font_h

/**
 中黑
 @param floatValue 字号
 */
#define FontPingFangSCMedium(floatValue)        [UIFont fontWithName:@"PingFangSC-Medium" size:floatValue*[UIScreen mainScreen].bounds.size.width/375]
///中粗
#define FontPingFangSCSemibold(floatValue)      [UIFont fontWithName:@"PingFangSC-Semibold" size:floatValue*[UIScreen mainScreen].bounds.size.width/375]
///常规字体
#define FontPingFangSCRegular(floatValue)       [UIFont fontWithName:@"PingFangSC-Regular" size:floatValue*[UIScreen mainScreen].bounds.size.width/375]

///系统字体
#define FontSystemSize(floatValue)              [UIFont systemFontOfSize:floatValue*[UIScreen mainScreen].bounds.size.width/375]
///系统粗字体
#define FontSystemBoldSize(floatValue)          [UIFont boldSystemFontOfSize:floatValue*[UIScreen mainScreen].bounds.size.width/375]

#define FontCustomize(fontNameValue,floatValue)       [UIFont fontWithName:fontNameValue size:floatValue*[UIScreen mainScreen].bounds.size.width/375]
#endif /* Font_h */

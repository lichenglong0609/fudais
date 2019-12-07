//
//  ScreenDefine.h
//  51Investment
//
//  Created by V 凉夏季 on 2019/1/21.
//  Copyright © 2019 V 凉夏季. All rights reserved.
//

#ifndef ScreenDefine_h
#define ScreenDefine_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/** 状态栏高度*/
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/** 状态栏高度和导航栏高度*/
#define kStatusBarAndNavcHeight (kStatusBarHeight + 44)
/** 底部留白高度*/
#define kSafeAreaBottomHeight (kScreenHeight >= 812.0 ? 34 : 0)

#define isIPhoneX       (kScreenHeight >= 812)
#define isIPhone6p      (kScreenHeight == 763)
#define isIPhone6       (kScreenHeight == 667)
#define isIPhone5       (kScreenHeight == 568)
#define isIPhone4       (kScreenHeight == 480)

#define KTabbarHeight      (isIPhoneX ? 83 : 49)
#define SafeBottomH     (isIPhoneX ? 34 : 0)

#define AdaptW(floatValue)              floatValue*[[UIScreen mainScreen] bounds].size.width/375
#define AdaptH(floatValue)              floatValue*[[UIScreen mainScreen] bounds].size.height/667

#endif /* ScreenDefine_h */

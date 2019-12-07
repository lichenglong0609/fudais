//
//  Udd.h
//  UddTrip
//
//  Created by 0X10 on 16/7/29.
//  Copyright © 2016年 scandy. All rights reserved.
//

/*
 kOrderUrl  这个宏相关的接口为：获取订单列表、取消订单、获取退票人列表、退票
 在测试环境为order
 在正式环境为order2
 */
/*********************/

/**
 *  配置文件
 *  包含宏定义、API接口、枚举、接口参数的宏。
 *
 */

#import "AppDelegate.h"
#import "PPAllRequestSharedData.h"
#import "CYNetwork.h"
#import "PPSign.h"

#ifndef Udd_h
#define Udd_h

#define oneDay 24*60*60

/*
 *appkey
 *apiSecret
 */



/**
 *   HOST WEB IP OR REAL
 */

#define strOrEmpty(str) [UITool strOrEmpty:str]



//宽度和高度（根据屏幕自适应）
#define PPIWIDTHORHEIGHT(value) value*[UIScreen mainScreen].bounds.size.width/750

#define oneDay 24*60*60

// pi
#define WIDTH_PI        [UIScreen mainScreen].bounds.size.width/320

//device width
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

// device height
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height


// iPhone X
#define  iPhoneX                SCREEN_HEIGHT >= 812.f ? YES : NO

// Status bar height.
#define  StatusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height//(iPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define  NavigationBarHeight  44.f

// Tabbar height.
#define  TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
//导航栏和状态栏高度

#define NAVBAR_HEIGHT       (iPhoneX ? 88.f : 64.f)

#define ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define SystemVersion [[UIDevice currentDevice] systemVersion].floatValue

//工具类的宏定义(默认颜色等)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f    alpha:(a)]
#define DEFAULTCOLOR       [UIColor colorWithRed:167/255.0f green:41/255.0f blue:36/255.0f      alpha:(1)]
#define GRAYCOLOR         [UIColor colorWithRed:(245)/255.0f green:(245)/255.0f blue:(249)/255.0f alpha:(1)]

//UIColorFromRGB(0xbfbfbf);
#define TEXT_COLOR          UIColorFromRGB(0xbfbfbf)

#define TEXT_COLOR1          UIColorFromRGB(0x999999)

#define Login_Color         [UIColor colorWithRed:((float)((0x2862bc & 0xFF0000) >> 16))/255.0 green:((float)((0x2862bc & 0xFF00) >> 8))/255.0 blue:((float)(0x2862bc & 0xFF))/255.0 alpha:1.0]

//主题色0x2862bc/RGBACOLOR(89, 190, 246, 1)
#define kPrimaryColor       [UIColor colorWithRed:(89)/255.0f green:(190)/255.0f blue:(246)/255.0f alpha:(1)]

//#define kPrimaryColor       [UIColor colorWithRed:((float)((0x2862bc & 0xFF0000) >> 16))/255.0 green:((float)((0x2862bc & 0xFF00) >> 8))/255.0 blue:((float)(0x2862bc & 0xFF))/255.0 alpha:1.0]


//APP主色及对比色
#define kPrimaryColor1      [UIColor colorWithRed:((float)((0x0386df & 0xFF0000) >> 16))/255.0 green:((float)((0x0386df & 0xFF00) >> 8))/255.0 blue:((float)(0x0386df & 0xFF))/255.0 alpha:1.0]

#define kText_Color2         [UIColor colorWithRed:((float)((0x8E8F92 & 0xFF0000) >> 16))/255.0 green:((float)((0x8E8F92 & 0xFF00) >> 8))/255.0 blue:((float)(0x8E8F92 & 0xFF))/255.0 alpha:1.0]

#define kText_Color3        [UIColor colorWithRed:((float)((0xff7700 & 0xFF0000) >> 16))/255.0 green:((float)((0xff7700 & 0xFF00) >> 8))/255.0 blue:((float)(0xff7700 & 0xFF))/255.0 alpha:1.0]

#define kText_Color4        [UIColor colorWithRed:((float)((0xff5454 & 0xFF0000) >> 16))/255.0 green:((float)((0xff5454 & 0xFF00) >> 8))/255.0 blue:((float)(0xff5454 & 0xFF))/255.0 alpha:1.0]

#define kText_Color5        [UIColor colorWithRed:((float)((0xffffff & 0xFF0000) >> 16))/255.0 green:((float)((0xffffff & 0xFF00) >> 8))/255.0 blue:((float)(0xffffff & 0xFF))/255.0 alpha:1.0]

#define kText_Color6        [UIColor colorWithRed:((float)((0xa4a5a6 & 0xFF0000) >> 16))/255.0 green:((float)((0xa4a5a6 & 0xFF00) >> 8))/255.0 blue:((float)(0xa4a5a6 & 0xFF))/255.0 alpha:1.0]

#define kText_Color7        [UIColor colorWithRed:((float)((0x7e7e7f & 0xFF0000) >> 16))/255.0 green:((float)((0x7e7e7f & 0xFF00) >> 8))/255.0 blue:((float)(0x7e7e7f & 0xFF))/255.0 alpha:1.0]

#define kText_Color8        [UIColor colorWithRed:((float)((0x333333 & 0xFF0000) >> 16))/255.0 green:((float)((0x333333 & 0xFF00) >> 8))/255.0 blue:((float)(0x333333 & 0xFF))/255.0 alpha:1.0]

#define kLine_Color9        [UIColor colorWithRed:((float)((0xe0e0e0 & 0xFF0000) >> 16))/255.0 green:((float)((0xe0e0e0 & 0xFF00) >> 8))/255.0 blue:((float)(0xe0e0e0 & 0xFF))/255.0 alpha:1.0]

#define kLine_Color10       [UIColor colorWithRed:((float)((0xc6c6c6 & 0xFF0000) >> 16))/255.0 green:((float)((0xc6c6c6 & 0xFF00) >> 8))/255.0 blue:((float)(0xc6c6c6 & 0xFF))/255.0 alpha:1.0]

#define kButton_Color11     [UIColor colorWithRed:((float)((0xe6e6e6 & 0xFF0000) >> 16))/255.0 green:((float)((0xe6e6e6 & 0xFF00) >> 8))/255.0 blue:((float)(0xe6e6e6 & 0xFF))/255.0 alpha:1.0]

#define kBg_Color12         [UIColor colorWithRed:((float)((0xf2f3f5 & 0xFF0000) >> 16))/255.0 green:((float)((0xf2f3f5 & 0xFF00) >> 8))/255.0 blue:((float)(0xf2f3f5 & 0xFF))/255.0 alpha:1.0]

#define kBg_Color13         [UIColor colorWithRed:((float)((0xeaebed & 0xFF0000) >> 16))/255.0 green:((float)((0xeaebed & 0xFF00) >> 8))/255.0 blue:((float)(0xeaebed & 0xFF))/255.0 alpha:1.0]

#define kBg_Color14         [UIColor colorWithRed:((float)((0x464e61 & 0xFF0000) >> 16))/255.0 green:((float)((0x464e61 & 0xFF00) >> 8))/255.0 blue:((float)(0x464e61 & 0xFF))/255.0 alpha:1.0]

#define kBg_Color15         [UIColor colorWithRed:((float)((0xffd4d4 & 0xFF0000) >> 16))/255.0 green:((float)((0xffd4d4 & 0xFF00) >> 8))/255.0 blue:((float)(0xffd4d4 & 0xFF))/255.0 alpha:1.0]

//动画时间 默认 0.25s
#define DurationTime    0.25


//-------------------获取设备大小-------------------------


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)  ((void)0)
#endif

//打印当前方法的名称
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
ITTDPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define ITTAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)


#define SZNotificationCenter [NSNotificationCenter defaultCenter]
#define SZUserDefault [NSUserDefaults standardUserDefaults]

#define GetDefaults(key)             [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SetDefaults(key,value)       [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]

#define kAppDelegate [UIApplication sharedApplication].delegate
/** window*/
#define kWindow [UIApplication sharedApplication].keyWindow
#define WEAKSELF typeof(self) __weak weakSelf = self;

//空字符串

//#define kApiBaseUrl @"http://101.132.108.30:8080/yizhan_rest/"
//#define kApiPicUrl @"http://101.132.108.30:8080/picupload/user/"

//


//#define kApiBaseUrl @"http://47.110.234.62/yizhan_rest/"
//#define kApiPicUrl @"http://47.110.234.62/picupload/user/"
/**
 *  typedef
 */

/** 设定时间间隔5分钟 */
#define LIMIT_TIME 5*60

typedef enum {
    
    kHomeSelectQuPlay = 1,//趣玩乐
    kHomeSelectSortPlay = 2,//短假游
    kHomeSelectLongPlay = 3,//长假游
    
} UDDHomeSelectType;//首页选择类型


#endif /* Udd_h */

//
//  SystemDefine.h
//  51Investment
//
//  Created by V 凉夏季 on 2019/1/21.
//  Copyright © 2019 V 凉夏季. All rights reserved.
//

#ifndef SystemDefine_h
#define SystemDefine_h

#define SharedApplication           [UIApplication sharedApplication]

/** userDefault*/
#define kUserDefault [NSUserDefaults standardUserDefaults]
/** 写入userDefault*/
#define kDefaultSetObject(object,key) [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];[[NSUserDefaults standardUserDefaults] synchronize];
/** 从userDefault取值*/
#define kDefaultGetObject(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]

/** window*/
#define kWindow [UIApplication sharedApplication].keyWindow
/** 当前界面上的vc*/
#define kCurrentViewController [PPTool currentViewController]
#define ImageName(imgName)  [UIImage imageNamed:imgName]
#endif /* SystemDefine_h */

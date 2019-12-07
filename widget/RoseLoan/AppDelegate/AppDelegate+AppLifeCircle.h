//
//  AppDelegate+AppLifeCircle.h
//  UddTrip
//
//  Created by uddtrip on 16/8/4.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppLifeCircle)

/**
 *  从数据库中得到用户数据
 */
- (void)updateAppData;

/**
 *  校对时间差
 */
- (void)checkTimer;

/**
 *  更新火车城市列表
 */
- (void)getTrainData;

- (BOOL)isKeepAccount;
@end

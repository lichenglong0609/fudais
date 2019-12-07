//
//  AppDelegate+RootController.h
//  UddTrip
//
//  Created by uddtrip on 16/8/4.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 *  广告每天首次启动轮播图
 */
- (void)createLoadingScrollView;
/**
 *  tabbar实例
 */
- (void)setTabbarController;

/**
 *  设置window实例
 */
- (void)setAppWindows;

/**
 *  设置根视图
 */
- (void)setRootViewController;

- (void)setRoot;

- (void)setupViewControllers;

- (void)setMoneyRootViewControlle;

@end

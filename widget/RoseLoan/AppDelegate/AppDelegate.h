//
//  AppDelegate.h
//  PostProduct
//
//  Created by 尚宇 on 2018/7/11.
//  Copyright © 2018年 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic)UIViewController * viewController;

@property (strong,nonatomic)UITabBarController * tabBarController;

@property (nonatomic, strong) NSDictionary *userInfo;

+ (UINavigationController *)rootNavigationController;

@end


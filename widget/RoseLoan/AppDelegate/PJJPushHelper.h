//
//  PJJPushHelper.h
//  PeiJun
//
//  Created by V 凉夏季 on 2017/8/22.
//  Copyright © 2017年 张振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface PJJPushHelper : NSObject

// 在应用启动的时候调用
+ (void)setupWithOption:(NSDictionary *)launchingOption
           pushDelegate:(AppDelegate *)delegate;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;
// 收到消息
- (void) handleReceiveNotification:(NSDictionary *)userInfo withVC:(UIViewController *)vc;
@end

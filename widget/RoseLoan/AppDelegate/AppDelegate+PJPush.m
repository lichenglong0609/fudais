//
//  PJPush.m
//  PeiJun
//
//  Created by V 凉夏季 on 2017/8/22.
//  Copyright © 2017年 张振. All rights reserved.
//

#import "AppDelegate+PJPush.h"
#import "PJJPushHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "MBProgressHUD+JDragon.h"
@implementation AppDelegate(PJPush)
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [PJJPushHelper setupWithOption:launchOptions pushDelegate:self];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];


    self.userInfo = [[NSDictionary alloc] init];
    self.userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[NSUserDefaults standardUserDefaults] setValue:self.userInfo forKey:@"launchOptionsRemoteNotificationKey"];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"appFirst"];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification){
        kWindow.rootViewController = [PPTabBarController shareInstance];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"appFirst"];
        [[NSUserDefaults standardUserDefaults] setValue:remoteNotification forKey:@"launchOptionsRemoteNotificationKey"];
        [JPUSHService resetBadge];
    }
}
- (void)networkDidReceiveMessage:(NSNotification *)note{
    NSDictionary *userInfo = [note userInfo];
    NSString *str = [userInfo[@"content"] copy];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    self.userInfo = [self dictionaryWithJsonString:str];
    
    if (self.userInfo[@"clNewsNum"] && [NSString stringWithFormat:@"%@",self.userInfo[@"clNewsNum"]]>0) {
        if ([self.userInfo[@"clNewsNum"] integerValue]>0) {
            kDefaultSetObject(self.userInfo[@"clNewsNum"], @"clNewsNum");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clNewsNum" object:nil];
        }
    }

    [JPUSHService handleRemoteNotification:note.userInfo];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [PJJPushHelper registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"launchOptionsRemoteNotificationKey"]){
        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"launchOptionsRemoteNotificationKey"];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"appFirst"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_JPUSH object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil userInfo:userInfo];
        
    }
    [JPUSHService handleRemoteNotification:userInfo];
    [JPUSHService resetBadge];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"launchOptionsRemoteNotificationKey"]){
        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"launchOptionsRemoteNotificationKey"];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"appFirst"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_JPUSH object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil userInfo:userInfo];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService resetBadge];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [PJJPushHelper showLocalNotificationAtFront:notification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"launchOptionsRemoteNotificationKey"];
    if (userInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
    }
}

// ---------------------------------------------------------------------------------
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification API_AVAILABLE(ios(10.0)){
    
}
#pragma mark - iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:content.badge.integerValue];
    
//    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"launchOptionsRemoteNotificationKey"])
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"launchOptionsRemoteNotificationKey"];
//        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"appFirst"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_JPUSH object:nil userInfo:userInfo];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
//    }

    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:content.badge.integerValue];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"launchOptionsRemoteNotificationKey"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"appFirst"];
        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:@"launchOptionsRemoteNotificationKey"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_JPUSH object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil userInfo:userInfo];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler();  // 系统要求执行这个方法
}
#endif


@end

//
//  PJJPushHelper.m
//  PeiJun
//
//  Created by V 凉夏季 on 2017/8/22.
//  Copyright © 2017年 张振. All rights reserved.
//

#import "PJJPushHelper.h"
#import <JPush/JPUSHService.h>
#import "PPUserModel.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString * const JPUSHAPPKEY = @"a2a74ed4cb40b5c77c7e5100"; // 极光appKey
static NSString * const JPChannel = @"App Store"; // 固定的

#ifdef DEBUG // 开发
static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
#else // 生产
static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
#endif

@interface PJJPushHelper ()
@property (nonatomic, retain) NSString *taskId;

@end

@implementation PJJPushHelper
+ (void)setupWithOption:(NSDictionary *)launchingOption
           pushDelegate:(AppDelegate *)delegate{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
        if (@available(iOS 12.0, *)) {
            entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
        } else {
            entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        }
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    // 如不需要使用IDFA，advertisingIdentifier 可为nil
    // 注册极光推送
    [JPUSHService setupWithOption:launchingOption appKey:JPUSHAPPKEY channel:JPChannel apsForProduction:isProduction advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    NSString *alias;
    if ([PPUserModel sharedUser].userId.intValue>0) {
        alias = [PPUserModel sharedUser].userId;
    }else{
        alias = @"玫瑰贷";
    }
    //我TM也不知道seq有什么实际的吊用
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:0];
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    return;
}

// 收到消息
- (void) handleReceiveNotification:(NSDictionary *)userInfo withVC:(UIViewController *)vc
{
    // 用于推送反馈
    [PJJPushHelper handleRemoteNotification:userInfo completion:nil];
    _taskId = userInfo[@"task_id"] ? userInfo[@"task_id"] : @"0";
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    
    if (appState == UIApplicationStateActive) {
        // 如果是活动中的状态，需要弹窗，弹窗过程中让用户选择是否进入查看推送的内容 如果确定则进入个人中心进入消息中心列表 如果取消留在当前页面
        if (userInfo[@"pageUrl"]) {
            [self showMsg:userInfo withVC:vc withUrl:userInfo[@"pageUrl"]];
        }else {
//            [[[DXAlertView alloc] initWithTitle:nil contentText:userInfo[@"aps"][@"alert"] leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        }
    }else{
        if (userInfo[@"pageUrl"]) {
            [self getJumpDataWithVC:vc withUrl:userInfo[@"pageUrl"]];
        }
    }
}

- (void)getJumpDataWithVC:(UIViewController *)vc withUrl:(NSString *)url
{

}

// 收到后的动作
- (void) showMsg:(NSDictionary*)userInfo withVC:(UIViewController *)vc withUrl:(NSString *)url {

}

@end

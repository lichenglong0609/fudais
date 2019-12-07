//
//  AppDelegate.m
//  PostProduct
//
//  Created by 尚宇 on 2018/7/11.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "AppDelegate.h"
//#import <FLEX/FLEX.h>
#import "AppDelegate+AppLifeCircle.h"
#import "AppDelegate+PJPush.h"

#import "PPLoginViewController.h"
#import "PPUserModel.h"

//#import "GestureViewController.h"
//#import "PCCircleViewConst.h"

#import <iVersion/iVersion.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    kDefaultSetObject(@"101", @"ipType");
    kDefaultSetObject(@"103.80.24.192:8088", @"ipType");
//    kDefaultSetObject(@"192.168.1.144", @"ipType");
    
    if ([self isKeepAccount]) {
//        if ([PPUserModel sharedUser].userId.intValue>0) {
            self.window.rootViewController = [PPTabBarController shareInstance];
//        }else{
//            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
//            [self.window setRootViewController:loginNav];
//        }
    }else{
//        if ([[PPUserModel sharedUser].userId intValue] <= 0) {
//            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
//            [self.window setRootViewController:loginNav];
//        } else {
            self.window.rootViewController = [PPTabBarController shareInstance];
//        }
    }
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self initVersion];
    [self.window makeKeyAndVisible];
#if DEBUG
    NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"];
    [bundle load];
//    [[FLEXManager sharedManager] showExplorer];
#endif
#if defined(DEBUG)||defined(_DEBUG)
//    [[JPFPSStatus sharedInstance] open];
#endif
//    [AvoidCrash makeAllEffective];
    return YES;
}

+ (UINavigationController *)rootNavigationController

{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (UINavigationController *)app.window.rootViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

-(void)initVersion{
    iVersion *iv = [iVersion sharedInstance];
    iv.updateURL = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://gitee.com/zanezhangT/iPA/raw/master/RoseLoan_Manifest.plist"];
    iv.remoteVersionsPlistURL = @"https://gitee.com/zanezhangT/iPA/raw/master/RoseLoan_Versions.plist";
    iv.useAppStoreDetailsIfNoPlistEntryFound = NO;
    //提示框的样式
    iv.updatePriority = iVersionUpdatePriorityMedium;
    //是否展示更新内容
    iv.viewedVersionDetails = YES;
    //设置提醒间隔
    iv.remindPeriod = 7;
}
@end

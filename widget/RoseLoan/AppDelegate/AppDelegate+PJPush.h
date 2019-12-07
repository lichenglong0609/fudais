//
//  PJPush.h
//  PeiJun
//
//  Created by V 凉夏季 on 2017/8/22.
//  Copyright © 2017年 张振. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <JPush/JPUSHService.h>
@interface AppDelegate (PJPush)<JPUSHRegisterDelegate>
-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

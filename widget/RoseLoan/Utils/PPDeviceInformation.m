//
//  PPDeviceInformation.m
//  PostProduct
//
//  Created by V 凉夏季 on 2019/3/13.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPDeviceInformation.h"
#import <SAMKeychain/SAMKeychain.h>
@implementation PPDeviceInformation
+(NSString *)getUUIDString{
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:bundleID account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:bundleID account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}
@end

//
//  PPTool.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPTool.h"

@implementation PPTool
+ (NSString *)getBaseURL{
    NSString *str = kDefaultGetObject(@"ipType");
    if([str isEqualToString:@"101"]){
        return @"http://wallet.gounihua.net/";
    }else if([str isEqualToString:@"47"]){
            return @"http://47.110.234.62/";
    }else{
        return [NSString stringWithFormat:@"http://%@/",str];
    }
}
+ (NSString *)UTF8StringEncoding:(NSString *)urlString {
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
}

+(NSString *)getURLImageWithBase:(NSString *)base andPath:(NSString *)path{
    if (path.length == 0) {
        return nil;
    }
    if ([path containsString:@"http://"] || [path containsString:@"https://"]) {
        return path;
    }
    NSString *subStr = [path substringWithRange:NSMakeRange(0, 1)];
    if ([subStr isEqualToString:@"/"]) {
        return [NSString stringWithFormat:@"%@%@",base,[path substringWithRange:NSMakeRange(1, path.length - 1)]];
    }
    else{
        return [NSString stringWithFormat:@"%@%@",base, path];
    }
}

+ (UIViewController *)currentViewController{
    UIViewController *vc;
    UINavigationController *navc;
    if (kWindow.rootViewController.presentedViewController){
        if ([kWindow.rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
            navc = (UINavigationController *)kWindow.rootViewController.presentedViewController;
            if (navc.presentedViewController) {
                if ([navc.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    navc = (UINavigationController *)navc.presentedViewController;
                    vc = navc.viewControllers.lastObject;
                }
            }
            else{
                vc = navc.viewControllers.lastObject;
            }
        }
        else{
            vc = kWindow.rootViewController.presentedViewController;
        }
    } else if ([kWindow.rootViewController isKindOfClass:[PPTabBarController class]]) {
            PPTabBarController *tb = (PPTabBarController *)kWindow.rootViewController;
            navc = tb.viewControllers[tb.selectedIndex];
            vc = navc.viewControllers.lastObject;
        }
    else if([kWindow.rootViewController isKindOfClass:[UINavigationController class]]){
        navc = (UINavigationController *)kWindow.rootViewController;
        vc = navc.viewControllers.lastObject;
    }
    else{
        vc = kWindow.rootViewController;
    }
    return vc;
}
+ (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
@end

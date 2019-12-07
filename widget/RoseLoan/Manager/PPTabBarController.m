//
//  PPTabBarController.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPTabBarController.h"
#import "PPDeviceInformation.h"
#import "PPUserModel.h"
#import "PPLoginViewController.h"
#import "WebViewController.h"
@interface PPTabBarController()<UITabBarControllerDelegate>

@end
@implementation PPTabBarController
static  PPTabBarController *tabBar = nil;
+(PPTabBarController *)shareInstance{
    dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        if (tabBar == nil) {
            tabBar = [[PPTabBarController alloc] init];
            [tabBar.tabBar setTranslucent:NO];
        }
    });
    return tabBar;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushAction) name:@"applicationDidBecomeActive" object:nil];
    [self setUpTabBar];
    [self setMoneyRootViewControlle];
}
-(void)setUpTabBar{
    UITabBar *tabBar = [[UITabBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    [tabBar setTranslucent:NO];
    //KVC把系统换成自定义
    [self setValue:tabBar forKey:@"tabBar"];
}
- (void)setMoneyRootViewControlle{
    PPUserModel *model = [PPUserModel sharedUser];
    NSArray *selectedImg = @[@"tab_home_sel",@"tab_supermarket_sel",@"tab_mine_sel"];
    NSArray *normalImg = @[@"tab_home",@"tab_supermarket",@"tab_mine"];
    NSArray *viewControllers = @[@"PPHomeVC",@"PPMarketViewController",@"PPPersonalCenterVC"];
    NSArray *titles = @[@"首页",@"借钱",@"我的"];
    
    NSMutableArray *VControllers = [[NSMutableArray alloc]init];
    for (int i = 0; i<viewControllers.count; i++) {
        NSString *controller = viewControllers[i];
        Class class = NSClassFromString(controller);
        UIViewController *viewcontroller = [[class alloc]init];
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
        navc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",selectedImg[i]]];
        navc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",normalImg[i]]];
        navc.tabBarItem.title = titles[i];
        [VControllers addObject:navc];
    }
    [self setViewControllers:VControllers];
    self.tabBar.tintColor = RGBACOLOR(249, 109, 79, 1);
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *vc = nav.viewControllers.firstObject;
    if ([vc isKindOfClass:[NSClassFromString(@"PPMarketViewController") class]]) {
        NSDictionary *dic = @{@"userId":[PPUserModel sharedUser].userId == nil ? @"" : [PPUserModel sharedUser].userId,@"location":@"贷款超市",@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString]};
        [CYNetwork getRequestUrl:KNETstatisticPvUv paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
            
        }];
    }
    
    if ([vc isKindOfClass:[NSClassFromString(@"PPRepayViewController") class]]) {
        if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId > 0) {
            return YES;
        }else{
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
            [self presentViewController:loginNav animated:true completion:nil];
            return NO;
        }
    }
    return YES;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self tabBarButtonClick:[self getTabBarButton]];
}

- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

- (void)jpushAction{
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"launchOptionsRemoteNotificationKey"];
    if (userInfo) {
        if ([PPUserModel sharedUser].userId.intValue>0) {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"appFirst"] isEqualToString:@"1"]){
                
                [self jpushMessageHandler:userInfo];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"launchOptionsRemoteNotificationKey"];
            }
        }else{
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
            [self presentViewController:loginNav animated:true completion:nil];
        }
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"appFirst"];
}
- (void)jpushMessageHandler:(NSDictionary *)userInfo {
    UINavigationController *navc = self.selectedViewController;
    NSString *myType = [userInfo valueForKey:@"type"];
    if (myType != nil) {
        switch ([[userInfo valueForKey:@"type"] integerValue]) {
            case 0:
            {
                //活动详情
//                NSString *urlStr = urlStr = [NSString stringWithFormat:@"%@PtlSignup!actRegInit.action?uid=%@&activityNo=%@",BANURL, kUserId, [userInfo valueForKey:@"objCode"]];
                NSDictionary *aps = userInfo[@"aps"];
                NSString *title = aps[@"title"];
                NSString *urlStr = [NSString stringWithFormat:@"%@",userInfo[@"url"]];
                WebViewController *details = [[WebViewController alloc] init];
                details.titleStr = title;
                details.url = urlStr;
                details.hidesBottomBarWhenPushed = YES;
                [navc pushViewController:details animated:YES];
            }
                break;
            default:
                break;
        }
    }else{

    }
    
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"appFirst"];
}
@end

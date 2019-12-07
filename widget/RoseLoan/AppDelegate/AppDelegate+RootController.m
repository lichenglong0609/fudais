//
//  AppDelegate+RootController.m
//  UddTrip
//
//  Created by uddtrip on 16/8/4.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "AppDelegate+Service.h"
#import "AppDelegate+AppLifeCircle.h"
#import "PPMainViewController.h"
#import "PPMineViewController.h"
#import <CYLTabBarController.h>

#import "PPPropertyViewController.h"
#import "PPRepayViewController.h"
#import "PPMarketViewController.h"
#import "PPMoneyMainViewController.h"
#import "PPDeviceInformation.h"

@interface AppDelegate ()<UITabBarControllerDelegate>


@end

@implementation AppDelegate (RootController)

- (void)setRootViewController
{
    //当天
    [self setRoot];
    [self setTabbarController];
        

}

- (void)setRoot
{
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    
    navc.navigationBar.shadowImage = [[UIImage alloc] init];
    [navc.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [navc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navc.navigationBar.tintColor = [UIColor whiteColor];
    self.window.rootViewController = navc;
}

#pragma mark - Windows
- (void)setTabbarController
{
    NSArray *viewControllers = @[@"PPPropertyViewController.h",@"PPRepayViewController",@"PPMarketViewController",@"PPMineViewController"];
    NSArray *selectedImg = @[@"tab_home_sel",@"",@"shop-2",@"tab_mine_sel"];
    NSArray *normalImg = @[@"tab_home",@"",@"shop-1",@"tab_mine"];
    NSArray *titles = @[@"首页",@"还款",@"贷款超市",@"我的"];
    
    NSMutableArray *VControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<viewControllers.count; i++) {
        
        NSString *controller = viewControllers[i];
        
        Class class = NSClassFromString(controller);
        
        UIViewController *viewcontroller = [[class alloc]init];
        
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
        
        navc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"Main.bundle/%@",selectedImg[i]]];
        navc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"Main.bundle/%@",normalImg[i]]];
        
        navc.tabBarItem.title = titles[i];
        [VControllers addObject:navc];
    }
    
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    [tabbarController setViewControllers:VControllers];
    tabbarController.tabBar.tintColor = kPrimaryColor1;
    tabbarController.tabBar.tintColor = RGBACOLOR(250, 121, 111, 1);
    self.window.rootViewController = tabbarController;
    
}



- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance]setTranslucent:NO];
    
}


- (void)setupViewControllers {
    PPMainViewController *firstViewController = [[PPMainViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    PPMineViewController *secondViewController = [[PPMineViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    
    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           firstNavigationController,
                                           secondNavigationController,
                                           ]];
    self.window.rootViewController = tabBarController;
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"home_normal",
                            CYLTabBarItemSelectedImage : @"home_highlight",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"同城",
                            CYLTabBarItemImage : @"mycity_normal",
                            CYLTabBarItemSelectedImage : @"mycity_highlight",
                            };
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}



- (void)goToMain
{
    [self setRoot];
    [self setTabbarController];
}

- (void)setMoneyRootViewControlle{
    PPUserModel *model = [PPUserModel sharedUser];
    NSArray *selectedImg;
    NSArray *normalImg;
    NSArray *viewControllers;
    NSArray *titles;
    if (model.showLoanSupermarket == 1) {
        selectedImg = @[@"tab_home_sel",@"tab_money_sel",@"tab_mine_sel"];
        normalImg = @[@"tab_home",@"tab_money",@"tab_mine"];
        viewControllers = @[@"PPMoneyMainViewController",@"PPRepayViewController",@"PPMoneyMineViewController"];
        titles = @[@"首页",@"还款",@"我的"];
    }else{
        selectedImg = @[@"tab_home_sel",@"tab_money_sel",@"shop-2",@"tab_mine_sel"];
        normalImg = @[@"tab_home",@"tab_money",@"shop-1",@"tab_mine"];
        viewControllers = @[@"PPMoneyMainViewController",@"PPRepayViewController",@"PPMarketViewController",@"PPMoneyMineViewController"];
        titles = @[@"首页",@"还款",@"贷款超市",@"我的"];
    }
    
    NSMutableArray *VControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<viewControllers.count; i++) {
        
        NSString *controller = viewControllers[i];
        
        Class class = NSClassFromString(controller);
        
        UIViewController *viewcontroller = [[class alloc]init];
        
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
        
        navc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"Main.bundle/%@",selectedImg[i]]];
        navc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"Main.bundle/%@",normalImg[i]]];
        
        navc.tabBarItem.title = titles[i];
        [VControllers addObject:navc];
        
    }
    
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.delegate = self;
    [tabbarController setViewControllers:VControllers];
    tabbarController.tabBar.tintColor = RGBACOLOR(249, 109, 79, 1);
    tabbarController.tabBar.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabbarController;
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *vc = nav.viewControllers.firstObject;
    if ([vc isKindOfClass:[NSClassFromString(@"PPMarketViewController") class]]) {
        NSDictionary *dic = @{@"location":@"贷款超市",@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString]};
        [CYNetwork getRequestUrl:@"statistic/statistics" paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
            
        }];
    }
    return YES;
}
@end

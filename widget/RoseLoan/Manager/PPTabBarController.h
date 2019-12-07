//
//  PPTabBarController.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTabBarController : UITabBarController
+(PPTabBarController *)shareInstance;
//- (UINavigationController *)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;
- (void)setMoneyRootViewControlle;
@end

NS_ASSUME_NONNULL_END

//
//  BaseViewController.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/14.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/** 返回按钮*/
@property (nonatomic,strong)UIButton *backBtn;
/** 导航栏的标题*/
@property (nonatomic,strong)NSString *navcTitle;
@property (nonatomic,strong) UIColor *navTitleColor;
/** 导航栏*/
- (void)confignNavc;
/** 导航栏返回键action*/
- (void)popAction;

/**
 加载数据时动画
 
 @param btnTitle btn标题
 */
- (void)showLoadingWith:(NSString *)btnTitle;
/**加载失败*/
- (void)showFailedLoad;
/** 没有数据时的视图*/
- (void)showNoDataWithNoDataImage:(NSString *)noDataImage tipStr:(NSString *)tipStr bottomBtnTitle:(NSString *)btnTitle viewCenterY:(CGFloat)centerY;
/** 隐藏tipView*/
- (void)hiddenTipView;
/** tipViewBottomAction
 *  loadFailed  YES指加载失败的方法，为NO是没有数据或其它情况的方法
 */
- (void)tipViewBottomAction:(BOOL)loadFailed;
/**
 重新加载数据
 */
-(void)ReacquireData;
@end

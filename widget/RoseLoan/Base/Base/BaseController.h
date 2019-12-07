//
//  BaseController.h
//  UddTrip
//
//  Created by 0X10 on 16/7/29.
//  Copyright © 2016年 scandy. All rights reserved.
//

/**
 *  controller的基类
 *  用于设置navbar的背景色
 *  跳转到登录页面等公用方法
 *  通知、定位、状态栏颜色色值
 *  设置返回键和手势
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PPUserModel.h"



@interface BaseController : UIViewController

/**
 *  导航栏的背景颜色，1是主题色 0是透明色
 */
@property (nonatomic, assign) BOOL isShowBlueColor;

/**
 *  @brief  失效
 */
@property (nonatomic, assign) BOOL useShowBgWhite;
/**
 *  @brief 失效
 */
@property (nonatomic, assign) BOOL isShowBgWhite;
/**
 *  是否显示tabbar
 */
@property (nonatomic,assign) Boolean isShowTabbar;

/**
 *  用户信息单利的Model
 */
@property (nonatomic,strong) PPUserModel *model;

/**自定义navbar的背景图*/
@property (nonatomic,strong) UIImageView *navImageView;

/**自定义navbar的leftBarButtonItem*/
@property (nonatomic,strong) UIButton *leftButton;

/**自定义navbar的rightBarButtonItem*/
@property (nonatomic,strong) UIButton *rightButton;

/**自定义navbar的title*/
@property (nonatomic,strong) UILabel *titleLabel;



/**
*   友盟统计的页面统计名称
*/
@property (nonatomic,strong) NSString *pageString;

/**
 *  需要登录的提示窗口
 */
//@property (nonatomic,strong)MSAlertController *actionSheet;

- (void)createNavBar;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;


/**
 *  停止加载
 */
- (void)stopLoadingAnimation;

/**
 *  移除navbar背景
 */
- (void)removeTopBlueView;

/**
 *  分享页面
 *
 *  @param url   url
 *  @param title 标题
 */

- (void)goLogin;
/**
 *   跳转到登录界面
 *
 *   @param callBackBlock 登录完成dismis后的回调
 */
- (void)goLoginAndCallBack:(void (^)())callBackBlock;

/**
 *  无动画的
 */
- (void)goLoginNoAnimated;


/**
 *   发通知
 */
- (void)  postNotificationWithName:(NSString*) name WithObject:(id) obj;

/**
 *   注册通知
 */
- (void)  registerNotificationWithName:(NSString*) name WithObject:(id) obj WithSel:(SEL) sel;

/**
 *  pop or push controller
 */
-(void) commonPopViewControllerWithAnimate:(BOOL) isAnimate;

-(void) commonPopToRootViewControllerWithAnimate:(BOOL) isAnimate;

-(void) commonPushViewControllerWithAnimate:(BOOL) isAnimate withVc:(UIViewController*) vc;

/**
 *  hides Navigationbar black line
 */
- (void)hidesBlackLine;

//networking connect notification
- (void)AFNetworkStatus;

/**
 *      set statusType
 */
- (void)setStatusBarLightStyple;

- (void)setStatusBarBlackStyple;

- (void)setNavigationBarStyple;


/**
 *  定位
 *
 */
- (NSString *)getCityName;

- (CLLocationCoordinate2D)getLocation;

- (void)leftBarButtonItemAction;


- (void)setBackButtonItemAction:(SEL)action andImageName:(NSString *)imgeName;

/**
 *  拨打客服电话
 *
 */
- (void)callToUDD;

- (void)initSmallNavBar;

- (void)initLoanNavigationBar;

- (void)initMoneyNavbar;

- (void)backPopViewController;
@end

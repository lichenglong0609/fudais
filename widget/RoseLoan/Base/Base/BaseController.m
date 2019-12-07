//
//  BaseController.m
//  UddTrip
//
//  Created by 0X10 on 16/7/29.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "BaseController.h"
#import "RTSpinKitAnimating.h"
#import "RTSpinKitView.h"
#import <AFNetworking.h>
#import "PPLoginViewController.h"
#import "UIImage+TBCityIconFont.h"


@interface BaseController ()<UIGestureRecognizerDelegate>
{
    RTSpinKitView *_spintView;
    
    UIImageView *_barImage;
    
    NSTimer * _flashMessageBtnTimer;
    id<UIGestureRecognizerDelegate> _delegate;
}

@property (nonatomic, strong) UIView *overlay;

@property (nonatomic,strong) UIAlertController *alertController;

@end


@implementation BaseController
- (UIAlertController *)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"400-990-6000"
                                                               message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callPhone];
        }];
        [_alertController addAction:cancleAction];
        [_alertController addAction:confirmAction];
    }
    return _alertController;
}

#pragma mark - viewController.lifeCircle

- (id)init{
    
    if (self = [super init]) {
        self.model = [PPUserModel sharedUser];
        if (self.navigationController.viewControllers.count>1) {
            self.hidesBottomBarWhenPushed = true;
        }
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self hidesBlackLine];
    [self setStatusBarLightStyple];
    
    if (self.isShowBlueColor) {//1c8de4
        
    }else{

    }
}

- (void)showCallPhone{
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)callPhone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-990-6000"]];
}

- (void)callToUDD {
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *temp=[phoneVersion componentsSeparatedByString:@"."];
    NSString *version = [temp firstObject];
    if ([version intValue] >= 10) {
        [self callPhone];
    } else {
        [self showCallPhone];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loadView{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Hotel.bundle/public_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    }
}

- (void)backToDismissViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  放在已经加载中，防止和设置透明的头有冲突
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}


#pragma mark - table.set
-(void)viewDidLayoutSubviews
{
    __block UITableView* table;
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            table=obj;
        }
    }];
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        [table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        [table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)goLogin{
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
    [self.navigationController presentViewController:loginNav animated:true completion:nil];
}



- (void)createNavBar
{
}

- (void)showLoadingAnimation
{
    
    RTSpinKitView *spinner = [[RTSpinKitView alloc]initWithStyle:RTSpinKitViewStyleWave color:[UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:1.0]];
    [self.view addSubview:spinner];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    spinner.center = CGPointMake(CGRectGetMidX(screenBounds), CGRectGetMidY(screenBounds));
    [spinner startAnimating];
    _spintView = spinner;
}

- (void)stopLoadingAnimation
{
    [_spintView stopAnimating];
    [_spintView removeFromSuperview];
}

-(void) commonPopViewControllerWithAnimate:(BOOL) isAnimate
{
    
    [self.navigationController popViewControllerAnimated:isAnimate];
}

-(void) commonPopToRootViewControllerWithAnimate:(BOOL) isAnimate
{
    
    [self.navigationController popToRootViewControllerAnimated:isAnimate];
}


-(void) commonPushViewControllerWithAnimate:(BOOL) isAnimate withVc:(UIViewController*) vc
{
    
    [self.navigationController pushViewController:vc animated:isAnimate];
}
- (void)  registerNotificationWithName:(NSString*) name WithObject:(id) obj WithSel:(SEL) sel
{
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:sel name:name object:obj];
}

- (void)  postNotificationWithName:(NSString*) name WithObject:(id) obj
{
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:name object:obj];
}

- (void)  removeNotificationByName:(NSString*) name withObject:(id) obj
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:obj];
}




/**
 *  隐藏navbar下面的黑线
 */
- (void)hidesBlackLine{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}
- (void)setRightButtonItemAction:(SEL)action withTitle:(NSString *)title setTitleColor:(UIColor *)titleColor{
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [rightBtn setTitle:title forState:UIControlStateNormal];
    
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = btnItem;
}

-(void)setLeftButtonItemAction:(SEL)action withTitle:(NSString *)title setTitleColor:(UIColor *)color{
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [leftBtn setTitle:title forState:UIControlStateNormal];
    
    [leftBtn setTitleColor:color forState:UIControlStateNormal];
    
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    
    [leftBtn sizeToFit];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    [leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
}
- (void)setBackButtonItemAction:(SEL)action{
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [backButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[UIImage imageNamed:@"Tabbar.bundle/btn_arrow"] forState:UIControlStateNormal];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)setBackButtonTtemActionForPopViewController{
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [backButton addTarget:self action:@selector(backPopViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[UIImage imageNamed:@"Tabbar.bundle/btn_arrow"] forState:UIControlStateNormal];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = btnItem;
    
}

- (void)setBackButtonItemAction:(SEL)action andImageName:(NSString *)imgeName{
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [backButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backButton setImage:[UIImage imageNamed:imgeName] forState:UIControlStateNormal];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)backPopViewController{
    [SVProgressHUD dismiss];
    [self commonPopViewControllerWithAnimate:YES];
}

- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
                
            default:
                break;
        }
        
    }] ;
}

- (void)setNavigationBarStyple{
    
    
}

- (void)setStatusBarLightStyple{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setStatusBarBlackStyple{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (NSString *)getCityName{
    
    //    WEAKSELF
    __block NSString *cityName;
//    [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
//
//        cityName = cityString;
//
//    }andErrorBlock:^(NSError *error) {
//
//        cityName = error.domain;
//    }];
//
    return cityName;
}

- (CLLocationCoordinate2D)getLocation{
    
    __block CLLocationCoordinate2D coordinate ;
    coordinate.latitude = 1000;
    coordinate.longitude = 1000;
    return coordinate;
}

//删除头上背景
- (void)removeTopBlueView{
    
    [self removeBackView:self.navigationController.navigationBar];
}

-(void)removeBackView:(UIView*)superView
{
    if([superView isKindOfClass:NSClassFromString(@"_UIBarBackground")]){
        
        UIView *backView = [superView viewWithTag:10001];
        if (backView) {
            [backView removeFromSuperview];
            backView = nil;
        }
        
    }else{
        for (UIView *view in superView.subviews)
        {
            [self removeBackView:view ];
        }
        
    }
    
}

- (void)initSmallNavBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Main.bundle/nav_bg1"]];
    _navImageView.userInteractionEnabled = true;
    [self.view addSubview:_navImageView];
    [_navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(80-20+StatusBarHeight);
    }];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.navigationController.viewControllers.count>1) {
        [_leftButton setImage:[UIImage imageNamed:@"Main.bundle/nav_back#"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backPopViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    [_navImageView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.equalTo(_navImageView).offset(19);
        make.top.equalTo(self.view).offset(StatusBarHeight+6);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navImageView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 32));
        make.right.equalTo(_navImageView).offset(-19);
        make.top.equalTo(_navImageView).offset(StatusBarHeight+6);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_navImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
        make.top.bottom.equalTo(_leftButton);
    }];
    
}

- (void)initLoanNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navImageView = [[UIImageView alloc] initWithImage:nil];
    _navImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _navImageView.userInteractionEnabled = true;
    [self.view addSubview:_navImageView];
    [_navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(80-20+StatusBarHeight);
    }];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.navigationController.viewControllers.count>1) {
        [_leftButton setImage:[[UIImage imageNamed:@"Main.bundle/nav_back#"] cy_fillImageColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [_leftButton setTitle:@" 借款"forState:UIControlStateNormal];
    }
    _leftButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_leftButton addTarget:self action:@selector(backPopViewController) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_navImageView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(32);
        make.left.equalTo(_navImageView).offset(19);
        make.top.equalTo(self.view).offset(StatusBarHeight+6);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navImageView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 32));
        make.right.equalTo(_navImageView).offset(-19);
        make.top.equalTo(_navImageView).offset(StatusBarHeight+6);
    }];
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_navImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftButton.mas_right);
        make.centerX.equalTo(self.view);
        make.top.bottom.equalTo(_leftButton);
    }];
    
}


- (void)initMoneyNavbar{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Main.bundle/nav_bg"]];
    _navImageView.userInteractionEnabled = true;
    [self.view addSubview:_navImageView];
    [_navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(PPIWIDTHORHEIGHT(320));
    }];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_leftButton setImage:[UIImage imageNamed:@"Main.bundle/nav_back#"] forState:UIControlStateNormal];
//    [_leftButton addTarget:self action:@selector(backPopViewController) forControlEvents:UIControlEventTouchUpInside];
    [_navImageView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.equalTo(_navImageView).offset(19);
        make.top.equalTo(self.view).offset(StatusBarHeight+6);
    }];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navImageView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 32));
        make.right.equalTo(_navImageView).offset(-19);
        make.top.equalTo(_navImageView).offset(StatusBarHeight+6);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_navImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
        make.top.bottom.equalTo(_leftButton);
    }];
    
}

-(void)dealloc{
    NSLog(@"---dealloc:%@-----",self.class);
}

- (void)injected {
    NSLog(@"injected Some thing....");
    [self viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  BaseViewController.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/14.
//  Copyright © 2019 cython. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkAccessResultView.h"

@interface BaseViewController ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NetworkAccessResultView *tipView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.navigationController.navigationBar.translucent = NO;
    [self confignNavc];
}

#pragma mark - 导航栏
- (void)confignNavc{
    
    //当navc栈内的元素大于一个的时候才会出现返回按钮
    if (self.navigationController.viewControllers.count > 1 || [kWindow.rootViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 30, 30);
        [_backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    }
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    self.navigationItem.titleView = _titleLabel;
}
- (void)setNavcTitle:(NSString *)navcTitle{
    _navcTitle = navcTitle;
    _titleLabel.text = _navcTitle;
    [_titleLabel sizeToFit];
}
-(void)setNavTitleColor:(UIColor *)navTitleColor{
    _navTitleColor = navTitleColor;
    _titleLabel.textColor = navTitleColor;
}
- (void)popAction{
    if ([kWindow.rootViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
        if ([kWindow.rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(NetworkAccessResultView *)tipView{
    if (!_tipView) {
        _tipView = [[NetworkAccessResultView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _tipView;
}
#pragma mark - 加载动画

/**
 加载数据时动画

 @param btnTitle btn标题
 */
- (void)showLoadingWith:(NSString *)btnTitle{
    if (![self.view.subviews containsObject:self.tipView]) {
        [self.view addSubview:self.tipView];
    }
    NSArray *ary0 = @[];
    [self.tipView loadWith:ary0 and:nil and:btnTitle];
}
/** 加载失败的图片*/
- (void)showFailedLoad{
    
    if(![self.view.subviews containsObject:self.tipView]){
        [self.view addSubview:self.tipView];
    }
    __weak typeof(self)weakSelf = self;
    [self.tipView failedWith:@"NetworkAccessError" and:@"你的网络感觉太冷\n出去过冬了..."];
    self.tipView.bottomBtnAction = ^{
        [weakSelf tipViewBottomAction:YES];
        [weakSelf ReacquireData];
    };
}
/** 没有数据时的视图*/
- (void)showNoDataWithNoDataImage:(NSString *)noDataImage tipStr:(NSString *)tipStr bottomBtnTitle:(NSString *)btnTitle viewCenterY:(CGFloat)centerY{
    
    if(![self.view.subviews containsObject:self.tipView]){
        [self.view addSubview:self.tipView];
    }
    __weak typeof(self)weakSelf = self;
    [self.tipView noDataWithNoDataImage:noDataImage tipStr:tipStr bottomBtnTitle:btnTitle viewCenterY:centerY];
    self.tipView.bottomBtnAction = ^{
        [weakSelf tipViewBottomAction:NO];
        [weakSelf ReacquireData];
    };
}
/** 隐藏tipView*/
- (void)hiddenTipView{
    [self.tipView removeFromSuperview];
    [self setTipView:nil];
}
/** tipViewBottomAction
 *  loadFailed  YES指加载失败的方法，为NO是没有数据或其它情况的方法
 */
- (void)tipViewBottomAction:(BOOL)loadFailed{

}
-(void)ReacquireData{
    
}
@end

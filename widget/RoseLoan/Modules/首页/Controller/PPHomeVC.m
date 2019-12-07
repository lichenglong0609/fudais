//
//  PPHomeVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPHomeVC.h"
#import "PPhomeView.h"
#import "PPDeviceInformation.h"

#import "UDDGetAddressBookTasks.h"
#import "UDDAddressBookData.h"
//#import <FCUUID.h>
//#import "PPLoanModel.h"
#import "NSDictionary+PPDeleteNull.h"

#import "PPCertificationVC.h"
#import "WebViewController.h"
#import "PPAmountApprovalVC.h"
#import "UIImage+Color.h"
#import "PPSign.h"
#import "PPCheckSign.h"
#import "PPLoginViewController.h"
@interface PPHomeVC ()<ChangeNavDelegate>
@property (nonatomic,strong) PPHomeView *homeView;
@property (nonatomic,strong) PPUserModel *model;
@property (nonatomic,strong) NSMutableDictionary *infoDic;
@property (nonatomic, strong) UIImage *navImage;
@property (nonatomic, strong) UIImage *whileNavImage;
@end

@implementation PPHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"首页";
    self.model = [PPUserModel sharedUser];
    [self.view addSubview:self.homeView];
    SetDefaults(@"isMainFresh", [NSNumber numberWithBool:true]);
    self.navImage = [self gradientImageWithColors:@[[UIColor clearColor],[UIColor clearColor]] rect:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavcHeight)];
    self.whileNavImage = [self gradientImageWithColors:@[[UIColor whiteColor],[UIColor whiteColor]] rect:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavcHeight)];
    self.navTitleColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:self.navImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self reashData];
    [self loadIndexData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:self.whileNavImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 懒加载
-(PPHomeView *)homeView{
    if (!_homeView) {
        _homeView = [[PPHomeView alloc] initWithFrame:CGRectMake(0, -kStatusBarAndNavcHeight, kScreenWidth, kScreenHeight - KTabbarHeight+kStatusBarAndNavcHeight)];
        _homeView.infoDic = @{};
        _homeView.navDelegate = self;
        __weak typeof(self) weakSelf = self;
        _homeView.viewProductDetailsBlock = ^(PPADModel *model) {
            if (self.model.userId != nil && self.model.userId.intValue > 0) {
                WebViewController *vc = [[WebViewController alloc] init];
                vc.url = strOrEmpty(model.url);
                vc.titleStr = model.name;
                [vc setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:vc animated:true];
                [weakSelf statisticsPV:[NSString stringWithFormat:@"%ld",(long)model.id]];
            }else{
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
                [weakSelf.navigationController presentViewController:loginNav animated:true completion:nil];
            }
        };
        _homeView.borrowMoneyBlock = ^{
            [weakSelf stepPush];
        };
        _homeView.clickTopBannerBlock = ^(NSInteger index){
            NSArray *bannerS = weakSelf.homeView.infoDic[@"topBanners"];
            [weakSelf toShowBanner:index with:bannerS];
        };
        _homeView.clickBannerBlock = ^(NSInteger index) {
            NSArray *bannerS = weakSelf.homeView.infoDic[@"middleBanners"];
            [weakSelf toShowBanner:index with:bannerS];
        };
    }
    return _homeView;
}
-(NSMutableDictionary *)infoDic{
    if (!_infoDic) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}

-(void)changeNavBarWithScroll:(UIScrollView *)scrollView{
    float yOffset = scrollView.contentOffset.y;
    float height =  kScreenWidth/2;
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavcHeight);
    if (yOffset<(height-kStatusBarAndNavcHeight)) {
        float alpha = yOffset/(height-kStatusBarAndNavcHeight);
        
        NSArray *colors = @[rgba(255, 255, 255, alpha),rgba(255, 255, 255, alpha)];
        UIImage *image = [self gradientImageWithColors:colors rect:rect];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navTitleColor = rgba(0, 0, 0, alpha);
    }else{
        NSArray *colors = @[rgba(255, 255, 255, 1),rgba(255, 255, 255, 1)];
        UIImage *image = [self gradientImageWithColors:colors rect:rect];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.navTitleColor = rgba(0, 0, 0, 1);
    }
}
- (UIImage *)gradientImageWithColors:(NSArray *)colors rect:(CGRect)rect
{
    if (!colors.count || CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = rect;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    NSMutableArray *mutColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [mutColors addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = [NSArray arrayWithArray:mutColors];
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.opaque, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
-(void)clickProject:(NSDictionary *)dic{
    if (self.model.userId != nil && self.model.userId.intValue > 0) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.url = strOrEmpty(dic[@"url"]);
        vc.titleStr = dic[@"title"];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:true];
        [self statisticsBanner:[NSString stringWithFormat:@"%@",dic[@"id"]]];
    }else{
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
        [self.navigationController presentViewController:loginNav animated:true completion:nil];
    }
}
#pragma mark - 跳转方法
-(void)toSigningVC:(NSString *)url{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = url;
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void)toShowBanner:(NSInteger)row with:(NSArray *)bannerArr{
    NSDictionary *dic = bannerArr[row];
    NSString *url = dic[@"url"];
    if(url != nil && url != NULL && url.length > 0 && ![url isEqualToString:@"<null>"]){
        if (self.model.userId != nil && self.model.userId.intValue > 0) {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = url;
            webVC.titleStr = dic[@"title"];
            [webVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webVC animated:YES];
            [self statisticsBanner:[NSString stringWithFormat:@"%@",dic[@"id"]]];
        }else{
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
            [self.navigationController presentViewController:loginNav animated:true completion:nil];
        }
    }
}
/**
 统计PV
 */
-(void)statisticsPV:(NSString *)name{
    NSDictionary *dic = @{@"userId":[PPUserModel sharedUser].userId,@"location":name,@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString],@"type":@"product"};
    [CYNetwork getRequestUrl:KNETstatisticPvUv paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
        
    }];
}
-(void)statisticsBanner:(NSString *)name{
    NSDictionary *dic = @{@"userId":[PPUserModel sharedUser].userId,@"location":name,@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString],@"type":@"banner"};
    [CYNetwork getRequestUrl:KNETstatisticPvUv paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
        
    }];
}
//点击我要贷款，根据step判断跳转到哪一步。
- (void)stepPush{
    self.model = [PPUserModel sharedUser];
    if (self.model.userId == nil || self.model.userId.length == 0) {
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
        [self.navigationController presentViewController:loginNav animated:true completion:nil];
    }else{
        [[NetworkSingleton sharedManager] getData:nil url:[NSString stringWithFormat:@"%@%@?mobile=%@",kNetBaseURL,KNetChannel,[PPUserModel sharedUser].userLogin] successBlock:^(NSDictionary *responseObject, NSInteger statusCode) {
            NSDictionary *data = responseObject[@"data"];
            NSString *channel = [NSString stringWithFormat:@"%@",data[@"channel"]];
            NSString *url = [NSString stringWithFormat:@"%@puhui/mobile/collections.html?name=%@&mobileNo=%@&mediaSourceCode=000%@",@"http://47.104.13.70/",@"客户",self.model.userLogin,channel];
            NSString *encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            WebViewController *vc = [[WebViewController alloc] init];
            vc.url = encodingString;
            vc.titleStr = @"在线申请";
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:true];
        } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
            
        }];
    }
}

#pragma mark - 加载数据

- (void)loadData{
    [CYNetwork postRequestUrlMethod:KNetCreditResult paramters:@{@"userId":strOrEmpty([PPUserModel sharedUser].userId)} callBack:^(BOOL success, NSString *msg, id data) {

        [SVProgressHUD dismiss];
        if (success) {
            SetDefaults(@"isMainFresh", [NSNumber numberWithBool:false]);
//            _loanModel = [PPLoanModel yy_modelWithDictionary:data];
        }else{
            //            [SVProgressHUD showErrorWithStatus:msg];
            NSLog(@"----%@----",msg);
        }
    }];
}
- (void)reashData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    __weak typeof(self) weakSelf = self;
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = [PPSign getRequestParam:@{@"userId":[PPUserModel sharedUser].userId == nil ? @"" : [PPUserModel sharedUser].userId ,@"version":nowVer,@"client":@"ios"}];
    NSString * encodingString = [param[@"param"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?&param=%@",kNetBaseURL,KNetQueryUserDetails,encodingString];
    NSString * postUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
    
    // 2.封装请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.f]; // post
    [request setHTTPMethod:@"POST"];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([PPCheckSign checkSignData:dic]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
                NSDictionary *dictionary =  [dict deleteNull];
                
                PPUserModel *model = [PPUserModel yy_modelWithDictionary:dictionary];
                [model saveUserData];
                [weakSelf loadData];
            }else{
                [weakSelf loadData];
            }
            
        }else{
            [weakSelf loadData];
        }
        dispatch_semaphore_signal(semaphore);//不管请求状态是什么，都得发送信号，否则会一直卡着进程
    }];
    [task resume];
}
-(void)loadIndexData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    [CYNetwork postRequestUrlMethod:KNetIndex paramters:@{@"userId":strOrEmpty([PPUserModel sharedUser].userId)} callBack:^(BOOL success, NSString *msg, id data) {
        [SVProgressHUD dismiss];
        if (success) {
            SetDefaults(@"isMainFresh", [NSNumber numberWithBool:false]);
            NSDictionary *dic = data;
            self.infoDic = [dic copy];
            self.homeView.infoDic = self.infoDic;
        }else{
            NSLog(@"----%@----",msg);
            [self showFailedLoad];
        }
    }];
}

-(void)ReacquireData{
    [super ReacquireData];
    [self hiddenTipView];
    
    [self reashData];
    [self loadIndexData];
}
@end

//
//  PPPersonalCenterVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPPersonalCenterVC.h"
#import "PPPersonalCenterView.h"
#import "PPUserModel.h"

#import "PPLoginViewController.h"
#import "WebViewController.h"
#import "PPPersonalInfomationVC.h"
#import "PPCertificationVC.h"
#import "PPMyBankCardVC.h"
#import "PPNoBankCardInfoVC.h"
#import "AboutUsViewController.h"
#import "PPAmountApprovalVC.h"
static NSString * const ConsumerHotline = @"17197756685";
@interface PPPersonalCenterVC ()<ClickTableViewCellDelegate>
@property (nonatomic,strong) PPPersonalCenterView *personView;
@end

@implementation PPPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.personView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setUpUI{
    [self.view addSubview:self.personView];
    [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - KTabbarHeight);
    }];
}
#pragma mark - 懒加载
-(PPPersonalCenterView *)personView{
    if (!_personView) {
        _personView = [[PPPersonalCenterView alloc] init];
        _personView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _personView.toLoginBlock = ^{
            [weakSelf goLogin];
        };
        _personView.tosignoutBlock = ^{
            [weakSelf signOut];
        };
    }
    return _personView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)row {
    if(row<=3 && ([PPUserModel sharedUser].userLogin == nil || [PPUserModel sharedUser].userLogin.length == 0)){
        [self goLogin];
        return;
    }
    switch (row) {
        case 0:
            [self showPersonalInfoVC];
            break;
        case 1:
            [self viewPrivacyAgreement];
            break;
        case 2:
            [self toAboutUs];
            break;
        default:
            break;
    }
}
#pragma mark - 跳转
-(void)signOut{
    [[PPUserModel sharedUser] checkOutLogin];
    [self goLogin];
}
- (void)goLogin{
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
    [self.navigationController presentViewController:loginNav animated:true completion:nil];
}
-(void)showPersonalInfoVC{
    if ([PPUserModel sharedUser].userCard.length > 0) {
        PPPersonalInfomationVC *vc = [[PPPersonalInfomationVC alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([PPUserModel sharedUser].userAuthentication == 0 || [PPUserModel sharedUser].userAuthentication == 3) {
        [self toVericiedVC];
    }else{
        PPPersonalInfomationVC *vc = [[PPPersonalInfomationVC alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)toMyBankCardVC{
    if ([PPUserModel sharedUser].userAuthentication == 0 || [PPUserModel sharedUser].userAuthentication == 3) {
        PPNoBankCardInfoVC *noBcVc = [[PPNoBankCardInfoVC alloc] init];
        [noBcVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:noBcVc animated:YES];
    }else{
        PPMyBankCardVC *vc = [[PPMyBankCardVC alloc] init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//去认证
-(void)toVericiedVC{
    PPCertificationVC *verCon = [[PPCertificationVC alloc] init];
    verCon.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:verCon animated:true];
}

-(void)toAboutUs{
    AboutUsViewController *aboutUsVc = [[AboutUsViewController alloc] init];
    aboutUsVc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:aboutUsVc animated:true];
}
/**
 查看隐私协议
 */
-(void)viewPrivacyAgreement{
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleStr = @"隐私协议";
    webVC.url = [NSString stringWithFormat:@"http://101.132.108.30/wallet/YinSiAgreement_Apply.html"];
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
}
@end

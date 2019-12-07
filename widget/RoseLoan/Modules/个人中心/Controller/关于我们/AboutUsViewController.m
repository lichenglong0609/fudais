//
//  AboutUsViewController.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "AboutUsViewController.h"
#import "PPAboutUsView.h"
#import "UIImage+Color.h"
@interface AboutUsViewController ()
@property (nonatomic,strong) PPAboutUsView *aboutUsView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navcTitle = @"关于我们";
    [self setUpUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)setUpUI{
    [self.view addSubview:self.aboutUsView];
    [self.aboutUsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kStatusBarAndNavcHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - kStatusBarAndNavcHeight);
    }];
}
#pragma mark - 懒加载
-(PPAboutUsView *)aboutUsView{
    if (!_aboutUsView) {
        _aboutUsView = [[PPAboutUsView alloc] init];
        _aboutUsView.backgroundColor = [UIColor redColor];
    }
    return _aboutUsView;
}
@end

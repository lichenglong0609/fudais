//
//  PPPurchaseViewController.m
//  PostProduct
//
//  Created by Risk on 2018/8/23.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "PPPurchaseViewController.h"

@interface PPPurchaseViewController ()


@end

@implementation PPPurchaseViewController

- (instancetype)init{
    self = [super init];
    if (self) {
//        self.fd_prefersNavigationBarHidden = true;
        self.hidesBottomBarWhenPushed = true;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoanNavigationBar];
    [self.titleLabel setMinimumFontSize:0.7];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navImageView.mas_bottom);
    }];
    if (self.urlString.length>0) {
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlString,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        
        [self loadWebview:self.webView requestFromUrlstring:encodedString];
    }else if(self.docType.length>0){
        [self loadRequest:self.docType];
    }else if(self.urlDictInfo){
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.urlDictInfo[@"contractUrl"],(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
        [self loadWebview:self.webView requestFromUrlstring:encodedString];
        self.titleLabel.text = _urlDictInfo[@"contractName"];
        [self.leftButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequest:(NSString *)docType{
    [SVProgressHUD showWithStatus:@"合同获取中..."];
    [CYNetwork postRequestUrlMethod:KNetQueryContract paramters:@{@"userId":strOrEmpty(self.model.userId),@"contractPage":docType} callBack:^(BOOL success, NSString *msg, id data) {
        if (success) {
            if ([data[@"code"] intValue] == 200) {
                [SVProgressHUD dismiss];
                NSArray *arr = data[@"bizData"];
                if (arr.count>0) {
                    NSDictionary *dic = arr.firstObject;
                    self.titleLabel.text = strOrEmpty(dic[@"contractName"]);
                    [self.leftButton setTitle:@"" forState:UIControlStateNormal];
                    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(32, 32));
                    }];
                    NSString * encodingString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)strOrEmpty(dic[@"contractUrl"]),(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
                    [self loadWebview:self.webView requestFromUrlstring:encodingString];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:data[@"msg"]];
            }
        }else{
            [SVProgressHUD showWithStatus:msg];
        }
    }];

}
- (void)backPopViewController{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }else{
        [super leftBarButtonItemAction];
    }
}
@end

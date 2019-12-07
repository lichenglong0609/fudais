//
//  WebViewController.m
//  ijointoo
//
//  Created by ijointoo on 2017/10/12.
//  Copyright © 2017年 demo. All rights reserved.
//

#import "WebViewController.h"
#import "UIImage+Color.h"
//#import "UMWKHybrid.h"
#import <StoreKit/StoreKit.h>
@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate,SKStoreProductViewControllerDelegate>

@property (nonatomic,strong)UIButton *closeBtn;

@end

@implementation WebViewController

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        if (@available(iOS 11.0, *)) {
            float bottomH = self.view.safeAreaInsets.bottom;
            if (SCREEN_HEIGHT >= 812) {
                bottomH = 34;
            }
            _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kScreenHeight - bottomH)];
        } else {
            _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        }
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 42, self.view.frame.size.width, 2)];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 30, 30);
        [_closeBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        _closeBtn.contentMode = UIViewContentModeScaleAspectFit;
        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage pp_imageWithColor:[UIColor lightGrayColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.progressView.hidden = YES;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];// 关闭状态栏网络请求提示
}

-(void)setUrl:(NSString *)url{
    _url = url;
    if ([_url rangeOfString:@"mobile="].location == NSNotFound) {
        if ([_url rangeOfString:@"?"].location == NSNotFound) {
            _url = [_url stringByAppendingFormat:@"?mobile=%@",[PPUserModel sharedUser].userLogin];
        }else{
            _url = [_url stringByAppendingFormat:@"&mobile=%@",[PPUserModel sharedUser].userLogin];
        }
    }else{
        _url = url;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navcTitle = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    if (@available(iOS 11.0, *)) {
        float bottomH = self.view.safeAreaInsets.bottom;
        if (SCREEN_HEIGHT >= 812) {
            bottomH = 34;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-bottomH, SCREEN_WIDTH, bottomH)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
        }
    }
    if ([self.url containsString:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.url]]];
    }
    
    [self.navigationController.navigationBar addSubview:self.progressView];
}
-(void)confignNavc{
    [super confignNavc];
}

- (void)popAction{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - KVO监听函数
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"title"]) {
//        [self setNavcTitle:self.webView.title];
//    }
//}

#pragma mark = WKNavigationDelegate
//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    self.progressView.hidden = NO;
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if ([url containsString:@"https://itunes.apple.com"] || [url containsString:@"itms-apps://itunes.apple.com"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *appID = [url componentsSeparatedByString:@"id"].lastObject;
        NSString *idStr = [appID componentsSeparatedByString:@"?"].firstObject;
        SKStoreProductViewController *appStoreVc = [[SKStoreProductViewController alloc] init];
        appStoreVc.delegate = self;
        [SVProgressHUD show];
        [appStoreVc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : idStr} completionBlock:^(BOOL result, NSError *error) {
            //block回调
            if(error){
                NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
            }else{
                [SVProgressHUD dismiss];
                [self presentViewController:appStoreVc animated:YES completion:^{
                    
                }];
            }
        }];
    }else if([url containsString:@".plist"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        NSString *parameters = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        [UMWKHybrid execute:parameters webView:webView];
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
//在响应完成时，调用的方法。如果设置为不允许响应，web内容就不会传过来
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//接收到服务器跳转请求之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];// 关闭状态栏网络请求提示
    self.progressView.progress = 0;
}
//当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.backBtn],[[UIBarButtonItem alloc]initWithCustomView:self.closeBtn]];
    }
    else{
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.backBtn]];
    }
}
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
    if (webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.backBtn],[[UIBarButtonItem alloc]initWithCustomView:self.closeBtn]];
    }else{
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.backBtn]];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.progressView.hidden = YES;
//    [MBProgressHUD showError:error.localizedDescription toView:self.view];
}
#pragma mark =========wkUIdelegate实现：
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"我是“警告”提示框");
    NSLog(@"%@", message);
    // 确定按钮
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        /*
         默认为yes。completionHandler(YES),允许加载 允许用户选择后的操作
         completionHandler(NO),不允许加载  返回用户选择前的操作
         */
        completionHandler();
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark Confirm选择框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    NSLog(@"我是 选择 提示框");
    NSLog(@"%@", message);
    // 按钮
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户选择前的信息
        completionHandler(NO);
    }];
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOK];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark TextInput输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    NSLog(@"我是输入提示框3");
    // alert弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    // 确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 返回用户输入的信息
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }]];
    // 显示
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end


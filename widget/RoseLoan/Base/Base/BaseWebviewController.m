//
//  BaseWebviewController.m
//  UddTrip
//
//  Created by uddtrip on 16/8/5.
//  Copyright © 2016年 scandy. All rights reserved.
//



#import "BaseWebviewController.h"
#import "AppDelegate.h"
//#import "UMWKHybrid.h"
#import <StoreKit/StoreKit.h>
@interface BaseWebviewController ()<WKUIDelegate,SKStoreProductViewControllerDelegate>

@property (strong, nonatomic) UIProgressView *progressView;


@end

@implementation BaseWebviewController

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.webView.frame.size.width, 2);
        _progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        _progressView.progressTintColor = [UIColor blueColor];
        // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
        [_progressView setProgress:0.1 animated:YES];
    }
    return _progressView;
}

- (UIAlertController *)alertControl{
    if (_alertControl == nil) {
        _alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的订单尚未填写完成,是否确定要离开当前页面" preferredStyle:UIAlertControllerStyleAlert];
        WEAKSELF
        [_alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (_webView.canGoBack) {
                [_webView goBack];
            }else{
                [weakSelf commonPopViewControllerWithAnimate:YES];
            }
        }]];
        
        [_alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
    }
    return _alertControl;
    
}


- (id)init{
    
    if ([super init]) {
        _typeIdArray = [[NSMutableArray alloc]init];
        _titleArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (WKWebView *)webView{
    if (!_webView) {
        
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (GFPlaceholderView *)placeHolderView{
    
    if (_placeHolderView == nil) {
        _placeHolderView = [[GFPlaceholderView alloc]initWithFrame:self.view.bounds];
        _placeHolderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    
    return _placeHolderView;
}

- (void)loadView{
    
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.placeHolderView];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Hotel.bundle/public_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    }
    
}

- (void)leftBarButtonItemAction{
    
    if (!_webView.canGoBack) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self.placeHolderView hideNoAnimation];
    [self.typeIdArray removeLastObject];
    [self.titleArray removeLastObject];
    
    [self reloadTypeId];
    [_webView goBack];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addSubview:self.progressView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setCookie];
    if (_bridge) { return; }
    [self renderButtons:_webView];
}

- (void) registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler{
    [_bridge registerHandler:handlerName handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"这个是JS 传给你的数据:%@",data);
    }];
}

- (void)objectReciveData:(id)data{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [webView.scrollView scrollsToTop];
    
    if ([[NSString stringWithFormat:@"%@",webView.URL] rangeOfString:@"tel:"].location != NSNotFound) {
        
        NSString *url = [NSString stringWithFormat:@"%@",webView.URL];
        url = [NSString stringWithFormat:@"tel://%@",[url stringByReplacingOccurrencesOfString:@"tel:" withString:@""]];
        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [callPhoneWebVw loadRequest:request];
        [self.view addSubview:callPhoneWebVw];
        
    }else{
        
        self.title = @"加载中...";
        [self.placeHolderView showLoadingView];
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.placeHolderView hideNoAnimation];
    [webView evaluateJavaScript:@"setWebViewFlag()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    self.title = @"加载失败...";
    [_placeHolderView showNoNetWorkViewWithSubtitle:@"加载失败，请重试"];
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadLocationPage:(WKWebView*)webView pathForResource:(NSString *)html ofType:(NSString *)type {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:html ofType:type];
    
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)loadWebview:(WKWebView *)webview requestFromUrlstring:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webview loadRequest:request];
    
}

- (void)webview:(WKWebView *)webview registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler{
    
}

/**
 *  @brief  判断返回webview是否可以返回。
 *
 *  @return 是否可以在webview中执行goBack操作
 */
-(BOOL)navigationShouldPopOnBackButton{
    
    if (!_webView.canGoBack) {
        return YES;
    }
    
    [self.placeHolderView hideNoAnimation];
    [self.typeIdArray removeLastObject];
    [self.titleArray removeLastObject];
    
    [self reloadTypeId];
    [_webView goBack];
    
    return NO;
}

- (void)setCookie{
    NSString *cookie = [NSString stringWithFormat:@"document.cookie = 'userId=%@';document.cookie = 'tokenId=%@';document.cookie = 'isPublic=%@'",[PPUserModel sharedUser].userId,[PPUserModel sharedUser].tokenId,@""];
    WKUserScript *cookieScript = [[WKUserScript alloc]initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [_webView.configuration.userContentController addUserScript:cookieScript];
    
}

- (void)reloadTypeId{
    
}

/**
 *  @brief 通过交互框架，发送userId和tokenId给H5
 */
- (void)senderDataToH5{
    
    [self.bridge callHandler:@"native_call_webview" data:[NSString stringWithFormat:@"{\"param\":{\"typeId\":\"10152\",\"userId\":\"%@\",\"tokenId\":\"%@\"}}",[PPUserModel sharedUser].userId,[PPUserModel sharedUser].tokenId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WKWebView 代理方法


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([url containsString:@"https://itunes.apple.com/app"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *appID = [url componentsSeparatedByString:@"id"].lastObject;
        SKStoreProductViewController *appStoreVc = [[SKStoreProductViewController alloc] init];
        appStoreVc.delegate = self;
        [SVProgressHUD show];
        [appStoreVc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : appID} completionBlock:^(BOOL result, NSError *error) {
            //block回调
            if(error){
                NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
            }else{
                [SVProgressHUD dismiss];
                [self presentViewController:appStoreVc animated:YES completion:^{

                }];
            }
        }];
    }else{
        NSString *parameters = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [UMWKHybrid execute:parameters webView:webView];
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
- (void)dealloc {
    
    // 最后一步：移除监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}


#pragma mark - KVO监听
// 第三部：完成监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"打印测试进度值：%f", newprogress);
        
        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) { // 标题
        
        self.title = self.webView.title;
    } else { // 其他
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end

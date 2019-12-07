//
//  BaseWebviewController.h
//  UddTrip
//
//  Created by uddtrip on 16/8/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

/*!
 *  @brief  主要用于加载webview的基类
 *          包含加载本地webview，网络url 以及设置cookie 调用三方框架回调
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WKWebViewJavascriptBridge.h>
#import "BaseController.h"
#import "GFPlaceholderView.h"


@interface BaseWebviewController : BaseController<WKNavigationDelegate>

/** 三方框架用于js和webview桥接 */
@property WKWebViewJavascriptBridge* bridge;

/** 共用的webview */
@property (nonatomic,strong) WKWebView *webView;

/** 本地保存的typeId */
@property (nonatomic, strong) NSMutableArray *typeIdArray;

/** 保存的title */
@property (nonatomic, strong) NSMutableArray *titleArray;

/** 用于webview的刷新的placeholder */
@property (nonatomic, strong) GFPlaceholderView *placeHolderView;

/** 从订单填写页的返回时的弹框 */
@property (nonatomic, strong) UIAlertController *alertControl;

/**
 *  @brief 用本地保存的typeId 刷新webview
 */
- (void)reloadTypeId;

/**
 *  wkwebview load loaction resource
 */
- (void)loadLocationPage:(WKWebView*)webView pathForResource:(NSString *)html ofType:(NSString *)type;


/**
 *  wkwebview load network resource
 */

- (void)loadWebview:(WKWebView *)webview requestFromUrlstring:(NSString *)urlString;



/**
 *  Wkwebview load  fail or success status
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;


/**
 *  @brief webview加载完成
 *
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;


/**
 *  order to the  handlername to load different type ,we  can push native view
 *
 *  @param webview     wkwebview
 *  @param handlerName handler name for judge different type native view
 *  @param handler     to translate for js to native data
 */
- (void)webview:(WKWebView *)webview registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;

/**
 *  @brief 将网络到的tokenId和userId保存在本地cookie中
 */
- (void)setCookie;


/**
 *  @brief  用于子类直接调用
 *
 *  @param handlerName 握手名称
 *  @param handler     交互的回调的block
 */
- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;

@end

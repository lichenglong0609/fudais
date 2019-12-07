//
//  WebViewController.h
//  ijointoo
//
//  Created by ijointoo on 2017/10/12.
//  Copyright © 2017年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseController.h"
#import "BaseViewController.h"

@interface WebViewController : BaseViewController


@property (nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)UIProgressView *progressView;

@property (nonatomic,strong)NSString *url;

@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,assign)BOOL isNeedShare;//是否需要分享

@property (nonatomic,assign)NSDictionary *shareDic;//title image content url

- (void)confignNavc;

@end

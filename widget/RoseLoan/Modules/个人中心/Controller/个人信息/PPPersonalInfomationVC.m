//
//  PPPersonalInfomationVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/20.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPPersonalInfomationVC.h"
#import "PPUserModel.h"
#import "PPCheckSign.h"
#import "NSDictionary+PPDeleteNull.h"
@interface PPPersonalInfomationVC ()
@property (weak, nonatomic) IBOutlet UILabel *actualName;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@end

@implementation PPPersonalInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"个人信息";
    self.btnHeight.constant = AdaptW(44);
    self.confirmBtn.titleLabel.font = FontPingFangSCMedium(16);
    if ([PPUserModel sharedUser].userCard.length>0) {
        [self loadData];
    }else{
        [self reashData];
    }
}

/**
 为保护用户隐私，身份证号码中间用（*）号替换
 
 @param idCardNumber 完整的身份证号码串 （idCard）
 
 @return 隐私身份证号码
 */
-(NSString *)idCardNumber:(NSString *)idCardNumber {
    NSString *tempStr = @"";
    for (int i  = 0; i < idCardNumber.length - 7; i++) {
        tempStr = [tempStr stringByAppendingString:@"*"];
    }
    //身份证号取前三位和后四位 中间拼接 tempSt（*）
    idCardNumber = [NSString stringWithFormat:@"%@%@%@", [idCardNumber substringToIndex:3], tempStr, [idCardNumber substringFromIndex:idCardNumber.length - 4]];
    return idCardNumber;
}
- (IBAction)confirm:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadData{
    self.idCardLabel.text = [self idCardNumber:[PPUserModel sharedUser].userCard];
    NSString *nameStr = [PPUserModel sharedUser].userRealname;
    NSMutableString *name = [[NSMutableString alloc] init];
    for (int i = 0; i<nameStr.length; i++) {
        if (i == 0) {
            [name appendString:[nameStr substringToIndex:1]];
        }else{
            [name appendString:@"*"];
        }
    }
    self.actualName.text = name;
}
- (void)reashData{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    __weak typeof(self) weakSelf = self;
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = [PPSign getRequestParam:@{@"userId":[PPUserModel sharedUser].userId,@"version":nowVer,@"client":@"ios"}];
    NSString * encodingString = [param[@"param"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?&param=%@",kNetBaseURL,KNetQueryUserDetails,encodingString];
    NSString * postUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
    
    // 2.封装请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.f]; // post
    [request setHTTPMethod:@"POST"];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([PPCheckSign checkSignData:dic]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
                NSDictionary *dictionary =  [dict deleteNull];
                
                PPUserModel *model = [PPUserModel yy_modelWithDictionary:dictionary];
                [model saveUserData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.idCardLabel.text = [weakSelf idCardNumber:dict[@"userCard"]];
                    NSString *nameStr = dict[@"userRealname"];
                    NSMutableString *name = [[NSMutableString alloc] init];
                    for (int i = 0; i<nameStr.length; i++) {
                        if (i == 0) {
                            [name appendString:[nameStr substringToIndex:1]];
                        }else{
                            [name appendString:@"*"];
                        }
                    }
                    weakSelf.actualName.text = name;
                });
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
-(void)popAction{
    PPTabBarController *tabBar = (PPTabBarController *)kWindow.rootViewController;
    if (tabBar.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

//
//  AppDelegate+AppLifeCircle.m
//  UddTrip
//
//  Created by uddtrip on 16/8/4.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "AppDelegate+AppLifeCircle.h"
#import "NSDictionary+PPDeleteNull.h"
#import "FMDBManager.h"
#import "PPUserModel.h"
#import "PPCheckSign.h"
#import "NetworkSingleton.h"
@implementation AppDelegate (AppLifeCircle)

- (void)updateAppData{
    
    [[FMDBManager shareManager] getUserModelData];
}

- (void)checkTimer{
//    [[UDDAllRequestSharedData sharedData]startRequstDifference];
}

- (void)getTrainData{
    
}

//更新个人信息和进入哪个
- (BOOL)isKeepAccount{
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [[NetworkSingleton sharedManager] getData:nil url:[NSString stringWithFormat:@"%@%@?version=%@",kNetBaseURL,KNetShowMarket,nowVer] successBlock:^(NSDictionary *responseObject, NSInteger statusCode) {
        NSDictionary *data = responseObject[@"data"];
        [PPUserModel sharedUser].showLoanSupermarket = [data[@"showLoanSupermarket"] intValue];
        [[NSUserDefaults standardUserDefaults] setValue:data[@"showLoanSupermarket"] forKey:@"showLoanSupermarket"];
        [[PPTabBarController shareInstance] setMoneyRootViewControlle];
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        
    }];
    
    if ([PPUserModel sharedUser].userId.integerValue <= 0) {return true;}
    NSDictionary *param = [PPSign getRequestParam:@{@"userId":[PPUserModel sharedUser].userId,@"version":nowVer,@"client":@"ios"}];
    NSString * encodingString = [param[@"param"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?&param=%@",kNetBaseURL,KNetQueryUserDetails,encodingString];
    NSString * postUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
    
    // 2.封装请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.f]; // post
    [request setHTTPMethod:@"POST"];
    
    static BOOL isAccount = true;
    
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
                model.userAuthentication = [dictionary[@"userAuthentication"] integerValue];
                if ([dict[@"status"] intValue] == 2) {
                    isAccount = false;
                }else{
                    isAccount = true;
                }
                
            }else{
                isAccount = true;
            }

        }else{
            isAccount = true;
        }
        dispatch_semaphore_signal(semaphore);//不管请求状态是什么，都得发送信号，否则会一直卡着进程
    }];
    [task resume];
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    return isAccount;
}

-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues

{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:keyedValues];
    NSArray *valueArray= [dic allKeys];
    for (NSString *key in valueArray) {
        if ([[dic objectForKey:key]isEqual:[NSNull null]]) {
            [dic setObject:@"" forKey:key];
        }
    }
    [super setValuesForKeysWithDictionary:dic];
}

@end

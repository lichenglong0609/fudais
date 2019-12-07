//
//  CYNetwork.m
//  PostProduct
//
//  Created by Risk on 2018/8/10.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "CYNetwork.h"
#import <AFNetworking.h>
#import "PPCheckSign.h"

@implementation CYNetwork

+ (void)postRequestUrlMethod:( NSString * _Nonnull )method paramters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:paramter];
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,method] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

+(void)getRequestUrl:( NSString * _Nonnull )url paramters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSString *urlStr = @"";
    NSArray *keys = [paramter allKeys];
    for (int i = 0;i<keys.count ; i++) {
        if (i == 0) {
            urlStr = [NSString stringWithFormat:@"%@%@?&%@=%@",kNetBaseURL,url,keys[i],paramter[keys[i]]];
        }else{
            urlStr = [urlStr stringByAppendingFormat:@"&%@=%@",keys[i],paramter[keys[i]]];
        }
    }
    NSString *method = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:method parameters:@{@"":@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        actionHandler(false,@"网络连接异常",@{});
    }];
}

+ (NSString *)encodeParameter:(NSString *)originalPara {
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}

+ (void)postRequest:( NSString * _Nonnull )method NotEncryptedParamters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,method] parameters:paramter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
@end

//
//  NetworkSingleton.h
//  meituan
//
//  Created by jinzelu on 15/6/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import <AFNetworking/AFHTTPSessionManager.h>
//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(NSDictionary *responseObject,NSInteger statusCode);
typedef void(^FailureBlock)(NSError *e,NSInteger statusCode,NSString *errorMsg);
typedef void(^SuccessDataBlock)(NSData *responseBody);

@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) AFHTTPSessionManager *baseHtppRequest;

-(NSDictionary *)setParamsToDic:(NSMutableDictionary *)myDic;
- (NSString *)handleUrlWithParamWithStr:(NSString *)str;
-(NSString*)DataTOjsonString:(id)object;
/**
 json转array
 
 @param str JSON字符串
 @return f
 */
-(NSArray *)parseJSONStringToArray:(NSString *)str;
#pragma mark - 获取网络信息

/**
 get请求

 @param userInfo 上传数据
 @param url URL链接
 @param successBlock 访问成功返回值
 @param failureBlock 访问失败返回值
 */
-(void)getData:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 Post请求

 @param userInfo 上传数据
 @param url URL链接
 @param successBlock 访问成功返回值
 @param failureBlock 访问失败返回值
 */
-(void)getDataPost:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 application/Json格式 post访问

 @param userInfo 参数
 @param url 访问地址
 @param successBlock 成功
 @param failureBlock 失败
 */
-(void)applicationJsonPost:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  上传图片
 *
 *  @param url           接口地址
 *  @param params        参数
 *  @param fileDatas     文件
 *  @param timeOut       访问时间
 *  @param successBlock  成功
 *  @param failureBlock  失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas timeOut:(int)timeOut successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image timeOut:(int)timeOut successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)getDataPostUTf8:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
@end

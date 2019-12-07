//
//  UDDSign.h
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

/*
 *  APP请求数据的加密和请求类AFHTTPSessionManager的设置
 *  时间搓+加密字符串+时间戳
 */
#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface PPSign : NSObject

/*!
 *  @brief 设置请求类的请求头
 *
 *  @param manager 请求的管理单利
 */
+ (void)setRequestHeaderObject:(AFHTTPSessionManager *)manager;

/**
 *  请求参数的加密方式
 *
 *  1)包含时间校对
 *  2)模块私钥+json数据+时间+模块公钥 变成一个字符串后进行MD5加密 作为签名
 *
 *  @param param 请求的参数
 *
 *  @return 加密后的参数
 */
+ (NSDictionary *)getRequestParam:(NSDictionary *)param;

/*!
 *  @brief 设置请求头
 *
 *  @param manager  请求的管理单利
 *  @param token    token值
 */
+ (void)setRequestHotelHeaderObject:(AFHTTPSessionManager *)manager withToken:(NSString *)token;

/*!
 *  @brief MD5加密
 *
 *  @param input 要加密的参数
 *
 *  @return MD5加密后的数据
 */
+ (NSString *)md5HexDigest:(NSString *)input;
@end

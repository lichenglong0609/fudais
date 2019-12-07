//
//  CYNetwork.h
//  PostProduct
//
//  Created by Risk on 2018/8/10.
//  Copyright © 2018年 cython. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYNetwork : NSObject

+ (void)postRequestUrlMethod:(NSString *)method paramters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
+(void)getRequestUrl:( NSString * _Nonnull )url paramters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**
不加密 post请求
 */
+ (void)postRequest:( NSString * _Nonnull )method NotEncryptedParamters:(NSDictionary *)paramter callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
@end

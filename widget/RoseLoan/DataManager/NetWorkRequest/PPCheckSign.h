//
//  UDDCheckSign.h
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCheckSign : NSObject

/**
 *  校验网络请求返回的数据，返回的code=1 为正常
 *
 */
+ (BOOL)checkSignData:(NSDictionary *)dictionary;

@end

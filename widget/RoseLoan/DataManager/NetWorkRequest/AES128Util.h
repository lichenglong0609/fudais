//
//  AES128Util.h
//  YLStreet
//
//  Created by cython on 2018/5/21.
//  Copyright © 2018年 cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128Util : NSObject

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;


@end

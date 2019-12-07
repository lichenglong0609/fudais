//
//  PPTool.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTool : NSObject
+ (NSString *)getBaseURL;
/** 去除url里面中文编码*/
+ (NSString *)UTF8StringEncoding:(NSString *)urlString;
/** 当前界面上的vc*/
+ (UIViewController *)currentViewController;
/** image的url*/
+(NSString *)getURLImageWithBase:(NSString *)base andPath:(NSString *)path;
+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
@end

NS_ASSUME_NONNULL_END

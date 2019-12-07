//
//  PPDeviceInformation.h
//  PostProduct
//
//  Created by V 凉夏季 on 2019/3/13.
//  Copyright © 2019 cython. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPDeviceInformation : NSObject
/**
 设备ID
 */
+(NSString *)getUUIDString;
@end

NS_ASSUME_NONNULL_END

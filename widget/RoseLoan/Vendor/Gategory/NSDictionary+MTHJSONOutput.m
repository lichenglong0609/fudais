//
//  NSDictionary+MTHJSONOutput.m
//  PostProduct
//
//  Created by 尚宇 on 2018/7/24.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "NSDictionary+MTHJSONOutput.h"

@implementation NSDictionary (MTHJSONOutput)

- (NSString *)descriptionWithLocale:(id)locale {
    NSString *output;
    @try {
        output = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        output = [output stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 处理\/转义字符
    } @catch (NSException *exception) {
        output = self.description;
    } @finally {
        
    }
    return  output;
}


@end

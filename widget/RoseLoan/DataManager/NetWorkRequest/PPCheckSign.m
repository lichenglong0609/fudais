//
//  UDDCheckSign.m
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "PPCheckSign.h"

@implementation PPCheckSign



+ (BOOL)checkSignData:(NSDictionary *)dictionary{

    
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    if ([[dictionary objectForKey:@"code"] integerValue] == 1 ) {
        return  YES;
    }else{
    
        return NO;
    }
    
}

@end

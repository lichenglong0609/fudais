//
//  NSDictionary+PPDeleteNull.m
//  PostProduct
//
//  Created by Risk on 2018/8/21.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "NSDictionary+PPDeleteNull.h"

@implementation NSDictionary (PPDeleteNull)

- (NSDictionary *)deleteNull{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}



@end

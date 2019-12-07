//
//  UDDAddressBookData.m
//  UddTrip
//
//  Created by Chuan Liu on 16/9/3.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "UDDAddressBookData.h"

@implementation UDDAddressBookData


- (NSString *)getFirstLetter{

    NSString *ret = @"";
    if (![_userName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果不是英语
        if ([[self letters] length]>2) {
            ret = [[self letters] substringToIndex:1];
        }
    }
    else {
        ret = [NSString stringWithFormat:@"%c",[_userName characterAtIndex:0]];
    }
    return ret;
}


- (NSString *)letters{
    NSMutableString
    *mutableString
    =
    [NSMutableString
     stringWithString:_userName];
    
    CFStringTransform((CFMutableStringRef)mutableString,
                      NULL,
                      kCFStringTransformToLatin,
                      false);
    
    mutableString =(NSMutableString *)[mutableString
        stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
        locale:[NSLocale currentLocale]];
    
    
    return mutableString;
}

@end

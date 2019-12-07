//
//  PasswordRelated.m
//  51Investment
//
//  Created by V 凉夏季 on 2019/2/21.
//  Copyright © 2019 V 凉夏季. All rights reserved.
//

#import "PasswordRelated.h"
@implementation PasswordRelated
+(BOOL)restrictedInput:(NSString *)oldStr inputString:(NSString *)inputStr minimumCharacterLength:(int)miniCount maximumCharacterLength:(int)maxCount range:(NSRange)range completionHandler:(void(^)(BOOL isCorrectLength,NSString *resultStr))handler{
    int currentStrLength = (int)oldStr.length;
    int inputStrLength = (int)inputStr.length;
    int compStrLength = currentStrLength + inputStrLength;
    NSString *complereStr = [NSString stringWithFormat:@"%@%@",oldStr,inputStr];
    if (compStrLength >= maxCount && inputStrLength != 0) {
        NSString *res = [complereStr substringToIndex:maxCount];
        handler(YES,res);
    }else{
        if ([inputStr isEqualToString:@""] && range.length == 1) {
            NSString *res = [complereStr substringToIndex:(compStrLength - 1)];
            if (miniCount != 0) {
                if (res.length < miniCount) {
                    handler(NO,res);
                }else{
                    handler(YES,res);
                }
            }else{
                handler(NO,res);
            }
            return NO;
        }else{
            if (miniCount != 0) {
                if (complereStr.length < miniCount) {
                    handler(NO,complereStr);
                }else{
                    handler(YES,complereStr);
                }
            }else{
                handler(NO,complereStr);
            }
            return NO;
        }
    }
    return NO;
}
@end

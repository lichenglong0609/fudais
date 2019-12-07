//
//  PasswordRelated.h
//  51Investment
//
//  Created by V 凉夏季 on 2019/2/21.
//  Copyright © 2019 V 凉夏季. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordRelated : NSObject
/**
 限制文本输入长度

 @param oldStr 已存在文字
 @param inputStr 新输入文字
 @param miniCount 最小文字长度，如果为0长度固定为maxCount长度
 @param maxCount 最大文字长度
 @param range 文字位置
 @param handler 结果
 @return NO
 */
+(BOOL)restrictedInput:(NSString *)oldStr inputString:(NSString *)inputStr minimumCharacterLength:(int)miniCount maximumCharacterLength:(int)maxCount range:(NSRange)range completionHandler:(void(^)(BOOL isCorrectLength,NSString *resultStr))handler;
@end

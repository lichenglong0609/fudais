//
//  NSString+InputCheck.h
//  NativeJialebao
//
//  Created by 0X10 on 16/5/4.
//  Copyright © 2016年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (InputCheck)

/**
 *   判断是否是邮箱
 *
 *  @return isEmail
 */

- (BOOL) validateEmail;

/**
 *   判断是否是手机号
 *
 *  @return isPhone
 */
- (BOOL) validateMobile;

/**
 *  判断是否是QQ
 *
 *  @return isQQ
 */
- (BOOL) validateqq;


/**
 *  判断是否是名字
 *
 *  @return isName
 */
- (BOOL) validateRealName;


/**
 *  判断是否是昵称
 *
 *  @return isNickName
 */
- (BOOL) validateNickName;


/**
 *  判断是否是UserId
 *
 *  @return isUserId
 */
- (BOOL) validateUserId;

/**
 *  判断是否是身份证
 *
 *  @return isIdCard
 */
- (BOOL) validateIdCard;


/**
 *  判断密码修改时是否至少两种组合
 *
 *  @return isTwoCombination
 */
- (BOOL) validateCombination;

/**
 *  判断字符串中是否存在特殊字符
 *
 *  @return ishaveSpecialChar
 */
- (BOOL) haveSpecialChar;

/**
 *  判断字符串中是否是可用的信用卡
 *
 *  @return isValiteCreditCard
 */
- (BOOL)valiteCreditCard;

/**
 *  信用卡信用卡有效期
 *
 *  @return isValiteCreditCard
 */
- (BOOL)valiteLimitedDate;

- (BOOL)stringIsHaveString:(NSString *)aString;

/**
 *  银行卡号对应的银行卡
 *
 *  @return isValiteCreditCard
 */
+ (NSString *)getBankName:(NSString*) cardId;

/**
 *  10进制转成二进制字符串
 */
- (NSString *)intToBinary:(int)intValue;

- (NSString *)returnCityId:(id)cityId;
@end

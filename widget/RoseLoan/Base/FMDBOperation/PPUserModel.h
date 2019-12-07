//
//  PPUserModel.h
//  UIViewTest
//
//  Created by cy on 16/9/23.
//  Copyright © 2016年 Cy. All rights reserved.
//

/**
 *  用户信息的model，单利类。
 */
#import <Foundation/Foundation.h>
#import <BGFMDB.h>

@interface PPUserModel : NSObject


/** 姓名 */
@property (nonatomic,strong) NSString *name;

/** 年龄 */
@property (nonatomic,assign) int age;

/** 性别 */
@property (nonatomic,strong) NSString *userSex;

/** 亲属姓名 */
@property (nonatomic,strong) NSString *userRelationshipname;

/** 用户头像 */
@property (nonatomic,strong) NSString *userPic;

/** 亲属关系 */
@property (nonatomic) NSInteger userRelationship;

@property (nonatomic) NSInteger recommendationCode;
@property (nonatomic) NSInteger registerSource;
/** 省份 */
@property (nonatomic,strong) NSString *agency;
/** 有效期 */
@property (nonatomic,strong) NSString *validdateEnd;
@property (nonatomic) NSInteger recommendationCount;

@property (nonatomic,strong) NSString *zhengAddress;
/** 亲属电话 */
@property (nonatomic,strong) NSString *userRelationshipphone;

/** 用户地址 */
@property (nonatomic,strong) NSString *userAddress;
/** 用户自我介绍 */
@property (nonatomic,strong) NSString *userIntroduction;

/** 亲属名 */
@property (nonatomic,strong) NSString *userRealname;
/** 95=审核通过 --->贷款灰色
 96=审核不通过 --->贷款灰色
 101=放款失败 --->贷款灰色
 100=放款成功 --->贷款灰色
 155=逾期 --->贷款灰色
 200=贷款结清 --->贷款放开
 */

@property (nonatomic) NSInteger userOrderstatus;
@property (nonatomic) NSInteger recommendationRate;
@property (nonatomic) NSInteger userAuthentication;
@property (nonatomic) NSInteger userRegion;

@property (nonatomic,strong) NSString *userSesamecredit;
@property (nonatomic,strong) NSString *facedetectimageList;
@property (nonatomic,strong) NSString *userPassword;
@property (nonatomic,strong) NSString *userOrderno;
@property (nonatomic,strong) NSString *userOrderstatusmessage;
@property (nonatomic,strong) NSString *userBankno;
@property (nonatomic,strong) NSString *userCardholder;
@property (nonatomic,strong) NSString *userCard;

/** loanCount>3天的 才可以还款 */
@property (nonatomic) NSInteger loanCount;

@property (nonatomic) NSInteger userStatus;

/** status 1= 记账 2=贷款 */
@property (nonatomic) NSInteger status;

/**
 1：不显示贷款超市
 2：显示贷款超市
 */
@property (nonatomic) NSInteger showLoanSupermarket;

@property (nonatomic,strong) NSString *agentCode;
@property (nonatomic,strong) NSString *userCardFanpic;
@property (nonatomic,strong) NSString *userCardPic;
@property (nonatomic,strong) NSString *userBank;

@property (nonatomic,strong) NSString *nation;
@property (nonatomic,strong) NSString *facedetectScore;
@property (nonatomic,strong) NSString *userLogin;
@property (nonatomic,strong) NSString *userDate;
@property (nonatomic,strong) NSString *userNickname;

/** 用户认证步骤 1=身份证 2=基本资料 4=人脸识别 5=准入成功 6=银行卡  */
@property (nonatomic) NSInteger userStep;
@property (nonatomic) NSInteger userType;
/**
 是否认证
 0=未认证
 1=已认证
 */
@property (nonatomic) NSInteger isCertification;

/** 用户Id */
@property (nonatomic,strong) NSString *userId;

/** 账本Id */
@property (nonatomic,strong) NSString *stypeId;

@property (nonatomic,strong) NSString *tokenId;

@property (nonatomic,strong) NSString *relationshipname;

/**
 *  用户信息的单利
 *
 *  @return 单利的对象
 */
+(instancetype)sharedUser;

/**
 *  退出登录
 */
- (void)checkOutLogin;

/**
 *  判断用户是否登录
 */
- (BOOL)checkIsLogin;


- (void)saveUserData;

@end

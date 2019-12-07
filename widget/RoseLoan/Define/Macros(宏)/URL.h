//
//  URL.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/14.
//  Copyright © 2019 cython. All rights reserved.
//

#ifndef URL_h
#define URL_h
/// API地址
#define kNetBaseURL                 [NSString stringWithFormat:@"%@",[PPTool getBaseURL]]
///图片地址
#define KNetPicURL                  [NSString stringWithFormat:@"%@%@",[PPTool getBaseURL],@"picupload/user/"]
///拼接图片URL
#define URLImage(path)              [PPTool getURLImageWithBase:KNetPicURL andPath:path]
///拼接URL
#define URLString(path)             [NSString stringWithFormat:@"%@?%@",kNetBaseURL,[PPTool UTF8StringEncoding:path]]

#pragma mark - 首页
///显示贷款超市
#define KNetShowMarket              @"mobile/market-show"
///首页
#define KNetIndex                   @"mobile/index"
///授信申请结果
#define KNetCreditResult            @"user/queryorderresult"
///统计PV/UV
#define KNETstatisticPvUv           @"statistic/statistics"
#define KNetChannel                 @"/mobile/channel"

#pragma mark - 登录
///短信验证码
#define KNetSMSVerifiCode           @"user/sencodes"
///登录/注册
#define KNetRegisterLogIn           @"user/register"

#pragma mark - 借款
///借款
#define KNetLoan                    @"user/sendloanotp"
///借款验证码
#define KNetBorrowingVerifiCode     @"user/sendloanotploan"
///订单试算
#define KNetOrdertrial              @"user/ordertrial"
///合同查询
#define KNetQueryContract           @"diandian/querycontractinfo"
#pragma mark - 还款
///还款
#define KNetRepayment               @"user/sendrepayotp"
///还款计划
#define KNetRepaymentPlan           @"user/queryrepayplan"
///还款验证码
#define KNetRepaymentVerifiCode     @"user/sendrepayotprepay"

#pragma mark - 贷款超市
///贷款超市列表
#define KNETsupermarkerList         @"advertisement/list"
///获取banner
#define KNETgetBanner               @"advertisement/getBannerImage"
///贷款超市首页
#define KNetProductList             @"product/list"

#pragma mark - 个人中心
#define KNetVerified                @"certify/real-name"
#define KNetSaveInfo                @"certify/save-info"
///修改身份证和真实姓名
#define KNetUpdateCard              @"user/updatecard"
///添加基本资料
#define KNetUpdateUser              @"user/updateuser"
///根据id查询用户详情
#define KNetQueryUserDetails        @"user/getuserbyuserid"
///准入数据检测
#define KNetAdmittancecheck         @"user/admittancecheck"
///身份证信息添加
#define KNetUserCard                @"user/usercard"
///修改昵称
#define KNetUpdateNikeName          @"user/updateusernickname"
///上传头像
#define KNetUploadAvatar            @"user/updateuserpic"
///删除银行卡
#define KNetDeleteBankCard          @"bankcard/deletebankcard"
///添加银行卡
#define KNetSaveBankCard            @"bankcard/savebankcard"
///银行卡列表
#define KNetBankCardList            @"bankcard/getbankcardlist"
///银行列表
#define KNetBankList                @"bankcard/getbanklist"
#define KNetCardList                @"bankcard/card-list"

#pragma mark - HTML地址
///隐私协议
#define KHTMLPrivacyAgreement       @"m/YinSiAgreement_Apply.html"
///注册协议
#define KHTMLRegisteredAgreement    @"m/ZhuCeAgreement.html"
#endif /* URL_h */

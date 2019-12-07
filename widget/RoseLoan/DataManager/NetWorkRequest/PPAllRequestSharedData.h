//
//  YLAllRequestSharedData.h
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PPAllRequestSharedData : NSObject



+ (PPAllRequestSharedData*)sharedData;

/**获取验证码*/
- (void)requestMsgWithPhoneData:(NSDictionary *)userData callBack:(void(^)(BOOL success ,NSString *msg))actionHandler;

/**登录*/
- (void)requestLoginWithUserData:(NSDictionary *)userData callBack:(void(^)(BOOL success ,NSString *msg))actionHandler;

/**根据用户Id查详情*/
- (void)requestUserDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**用户头像上传*/
- (void)requestUploadHeaderImageData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**首页账单列表*/
- (void)requestHomeDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**账单列表*/
- (void)requestBillDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**账单详情*/
- (void)requestBillDetailWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**搜索账本*/
- (void)requestSearchBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**删除账单*/
- (void)requestDeleteBillWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**账本列表*/
- (void)requestGetBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**添加账本*/
- (void)requestInsertBookData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**编辑账本*/
- (void)requestEditBookData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**删除账本*/
- (void)requestDeleteAccountBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**账本类别*/
- (void)requestAccountBookTypeData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**添加账单*/
- (void)requestInsertBillData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**编辑账单*/
- (void)requestEditBillData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**银行列表*/
- (void)requestBankDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**删除银行卡*/
- (void)requestDeleteBankCardBankData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**添加银行卡*/
- (void)requestInsertBankCardBankData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**用户银行卡列表*/
- (void)requestBankCardListWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**更新用户头像*/
- (void)requestUpdateHeaderImageData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**更新用户昵称*/
- (void)requestUpdateUserNameData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**身份证上传*/
- (void)requestUpdateUserIdCardData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**准入数据检测*/
- (void)requestTestData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

/**基本资料填写*/
- (void)requestUpdateUserData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
/**亲属关系列表*/
- (void)requestRelationDataCallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

- (void)requestCityParam:(NSDictionary *)pram CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

- (void)requestValidateFaceIdData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

- (void)requestSaveBankCardData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

- (void)requestOrderTrialData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

- (void)requestQueryOrderResultData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
- (void)requestQueryContractInfoData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
- (void)requestQueryrepayPlanData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
- (void)requestSendrePayotpData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;
- (void)requestLoanMoneyData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler;

@end

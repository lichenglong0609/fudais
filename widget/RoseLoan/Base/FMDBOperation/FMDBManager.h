//
//  FMDBManager.h
//  UIViewTest
//
//  Created by cy on 16/9/23.
//  Copyright © 2016年 Cy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@class PPUserModel;
@class UDDUserBrowseHistoryModel;

@class UDDContactsUserData;

@interface FMDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@property (nonatomic) BOOL isQueue;

/**
 *  数据库操作的单利
 */
+ (instancetype)shareManager;



/**
 *  更新个人信息到model
 */
- (void)checkUpdateApp;

/**
 *  同步用户信息user到数据库中
 */
- (void)saveUserDataToDataBase:(PPUserModel *)user;

/**
 *  获取用户信息
 */
- (void)getUserModelData;


/**
 *  获得数据库的名称
 *
 *  @return 数据库的名称
 */
- (NSString *)databasePath;


/**
 *  清除当地玩乐搜索历史
 */
- (void)clearLocalPlayHistory;

/**
 *  添加当地玩乐搜索字段到数据
 *
 *  @param histroyRecord 当地玩乐的搜索历史
 */
- (void)addLocalPlayHistory:(NSString *)histroyRecord;

/**
 *  获得数据库中的浏览历史
 *
 *  @param callBack 当地玩乐搜索历史
 */
- (void)getLocalPlayHistory:(void(^)(NSArray *data))callBack;

/**
 *   服务器和手机本地时间差 校对
 */
- (void)updataTimeDifference:(int)differenceTime;

/**
 *  获得服务器和手机的时间差
 */
- (NSInteger)getTimeDifference;

/**
 *   插入浏览历史到数据库中
 */
- (void)insertBrowsHistory:(UDDUserBrowseHistoryModel *)model;


/**
 *  清除历史浏览记录
 */
- (void)clearHistoryRecord;


/**
 *  获得所有浏览记录
 */
- (void)getAllHistoryData:(void(^)(NSArray *data))callBack;

/**
 *  线程安全的队列 在数据库操作过程中 先开启后关闭
 */
- (void) doExecute:(NSString *)sql;

- (void) doUpdate:(NSString *)sql;

- (void) doUpate:(NSString *)sql withArgs:(NSArray*)args;



/**
 *  更新火车票城市列表
 */
- (void)updateLocation:(NSArray *)array;


/**
 *  获得所有城市列表
 */
- (void)getAllCityModelData:(void(^)(NSArray *data))callBack;

/**
 *  根据关键字在数据库中模糊查询城市列表
 *
 *  @param keyword  搜索的关键字
 *  @param callBack 回调的城市列表
 */
- (void)formKeyWord:(NSString *)keyword getTrainCityData:(void(^)(NSArray *data))callBack;

/**
 *   保存常用联系人
 *
 */
- (void)saveAlwaysContactPeoPleDataToDataBaseWithDict:(NSDictionary *)dict
                                           isNewBuild:(BOOL)isNewBuild
                                             CallBack:(void(^)(BOOL isSave, UDDContactsUserData *model, NSString *msg))callBack;

/**
 *   获取常用联系人
 *
 */
- (void)getAlwaysContactPeoPleDataToDataBase:(NSDictionary *)dict :(void(^)(NSArray *data))callBack;

/**
 *   删除常用联系人
 *
 */
- (void)deleteAlwaysContactPeoPleDataToDataBase:(NSDictionary *)dict :(void(^)(BOOL isDelete))callBack;


/** 火车票本地存储相关  目前不用
 //将火车票数据数组存到数据库
 - (void)saveTrainListDataToDataBase:(NSArray *)trainListData;
 
 - (NSArray *)getTrainListDataFormsSift:(NSArray *)trainListData;
 */
@end

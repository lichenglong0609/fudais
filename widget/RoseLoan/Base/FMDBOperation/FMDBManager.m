//
//  FMDBManager.m
//  UIViewTest
//
//  Created by cy on 16/9/23.
//  Copyright © 2016年 Cy. All rights reserved.


//开启事务对未开启线程有影响//
#define kGlobalDataBaseName @"safy100.sqlite"

#import "FMDBManager.h"
#import "PPUserModel.h"
#import <FMDB.h>

static FMDBManager *manager;

@implementation FMDBManager

+ (instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[FMDBManager alloc]init];
    });
    
    return manager;
}

- (id)init
{
    if ((self = [super init])) {
        
        //检查是否创建数据库 没有创建就创建
        [self checkAndCreateDatabase];
        
        NSString *path = [self databasePath];
        
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        //已经创建的更新数据
        [self checkUpdateApp];
    }
    
    return self;
}

- (void)deleteDataBaseWithName:(NSString*)dbName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    
    NSString *orgDbPath = [documentsDir stringByAppendingPathComponent:dbName];
    
    
    
    BOOL flag = NO;
    
    if (YES == [fileManager fileExistsAtPath:orgDbPath isDirectory:&flag]) {
        
        [fileManager removeItemAtPath:orgDbPath error:nil];
    }
}





//获取所有的文件路径

- (NSArray*)getAllFilesAtPath:(NSString*)dirString {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                [array addObject:fileName];
            }
            
        }
        
    }
    
    return array;
}

- (void)setDbQueue:(FMDatabaseQueue *)dbQueue{
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.databasePath];
}





- (NSString *)databaseName
{
    return kGlobalDataBaseName;
}


- (NSString *)databasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES);
    NSString *documentsDir = [documentPaths firstObject];
    
    
    return [documentsDir stringByAppendingPathComponent:self.databaseName];
    
    
}


- (void)checkAndCreateDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (NO == [fileManager fileExistsAtPath:self.databasePath]) {
        
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:self.databaseName];
        
        NSError *error;
        
        [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:&error];
        
        
    }
    
    
}



//第一次不修改内容
//- (void)checkUpdateApp {

    //    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    //
    //    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                                 NSUserDomainMask,
    //                                                                 YES);
    //    NSString *documentsDir = [documentPaths firstObject];
    //
    //    [muArray  addObjectsFromArray:[self getAllFilesAtPath:documentsDir]];
    //
    //    PPUserModel *userModel = [[PPUserModel alloc]init];
    //
    //
    //    for ( NSString *dbName in muArray ) {
    //
    //        NSLog(@"111%@1111",dbName);
    //
    //        if ( ![dbName isEqualToString:kGlobalDataBaseName]) {
    //
    //            //保证一有数据，用户信息就不再更新
    //            if ( [[userModel userId]integerValue] <= 0 ) {
    //
    //                NSString *orgDbPath = [documentsDir stringByAppendingPathComponent:dbName];
    //
    //                [[FMDatabaseQueue databaseQueueWithPath:orgDbPath] inDatabase:^(FMDatabase *db) {
    //
    //                    [db open];
    //
    //                    FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM tb_user_info;"];
    //
    //                    //读取数据
    //                    while ( [resultSet next] ) {
    //
    //                        userModel.name = [resultSet stringForColumn:@"name"];
    //                        userModel.age = [resultSet intForColumn:@"age"];
    //                        userModel.address = [resultSet stringForColumn:@"address"];
    //                        userModel.sex = [resultSet stringForColumn:@"sex"];
    //                        userModel.userId = [resultSet stringForColumn:@"user_id"];
    //                        userModel.email = [resultSet stringForColumn:@"email"];
    //                        userModel.mobile = [resultSet stringForColumn:@"mobile"];
    //                        userModel.nikeName = [resultSet stringForColumn:@"nike_name"];
    //                        userModel.headImgUrl = [resultSet stringForColumn:@"head_img_url"];
    //
    //                        userModel.shareUrl = [resultSet stringForColumn:@"share_url"];
    //                        userModel.cityCode = [resultSet stringForColumn:@"city_code"];
    //                        userModel.cityName = [resultSet stringForColumn:@"city_name"];
    //
    //                        userModel.qqAccessToken = [resultSet stringForColumn:@"qq_access_token"];
    //                        userModel.wechatAccessToken = [resultSet stringForColumn:@"wechat_access_token"];
    //                        userModel.weiboAccessToken  =[resultSet stringForColumn:@"weibo_access_token"];
    //
    //                        userModel.userDescription = [resultSet stringForColumn:@"user_description"];
    //                        userModel.shareUrl = [resultSet stringForColumn:@"share_url"];
    //                        userModel.tokenId = [resultSet stringForColumn:@"token_id"];
    //
    //                        NSLog(@"***%@,%d*****",userModel.sex,userModel.age);
    //
    //                        break;
    //                    }
    //
    //                    [db close];
    //
    //                }];
    //
    //            }
    //
    //            //只要是不等于当前版本的数据库，全部都要删除
    //            //            [self deleteDataBaseWithName:dbName];
    //
    //        }else{
    //            if ([[dbName stringByReplacingOccurrencesOfString:@"safy" withString:@""] integerValue] < 100) {
    //                [self deleteDataBaseWithName:dbName];
    //            }else{
    //                NSLog( @"保留 %@ 数据库", dbName );
    //            }
    //
    //        }
    //    }
    //
    //
    //    //取到数据将数据库替换掉
    //
    //    if ( [[userModel userId]integerValue] != 0  ) {
    //        [[FMDBManager shareManager] saveUserDataToDataBase:userModel];
    //    }
    
//}



- (void)getUserModelData{
    
    PPUserModel *userModel = [PPUserModel sharedUser];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM tb_user_info;"];
        
        //读取数据
        while ( [resultSet next] ) {
            
            userModel.name = [resultSet stringForColumn:@"name"];
            userModel.age = [resultSet intForColumn:@"age"];

            
            break;
        }
        
        [db close];
    }];
}



- (void)saveUserDataToDataBase:(PPUserModel *)user{
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
//        [db executeUpdate:[NSString stringWithFormat:@"UPDATE 'tb_user_info' SET 'user_id' = '%@', 'name' = '%@', 'age' = '%d', 'address' = '%@', 'sex' = '%@', 'email' = '%@', 'weibo_access_token' = '%@', 'wechat_access_token' = '%@', 'qq_access_token' = '%@', 'mobile' = '%@', 'nike_name' = '%@', 'city_code' = '%@', 'share_url' = '%@', 'city_name' = '%@', 'token_id' = '%@' ,'birth_date' = '%@','train_usr' = '%@','train_pwd' = '%@','head_img_url' = '%@';",user.userId,user.name,user.age,user.address,user.sex,user.email,user.weiboAccessToken,user.wechatAccessToken,user.qqAccessToken,user.mobile,user.nikeName,user.cityCode,user.shareUrl,user.cityName,user.tokenId,user.birthDate,user.trainUserName,user.trainPassword,user.headImgUrl]];
        
//        NSLog(@"----%@---%@---%@--",user.tokenId,user.mobile,user.userId);
        [db close];
        
    }];
}


- (void)deleteUserInfo{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"DELETE FORM tb_user_info;"];
        [db close];
    }];
}









- (void)updataTimeDifference:(int)differenceTime{
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE tb_global_config SET time_difference = %d;", differenceTime]];
        [db close];
        
    }];
}



- (NSInteger)getTimeDifference{
    
    __block NSInteger time;
    
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM tb_global_config;"];
        
        while ([resultSet next]) {
            time = [resultSet intForColumn:@"time_difference"];
        }
        [db close];
    }];
    
    return time;
}


//- (void)insertBrowsHistory:(UDDUserBrowseHistoryModel *)model{
//
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        BOOL  isSuccess;
//
//        NSString *sql = @"select product_id from tb_brows_history where  product_id = ?";
//
//        FMResultSet *set = [db executeQuery:sql,model.productId];
//
//        if ([set next]) {
//
//            isSuccess = [db executeUpdate:[NSString stringWithFormat:@"UPDATE 'tb_brows_history' SET 'title' = '%@' , 'current_data' = '%@' ,'img_url' = '%@' ,'price' = '%@' WHERE 'product_id' = '%@' ,'type_id' = '%@' ;", model.title,model.currentData,model.imgUrl,model.price,model.productId,model.typeId]];
//
//        }else{
//            NSString *insetSql = @"INSERT INTO 'tb_brows_history' (title,current_data,img_url,price,product_id,type_id) values (?,?,?,?,?,?)";
//            isSuccess = [db executeUpdate:insetSql withArgumentsInArray:@[model.title,model.currentData,model.imgUrl,model.price,model.productId,model.typeId]];
//
//        }
//
//        NSLog(@"插入成功!");
//        [db close];
//
//    }];
//
//
//}
//
//- (void)getAllHistoryData:(void(^)(NSArray *data))callBack{
//
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM tb_brows_history;"];
//
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//
//        while ([resultSet next]) {
//
//            UDDUserBrowseHistoryModel *model = [[UDDUserBrowseHistoryModel alloc]init];
//
//            model.title         = [resultSet stringForColumn:@"title"];
//            model.currentData   = [resultSet stringForColumn:@"current_data"];
//            model.imgUrl        = [resultSet stringForColumn:@"img_url"];
//            model.price         = [resultSet stringForColumn:@"price"];
//            model.productId     = [resultSet stringForColumn:@"product_id"];
//            model.typeId        = [resultSet stringForColumn:@"type_id"];
//
//            [array addObject:model];
//        }
//
//
//        if (array.count>0) {
//            callBack(array);
//        }else{
//            callBack(@[]);
//        }
//        [db close];
//    }];
//
//}
//
//
//
//- (void)clearHistoryRecord{
//
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        [db executeUpdate:@"DELETE FROM tb_brows_history;"];
//        [db close];
//    }];
//}
//
//
//- (BOOL)isExistsDataWithModel:(UDDUserBrowseHistoryModel *)model{
//
//    NSString *sql = @"select _id from tb_brows_history where product_id = ?";
//    FMResultSet *set = [[FMDatabase databaseWithPath:self.databasePath] executeQuery:sql,model.productId];
//
//    return [set next];
//}
//
//- (void)getLocalPlayHistory:(void(^)(NSArray *data))callBack{
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        FMResultSet* resultSet = [db executeQuery:@"SELECT * FROM tb_local_play_history;"];
//
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//
//        while ([resultSet next]) {
//            NSString *histroyString = [resultSet stringForColumn:@"search_history"];
//            [array addObject:histroyString];
//        }
//        [db close];
//
//        if (array.count>0) {
//            callBack(array);
//        }else{
//            callBack(@[]);
//        }
//
//
//    }];
//}
//
//- (void)addLocalPlayHistory:(NSString *)histroyRecord{
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        BOOL  isSuccess;
//
//        NSString *sql = @"select search_history from tb_local_play_history where  search_history = ?";
//
//        FMResultSet *set = [db executeQuery:sql,histroyRecord];
//
//        if (![set next]) {
//            NSString *insetSql = @"INSERT INTO 'tb_local_play_history' (search_history) values (?)";
//            isSuccess = [db executeUpdate:insetSql withArgumentsInArray:@[histroyRecord]];
//        }
//
//        [db close];
//
//    }];
//
//}
//
//- (void)clearLocalPlayHistory{
//
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        [db executeUpdate:@"DELETE FROM tb_local_play_history;"];
//        [db close];
//    }];
//}
//
//- (void) doUpdate:(NSString *)sql
//{
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        [db executeUpdate:sql];
//
//        [db close];
//    }];
//}
//
//- (void) doUpate:(NSString *)sql withArgs:(NSArray*)args
//{
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        //执行插入
//        [db executeUpdate:sql withArgumentsInArray:args];
//        [db close];
//    }];
//}
//
//- (void)doExecute:(NSString *)sql{
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//
//        [db open];
//        [db executeUpdate:sql];
//        [db close];
//    }];
//}
//
//
//- (void)updateTaoBaoUserDataToDataBase:(NSString *)sql {
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        //modified by panbin
//        [db executeUpdate:sql];
//
//        [db close];
//
//    }];
//}
//
//- (void)updateLocation:(NSArray *)array{
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        NSString *sql = @"DELETE FROM tb_ticket_address;";
//        BOOL isSuccess = [db executeUpdate:sql];
//        [db close];
//        if (isSuccess) {
//            [db open];
//            NSString *insetSql = @"INSERT INTO 'tb_ticket_address' (short_name,china_name,long_name,number,key) values (?,?,?,?,?)";
//            //开启事务
//            [db beginTransaction];
//            for (UDDTrainStationModel *model in array) {
//                [db executeUpdate:insetSql withArgumentsInArray:@[model.shortName,model.nameHZ,model.longName,model.number,model.bigName]];
//            }
//            [db commit];
//            NSLog(@"插入成功!");
//            [db close];
//        }
//
//
//    }];
//
//}
//
//
//
//- (BOOL)isExistTicketModel:(UDDTrainStationModel *)model{
//
//    NSString *sql = @"select number from tb_ticket_address where key = ?";
//    FMResultSet *set = [[FMDatabase databaseWithPath:self.databasePath] executeQuery:sql,model.bigName];
//    return [set next];
//}
//
//- (void)formKeyWord:(NSString *)keyword getTrainCityData:(void(^)(NSArray *data))callBack{
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//
//        if ([db inTransaction]) {
//            [db closeOpenResultSets];
//        }
//
//        [db open];
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_ticket_address WHERE long_name like '%@%%' or china_name like '%@%%' or short_name like '%@%%' or key like '%@%%'",keyword,keyword,keyword,keyword];
//
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        FMResultSet *rs = [db executeQuery:sql];
//
//        while ([rs next]){
//
//            UDDTrainStationModel *model = [[UDDTrainStationModel alloc]init];
//
//            model.nameHZ = [rs stringForColumn:@"china_name"];
//            model.bigName = [rs stringForColumn:@"key"];
//            model.longName = [rs stringForColumn:@"long_name"];
//            model.shortName = [rs stringForColumn:@"short_name"];
//            model.number = [rs stringForColumn:@"number"];
//
//            [array addObject:model];
//        }
//
//        if (array.count>0) {
//            callBack(array);
//        }else{
//            callBack(@[]);
//        }
//        [db close];
//    }];
//}
//
//- (void)getAllCityModelData:(void(^)(NSArray *data))callBack{
//
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//
//        FMResultSet* rs = [db executeQuery:@"SELECT * FROM tb_ticket_address;"];
//
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//
//        while ([rs next]) {
//
//            UDDTrainStationModel *model = [[UDDTrainStationModel alloc]init];
//
//            model.nameHZ = [rs stringForColumn:@"china_name"];
//            model.bigName = [rs stringForColumn:@"key"];
//            model.longName = [rs stringForColumn:@"long_name"];
//            model.shortName = [rs stringForColumn:@"short_name"];
//            model.number = [rs stringForColumn:@"number"];
//
//            [array addObject:model];
//        }
//
//
//        if (array.count>0) {
//            callBack(array);
//        }else{
//            callBack(@[]);
//        }
//        [db close];
//    }];
//
//}
//
//- (void)getAlwaysContactPeoPleDataToDataBase:(NSDictionary *)dict :(void(^)(NSArray *data))callBack {
//
//    [_dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *type = strOrEmpty([dict objectForKey:@"certificatesType"]);
//
//        [db open];
//
//        FMResultSet* resultSet = [[FMResultSet alloc] init];
//        if ([type isEqualToString:@""]) {
//            resultSet = [db executeQuery:@"SELECT * FROM tb_person_always_used;"];
//        } else {
//            resultSet = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tb_person_always_used where certificates in (%@);",type]];
//        }
//
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        while ([resultSet next]) {
//            UDDContactsUserData *model = [[UDDContactsUserData alloc]init];
//            model.mobile = [resultSet stringForColumn:@"mobile"];
//            model.certificates = [[resultSet objectForColumnName:@"certificates"] integerValue];
//            model.chinaName = [resultSet stringForColumn:@"chinaName"];
//            model.certificatesNo = [resultSet stringForColumn:@"certificatesNo"];
//            model.birthDate = [resultSet stringForColumn:@"birthDate"];
//            model.englishName = [resultSet stringForColumn:@"englishName"];
//            if (model.certificates == 2) {
//                NSArray *array = [model.englishName componentsSeparatedByString:@"~~"];
//                if (array.count < 2) {
//                } else {
//                    model.englishLastName = array[1];
//                    model.englishFistName = array[0];
//                    model.englishName = [model.englishName stringByReplacingOccurrencesOfString:@"~~" withString:@" "];
//                }
//            }
//            [array addObject:model];
//        }
//        [db close];
//        if (array.count>0) {
//            callBack(array);
//        }else{
//            callBack(@[]);
//        }
//    }];
//}
//
//- (void)saveAlwaysContactPeoPleDataToDataBaseWithDict:(NSDictionary *)dict isNewBuild:(BOOL)isNewBuild CallBack:(void(^)(BOOL isSave, UDDContactsUserData *model, NSString *msg))callBack {
//
//    UDDContactsUserData *model = [[UDDContactsUserData alloc]init];
//    model.mobile = [dict objectForKey:@"mobile"];
//    model.certificates = [[dict objectForKey:@"certificates"] integerValue];
//    model.chinaName = [dict objectForKey:@"cName"];
//    model.certificatesNo = [dict objectForKey:@"certificatesNo"];
//    model.birthDate = [dict objectForKey:@"birthDate"];
//    model.englishName = [dict objectForKey:@"eName"];
//    if (model.certificates == 2) {
//        NSArray *array = [model.englishName componentsSeparatedByString:@"~~"];
//        if (array.count < 2) {
//        } else {
//            model.englishLastName = array[1];
//            model.englishFistName = array[0];
//            model.englishName = [model.englishName stringByReplacingOccurrencesOfString:@"~~" withString:@" "];
//        }
//    }
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db open];
//        BOOL isSave;
//        if (isNewBuild) {//如果新的,就插入
//            //判断是否已经存在
//            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tb_person_always_used;"]];
//            while ([rs next]) {
//                if ([[rs stringForColumn:@"certificatesNo"] isEqualToString:[dict objectForKey:@"certificatesNo"]]) {
//                    [db close];
//                    if (callBack) {
//                        callBack(NO,model,@"已经存在该证件号的联系人");
//                    }
//                    return ;
//                }
//            }
//
//            NSString *sqlStr = @"INSERT INTO 'tb_person_always_used' (mobile,chinaName,englishName,certificates,certificatesNo,birthDate) values (?,?,?,?,?,?)";
//            isSave = [db executeUpdate:sqlStr withArgumentsInArray:@[strOrEmpty([dict objectForKey:@"mobile"]),strOrEmpty([dict objectForKey:@"cName"]),strOrEmpty([dict objectForKey:@"eName"]),strOrEmpty([dict objectForKey:@"certificates"]),strOrEmpty([dict objectForKey:@"certificatesNo"]),strOrEmpty([dict objectForKey:@"birthDate"])]];
//        } else {//旧的,就更新
//            NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@='%@',%@='%@',%@='%@',%@='%@',%@='%@',%@='%@' where %@='%@'",@"tb_person_always_used",@"mobile",strOrEmpty([dict objectForKey:@"mobile"]),@"chinaName",strOrEmpty([dict objectForKey:@"cName"]),@"englishName",strOrEmpty([dict objectForKey:@"eName"]),@"certificates",strOrEmpty([dict objectForKey:@"certificates"]),@"certificatesNo",strOrEmpty([dict objectForKey:@"certificatesNo"]),@"birthDate",strOrEmpty([dict objectForKey:@"birthDate"])
//                                   ,@"certificatesNo",[dict objectForKey:@"oldCertificatesNo"]];
//            isSave = [db executeUpdate:updateSql];
//        }
//        [db close];
//        if (callBack) {
//            callBack(isSave,model,nil);
//        }
//    }];
//}
//
//- (void)deleteAlwaysContactPeoPleDataToDataBase:(NSDictionary *)dict :(void(^)(BOOL isDelete))callBack {
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//
//        [db open];
//
//        NSString *deleteSql = [NSString stringWithFormat:
//                               @"delete from %@ where %@ = '%@'",
//                               @"tb_person_always_used", @"certificatesNo", [dict objectForKey:@"certificatesNo"]];
//        BOOL isDelete = [db executeUpdate:deleteSql];
//        [db close];
//        if (callBack) {
//            callBack(isDelete);
//        }
//    }];
//}

//dealloc
- (void)dealloc
{
    self.dbQueue = nil;
}
/** 火车票本地存储相关  目前不用
 - (void)saveTrainListDataToDataBase:(NSArray *)trainListData {
 
 [self.dbQueue inDatabase:^(FMDatabase *db) {
 [db open];
 NSString *sql = @"DELETE FROM tb_train_list;";
 BOOL isSuccess = [db executeUpdate:sql];
 [db close];
 if (isSuccess) {
 [db open];
 NSString *insetSql = @"INSERT INTO 'tb_train_list' (train_type,train_code,run_time,run_time_minute,from_station_name,to_station_name,start_time,arrive_time,edz_num,ydz_num,swz_num,rz_num,yz_num,yw_num,tdz_num,rw_num,gjrw_num,wz_num,qtxb_num,wz_price,yw_price,edz_price,yz_price,rwx_price,swz_price,ywz_price,rz_price,ydz_price,tdz_price,qtxb_price,ywx_price,gjrw_price,rws_price,rw_price,gjrws_price,note,arrive_days,train_no,from_station_code,to_station_code,noteStr,min_price) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
 //开启事务
 [db beginTransaction];
 for (UDDTrainTicketModel *model in trainListData) {
 
 [db executeUpdate:insetSql withArgumentsInArray:@[model.train_type,model.train_code,model.run_time,model.run_time_minute,model.from_station_name,model.to_station_name,model.start_time,model.arrive_time,model.edz_num,model.ydz_num,model.swz_num,model.rz_num,model.yz_num,model.yw_num,model.tdz_num,model.rw_num,model.gjrw_num,model.wz_num,model.qtxb_num,model.wz_price,model.yw_price,model.edz_price,model.yz_price,model.rwx_price,model.swz_price,model.ywz_price,model.rz_price,model.ydz_price,model.tdz_price,model.qtxb_price,model.ywx_price,model.gjrw_price,model.rws_price,model.rw_price,model.gjrws_price,model.note,model.arrive_days,model.train_no,model.from_station_code,model.to_station_code,model.noteStr,model.min_price]];
 }
 [db commit];
 NSLog(@"插入成功!");
 [db close];
 
 }
 }];
 }
 
 - (NSArray *)getTrainListDataFormsSift:(NSArray *)trainListData {
 //    NSMutableArray *trainListArray = [NSMutableArray array];
 [self.dbQueue inDatabase:^(FMDatabase *db) {
 [db open];
 
 FMResultSet *result =  [db executeQuery:@"select * from tb_train_list"];
 NSMutableArray *array = [[NSMutableArray alloc]init];
 
 while ([result next]) {
 
 UDDTrainTicketModel *model = [[UDDTrainTicketModel alloc]init];
 NSLog(@"%@",[result stringForColumn:@"start_time"]);
 [array addObject:model];
 }
 [db close];
 }];
 return nil;
 }
 */
@end

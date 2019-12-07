//
//  YLAllRequestSharedData.m
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "PPAllRequestSharedData.h"
#import "PPUserModel.h"
//#import "NSString+URLUtils.h"
#import "PPCheckSign.h"
#import "PPSign.h"
#import "UITool.h"


static PPAllRequestSharedData *sharedData = nil;

@interface PPAllRequestSharedData ()

@end

@implementation PPAllRequestSharedData

+ (PPAllRequestSharedData*)sharedData{
    if ( sharedData == nil ) {
        
        sharedData = [[PPAllRequestSharedData alloc] init];
        
    }
    return sharedData;
}

- (void)requestMsgWithPhoneData:(NSDictionary *)userData callBack:(void(^)(BOOL success ,NSString *msg))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:userData];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetSMSVerifiCode] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常");
        
    }];
}

- (void)requestLoginWithUserData:(NSDictionary *)userData callBack:(void(^)(BOOL success ,NSString *msg))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:userData];

    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetRegisterLogIn] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            PPUserModel *model = [PPUserModel yy_modelWithDictionary:responseObject[@"data"]];
            [model bg_save];
            actionHandler(true,@"登录成功");
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常");

    }];
    
}

- (void)requestUserDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetQueryUserDetails] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([PPCheckSign checkSignData:responseObject]) {
            PPUserModel *model = [PPUserModel yy_modelWithDictionary:responseObject[@"data"]];

            [model saveUserData];
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestUploadHeaderImageData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@upload/fileuploadImages?",kNetBaseURL];
    //@"http://47.98.188.106:8080/yizhan_rest/upload/fileuploadImages?"
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in [data objectForKey:@"pic"]) {
            NSData *data = UIImageJPEGRepresentation(image,0.1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([responseObject[@"code"]integerValue]==200) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        actionHandler(false,@"网络连接异常",@{});
    }];
    
}

- (void)requestHomeDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/getbookkeepinghomelist"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestBillDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/getbookkeepinghomelist"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}


- (void)requestSearchBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/findbook"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestGetBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/getbooklist"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}




- (void)requestDeleteBillWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    

    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/deletebookkeeping"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}


- (void)requestEditBookData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/updtebook"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestDeleteAccountBookWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];

    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/deletebook"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
- (void)requestBillDetailWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/findbookkeeping"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}


- (void)requestAccountBookTypeData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/getbookkeepingtype"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestInsertBookData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/savebook"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestInsertBillData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/savebookkeeping"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
//
- (void)requestEditBillData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"book/updatebookkeeping"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestBankDataWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetBankList] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestBankCardListWithData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetBankCardList] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
- (void)requestInsertBankCardBankData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetSaveBankCard] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestDeleteBankCardBankData:(NSDictionary *)Data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:Data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetDeleteBankCard] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestUpdateHeaderImageData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetUploadAvatar] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
- (void)requestUpdateUserNameData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetUpdateNikeName] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestUpdateUserIdCardData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetUserCard] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestTestData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetAdmittancecheck] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestUpdateUserData:(NSDictionary *)data callBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:data];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetUpdateUser] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
- (void)requestRelationDataCallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:@{@"":@""}];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"dictionary/getrelationlist"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestCityParam:(NSDictionary *)pram CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *param = [PPSign getRequestParam:pram];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"region/getregionlist"] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestValidateFaceIdData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"user/userface"] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestSaveBankCardData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetSaveBankCard] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestOrderTrialData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetOrdertrial] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}
- (void)requestQueryOrderResultData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetCreditResult] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestLoanMoneyData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetLoan] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestSendrePayotpData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetRepayment] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestQueryrepayPlanData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetRepaymentPlan] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

- (void)requestQueryContractInfoData:(NSDictionary *)param CallBack:(void(^)(BOOL success ,NSString *msg,id data))actionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [PPSign setRequestHeaderObject:manager];
    NSDictionary *paramDic = [PPSign getRequestParam:param];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",kNetBaseURL,@"user/querycontractinfo"] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----%@---",responseObject);
        if ([PPCheckSign checkSignData:responseObject]) {
            
            actionHandler(true,responseObject[@"msg"],responseObject[@"data"]);
        }else{
            actionHandler(false,[responseObject objectForKey:@"msg"],@{});
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----%@---",error);
        actionHandler(false,@"网络连接异常",@{});
        
    }];
}

@end

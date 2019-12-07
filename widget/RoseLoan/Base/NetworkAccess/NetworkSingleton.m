//
//  NetworkSingleton.m
//  meituan
//
//  Created by jinzelu on 15/6/17.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "NetworkSingleton.h"
#import "PPDeviceInformation.h"
#import "PPUserModel.h"
#import "PPCheckSign.h"
@interface NetworkSingleton()<AFURLResponseSerialization>

@end
@implementation NetworkSingleton

+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}
-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    return manager;
}

- (NSString *)handleUrlWithParamWithStr:(NSString *)str {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:@"ios" forKey:@"client"];
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [dataDic setObject:nowVer forKey:@"version"];
    [dataDic setObject:[PPUserModel sharedUser].userId forKey:@"userId"];
    [dataDic setObject:[PPDeviceInformation getUUIDString] forKey:@"deviceId"];
    return [self addQueryStringToUrl:str params:dataDic];
}

-(NSDictionary *)setParamsToDic:(NSMutableDictionary *)myDic{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:myDic];
    [dataDic setObject:@"ios" forKey:@"client"];
    NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [dataDic setObject:nowVer forKey:@"version"];
    [dataDic setObject:[PPUserModel sharedUser].userId forKey:@"userId"];
    [dataDic setObject:[PPDeviceInformation getUUIDString] forKey:@"deviceId"];
    return dataDic;
}
#pragma mark - 获取网络信息
-(void)getData:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            url = [self handleUrlWithParamWithStr:url];

            [manager GET:url parameters:userInfo progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary * dict = [self parseJSONStringToNSDictionary:str];
                if ([PPCheckSign checkSignData:responseObject]) {
                    successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
                }else{
                    successBlock(dict,response.statusCode);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *strErrorMsg = @"网络连接异常";
                
                failureBlock(error,response.statusCode,strErrorMsg);
            }];
            
            
        }
        @catch (NSException *exception) {
            
        }

}

-(void)applicationJsonPost:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
//            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:userInfo error:nil];
//            request.timeoutInterval = 10.f;
//            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
//            NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
//                    NSDictionary *dict = (NSDictionary *)responseObject;
//                    if ([PPCheckSign checkSignData:dict]) {
//                        successBlock(dict,response.statusCode);
//                    }else{
//                        failureBlock(error,[dict[@"code"] intValue],dict[@"msg"]);
//                    }
//                } else {
//                    NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
//                    failureBlock(error,response.statusCode,@"");
//                }
//                dispatch_semaphore_signal(semaphore);
//            }];
//            [task resume];
//            dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
            
            // 2.封装请求
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.f]; // post
//            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPMethod:@"POST"];
//            
//            NSData *data= [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
//            [request setHTTPBody:data];
//            
//            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
//            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
//                if (!error) {
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    if ([PPCheckSign checkSignData:dic]) {
//                        successBlock(dic,0);
//                    }else{
//                        failureBlock(error,[dic[@"code"] intValue],dic[@"msg"]);
//                    }
//                }else{
//                    failureBlock(error,0,@"");
//                }
//                dispatch_semaphore_signal(semaphore);//不管请求状态是什么，都得发送信号，否则会一直卡着进程
//            }];
//            [task resume];
//            dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
        }
        @catch (NSException *exception) {

        }
}

-(void)getDataPost:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    @try {
        AFHTTPSessionManager *manager = [self baseHtppRequest];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        (manager.requestSerializer).timeoutInterval = 10;
        
        [manager POST:url parameters:userInfo constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //responseObject：服务器返回的数据
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSDictionary * dict = responseObject;
            if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
            }else{
                if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                    //                        [[UserManager sharedUserManager] logout];
                }
                successBlock(responseObject,response.statusCode);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSString *strErrorMsg;
            failureBlock(error,response.statusCode,strErrorMsg);
        }];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)getDataPostUTf8:(NSMutableDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    @try {
        AFHTTPSessionManager *manager = [self baseHtppRequest];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/octet-stream" ,@"text/json", @"text/javascript", @"text/html",@"text/plain",@"image/jpeg",@"image/png", nil];
        
        (manager.requestSerializer).timeoutInterval = 10;
        
        [manager POST:url parameters:userInfo constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //responseObject：服务器返回的数据
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSDictionary * dict = responseObject;
            if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
            }else{
                if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                    //                        [[UserManager sharedUserManager] logout];
                }
                successBlock(responseObject,response.statusCode);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSString *strErrorMsg = @"网络连接异常";
            failureBlock(error,response.statusCode,strErrorMsg);
        }];
    }
    @catch (NSException *exception) {
        
    }
}

/**
 *  上传图片
 *
 *  @param url          接口地址
 *  @param params       参数
 *  @param fileDatas     文件
 *  @param timeOut      访问时间
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas timeOut:(int)timeOut successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            (manager.requestSerializer).timeoutInterval = timeOut;
            
            NSURLSessionDataTask *uploadTask = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                for (NSDictionary *dic in fileDatas) {
                    UIImage *image = dic[@"image"];
                    NSData *data = [self imageData:image];
                    NSLog(@"%lu",(unsigned long)data.length);
                    [formData appendPartWithFileData:data
                                                name:dic[@"key"]          //服务器接收的key
                                            fileName:dic[@"name"]           //文件名称
                                            mimeType:@"image/jpeg"];     //文件类型(根据不同情况自行修改)
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                double com = uploadProgress.fractionCompleted;
                NSLog(@"进度:%f",uploadProgress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSDictionary * dict = responseObject;
                if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                    
                    successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
                }else{
                    if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                    }
                    successBlock(responseObject,response.statusCode);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *strErrorMsg = @"网络连接异常";
                failureBlock(error,response.statusCode,strErrorMsg);
                
            }];
            
//            [uploadTask resume];
            
        } @catch (NSException *exception) {
            
        }
}
/**
 *  上传图片
 *
 *  @param url          接口地址
 *  @param params       参数
 *  @param image     文件
 *  @param timeOut      访问时间
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
-(void)uploadImageWithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image timeOut:(int)timeOut successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
        @try {
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            (manager.requestSerializer).timeoutInterval = timeOut;
            
            NSURLSessionDataTask *uploadTask = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *data = [self imageData:image];
                [formData appendPartWithFileData:data
                                            name:@"image"          //服务器接收的key
                                        fileName:@"image"           //文件名称
                                        mimeType:@"image/jpeg"];     //文件类型(根据不同情况自行修改)
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                double com = uploadProgress.fractionCompleted;
                NSLog(@"进度:%f",uploadProgress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSDictionary * dict = responseObject;
                if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                    
                    successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
                }else{
                    if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
//                        [[UserManager sharedUserManager] logout];
                    }
                    successBlock(responseObject,response.statusCode);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSString *strErrorMsg = @"网络连接异常";
                
                failureBlock(error,response.statusCode,strErrorMsg);
                
            }];
            
            //            [uploadTask resume];
            
        } @catch (NSException *exception) {
            
        }
}

-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
/**
 json转array

 @param str
 @return 
 */
-(NSArray *)parseJSONStringToArray:(NSString *)str{
    NSData *JSONData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
/*!
 *  @brief 字典转Json字符串
 *
 *  @param object 字典
 *
 *  @return Json字符串
 */
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData;
    if (object != nil) {
        jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted
                    // Pass 0 if you don't care about the readability of the generated string
                                                     error:&error];
    }
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
-(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024)
        {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
// 把传入的参数按照get的方式打包到url后面。
-(NSString *)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params
{
    if (nil == url) {
        return @"";
    }
    
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
    // Convert the params into a query string
    if (params) {
        for(id key in params) {
            NSString *sKey = [key description];
            NSString *sVal = [params[key] description];
            //是否有？，必须处理这个
            if ([urlWithQuerystring rangeOfString:@"?"].location==NSNotFound) {
                [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
            } else {
                [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
            }
        }
    }
    return urlWithQuerystring;
}
-(NSString *)urlEscape:(NSString *)unencodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)unencodedString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 kCFStringEncodingUTF8));
}

/**
 *  先调整分辨率，分辨率可以自己设定一个值，大于的就缩小到这分辨率，小余的就保持原本分辨率。然后在判断图片数据大小，传入范围maxSize = 100 ，大于的再压缩，小的就保持原样
 */
-(NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize {
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);      CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();     UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = imageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    // 判断是否大于传入的值
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);         return finallImageData;
    }
    
    return imageData;
}
@end

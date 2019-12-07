//
//  PPSign.m.m
//  UddTrip
//
//  Created by Chuan Liu on 16/9/5.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "PPSign.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <GTMBase64.h>
#import "AES128Util.h"

@implementation PPSign


+ (void)setRequestHeaderObject:(AFHTTPSessionManager *)manager{

    [PPSign httpRequstValiteWith:manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"UDD-Token"];
}

+ (void)setRequestHotelHeaderObject:(AFHTTPSessionManager *)manager withToken:(NSString *)token {
    
    [PPSign httpRequstValiteWith:manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"
                     forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"UDD-Token"];
}

/**
 *  https 请求方法
 *
 */

+(void)httpRequstValiteWith:(AFHTTPSessionManager *)manager{
    
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
//    if ([kHttpsRequest isEqualToString:@"https"] ) {
//        manager.securityPolicy  = [PPSign.m customSecurityPolicy];
//    }else{
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    }
    
}

/**
 *  @brief HTTPS单向验证
 */
+ (AFSecurityPolicy *)customSecurityPolicy{
    
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"api.uddtrip.com" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}


+ (NSDictionary *)getRequestParam:(NSDictionary *)param{
    
    
    
    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:param
                                                              options:kNilOptions
                                                                error:nil];
    
    NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
    
    
    NSString *encryStr = [AES128Util AES128Encrypt:jsonRequestString key:@"lianghuilonglong"];
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:encryStr,@"param", nil];
    
}

+ (NSString *)md5HexDigest:(NSString *)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *returnHashSum = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnHashSum appendFormat:@"%02x", result[i]];
    }
    
    return returnHashSum;
}

+ (NSString *)hyb_AESDecrypt:(NSString *)encryptText password:(NSString *)key{
    if (key == nil || (key.length != 16 && key.length != 32)) {
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [key getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        NSString *decoded=[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        return decoded;
    }
    
    free(buffer);
    return nil;
}

@end

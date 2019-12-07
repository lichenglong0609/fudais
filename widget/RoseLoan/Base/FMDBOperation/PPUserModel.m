//
//  PPUserModel.m
//  UIViewTest
//
//  Created by cy on 16/9/23.
//  Copyright © 2016年 Cy. All rights reserved.
//


#import "PPUserModel.h"
#import "FMDBManager.h"

@implementation PPUserModel

static PPUserModel *_instance = nil;


+(instancetype)sharedUser{
    
    if ([PPUserModel bg_findAll:@"PPUserModel"].count>0) {
        return [PPUserModel bg_findAll:@"PPUserModel"].firstObject;
    }
    
    return [[self alloc] init];
}


- (instancetype)init{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [super init];
        
    });
    
    
    return _instance;
}




- (void)checkOutLogin{
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if([cookie.name isEqualToString:@"token"]){
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
    /** 性别 */
    self.userSex = 0;
    
    self.userRelationshipname = @"";
    
    self.userPic = @"";
    self.userRelationship = 0;
    self.recommendationCode = 0;
    self.registerSource = 0;
    
    self.agency = @"";
    self.validdateEnd = @"";
    self.recommendationCount = 0;
    
    self.zhengAddress = @"";
    self.userRelationshipphone = @"";
    self.userAddress = @"";
    self.userIntroduction = @"";
    self.userRealname = @"";
    
    self.userOrderstatus = 0;
    self.recommendationRate = 0;
    self.userAuthentication = 0;
    self.userRegion = 0;
    
    self.userSesamecredit = @"";
    self.facedetectimageList = @"";
    self.userPassword = @"";
    self.userOrderno = @"";
    self.userOrderstatusmessage = @"";
    self.userBankno = @"";
    self.userCardholder = @"";
    self.userCard = @"";
    self.loanCount = 0;
    self.userStatus = 0;
    self.status = 0;
    self.showLoanSupermarket = 0;
    
    self.agentCode = @"";
    self.userCardFanpic = @"";
    self.userCardPic = @"";
    self.userBank = @"";
    
    self.nation = @"";
    self.facedetectScore = @"";
    self.userLogin = @"";
    self.userDate = @"";
    self.userNickname = @"";
    
    
    self.userStep = 0;
    self.userType = 0;
    
    /** 用户Id */
    self.userId = 0;
    
    self.stypeId = @"";
    
    [self saveUserData];
}



- (void)saveUserData{
    [self bg_cover];
}

- (BOOL)checkIsLogin{
    
    
    if ([self.tokenId length] > 0 | [self.userId length] > 0) {
        return YES;
    }
    return NO;
}

- (void)setTokenId:(NSString *)tokenId{
    
    _tokenId = tokenId;
}


@end

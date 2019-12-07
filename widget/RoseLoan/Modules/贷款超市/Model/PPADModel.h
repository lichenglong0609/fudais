//
//  PPADModel.h
//  PostProduct
//
//  Created by 尚宇 on 2018/8/20.
//  Copyright © 2018年 cython. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPADModel : NSObject


@property (nonatomic,assign) NSInteger applicationNumber;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger status;

@property (nonatomic,strong) NSString *applicationDesc;
@property (nonatomic,strong) NSString *approvalDesc;
@property (nonatomic,strong) NSString *interestRate;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *quota;
@property (nonatomic,strong) NSString *url;

@end

//
//  PPPurchaseViewController.h
//  PostProduct
//
//  Created by Risk on 2018/8/23.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "BaseWebviewController.h"

@interface PPPurchaseViewController : BaseWebviewController


/**对应字段contractPage 4绑定银行卡 3是绑定银行卡 5是借款合同*/
@property (nonatomic,strong) NSString * docType;

/**url*/
@property (nonatomic,strong) NSString *urlString;

@property (nonatomic,strong) NSDictionary *urlDictInfo;

@end

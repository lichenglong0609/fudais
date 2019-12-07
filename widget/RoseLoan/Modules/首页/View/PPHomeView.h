//
//  PPHomeView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPADModel.h"
@protocol ChangeNavDelegate<NSObject>
-(void)changeNavBarWithScroll:(UIScrollView *)scrollView;
-(void)clickProject:(NSDictionary *)dic;
@end

@interface PPHomeView : UIView
@property (nonatomic,weak) id<ChangeNavDelegate> navDelegate;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSMutableArray <NSString *>*sections;//根据数据设置活的顺序
///点击产品
@property (nonatomic,strong) void(^viewProductDetailsBlock)(PPADModel *model);
///借款金额
@property (nonatomic,strong) void(^borrowMoneyBlock)(void);
///注册
@property (nonatomic,strong) void(^clickTopBannerBlock)(NSInteger index);
///点击Banner
@property (nonatomic, strong) void(^clickBannerBlock)(NSInteger index);
@end

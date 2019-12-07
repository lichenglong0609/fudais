//
//  PPAmountHeaderView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PPAmountHeaderView : UIView
@property (nonatomic,strong) void(^toBorrowMoneyBlock)(void);
@property (nonatomic,strong) void(^clickProjectBlock)(void);
-(instancetype)loadFromNib;
-(void)setData:(NSDictionary *)info;
@end

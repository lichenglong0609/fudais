//
//  PPMarketTableViewCell.h
//  PostProduct
//
//  Created by 尚宇 on 2018/8/20.
//  Copyright © 2018年 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPADModel,PPMarketTableViewCell;

@protocol PPMarketTableViewCellDelegate <NSObject>

@optional

- (void)didClickButtonTableViewCell:(PPMarketTableViewCell*)cell;

@end

@interface PPMarketTableViewCell : UITableViewCell

@property (nonatomic,strong) PPADModel *model;

@property (nonatomic,weak) id<PPMarketTableViewCellDelegate>delegate;

@end



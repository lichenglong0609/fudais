//
//  PPPersonalInfoCell.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPPersonalInfoCell : UITableViewCell
@property (nonatomic,strong) void(^loginBlock)(void);
@property (nonatomic,strong) void(^signOutBlock)(void);
-(void)resetUserName;

@end

NS_ASSUME_NONNULL_END

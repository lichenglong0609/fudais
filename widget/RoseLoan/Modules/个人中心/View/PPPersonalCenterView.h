//
//  PPPersonalCenterView.h
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickTableViewCellDelegate <NSObject>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)row;

@end

@interface PPPersonalCenterView : UIView
@property (nonatomic,weak) id<ClickTableViewCellDelegate> delegate;
@property (nonatomic,strong) void(^toLoginBlock)(void);
@property (nonatomic,strong) void(^tosignoutBlock)(void);
@property (nonatomic,strong) UITableView *tableView;

-(void)reloadData;
@end

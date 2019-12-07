//
//  PPPersonalCenterView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPPersonalCenterView.h"
#import "PPUserModel.h"
#import "PPPersonalInfoCell.h"
#import "PPPCIconTitleCell.h"
@interface PPPersonalCenterView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy) NSArray *cellArr;
@end
@implementation PPPersonalCenterView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-kStatusBarHeight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - KTabbarHeight + kStatusBarHeight);
    }];
}
-(void)reloadData{
    [self.tableView reloadData];
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView layoutIfNeeded];
    }
    return _tableView;
}
-(NSArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [[NSArray alloc] init];
        _cellArr = @[
              @{@"iconName":@"icon_personalInformation",@"title":@"个人信息"},
//              @{@"iconName":@"icon_bankCard",@"title":@"我的银行卡"},
              @{@"iconName":@"icon_privacyAgreement",@"title":@"隐私协议"},
              @{@"iconName":@"icon_aboutUs",@"title":@"关于我们"}
          ];
    }
    return _cellArr;
}
#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.cellArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return AdaptW(205);
    }else{
        return AdaptW(55);
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PPPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPPersonalInfoCell"];
        if (cell == nil) {
            cell = [[PPPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PPPersonalInfoCell"];
        }
        __weak typeof(self) weakSelf = self;
        cell.loginBlock = ^{
            if (weakSelf.toLoginBlock) {
                weakSelf.toLoginBlock();
            }
        };
        cell.signOutBlock = ^{
            if (weakSelf.tosignoutBlock) {
                weakSelf.tosignoutBlock();
            }
        };
        [cell resetUserName];
        return cell;
    }else{
        PPPCIconTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPPCIconTitleCell"];
        if (cell == nil) {
            cell = [[PPPCIconTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NSDictionary *dic = self.cellArr[indexPath.row];
        [cell setImage:dic[@"iconName"] title:dic[@"title"]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.section == 1) {
        if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndex:)]) {
            [self.delegate tableView:tableView didSelectRowAtIndex:indexPath.row];
        }
    }
}
@end

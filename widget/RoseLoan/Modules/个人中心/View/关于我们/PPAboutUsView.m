//
//  PPAboutUsView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPAboutUsView.h"
#import "PPUsInfoCell.h"
#import "PPVersionInfoCell.h"
@interface PPAboutUsView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *label;
@end
@implementation PPAboutUsView
-(instancetype)init{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.tableView];
    [self addSubview:self.label];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - kStatusBarAndNavcHeight);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-AdaptW(kStatusBarAndNavcHeight));
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(AdaptW(9));
    }];
}
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
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"Copyright © 2019 All Right Reserve";
        _label.font = [UIFont systemFontOfSize:9];
        _label.textColor = hexColor(959595);
    }
    return _label;
}
#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return AdaptW(278);
    }else{
        return AdaptW(45);
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PPUsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPUsInfoCell"];
        if (cell == nil) {
            cell = [[PPUsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PPUsInfoCell"];
        }
        return cell;
    }else{
        PPVersionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPVersionInfoCell"];
        if (cell == nil) {
            cell = [[PPVersionInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PPVersionInfoCell"];
        }
        return cell;
    }
}
@end

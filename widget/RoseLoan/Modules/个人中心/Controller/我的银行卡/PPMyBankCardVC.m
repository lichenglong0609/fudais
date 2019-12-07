//
//  PPMyBankCardVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/20.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPMyBankCardVC.h"
#import "PPAddBankCardCell.h"
#import "PPBankCardInfoCell.h"
#import "NetworkSingleton.h"
#import "PPUserModel.h"
#import "PPCertificationVC.h"
@interface PPMyBankCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<NSString *> *sections;
@property (nonatomic,strong) NSArray *bankCards;
@end

@implementation PPMyBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)setUpUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - SafeBottomH);
    }];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"实名认证中..."];
    [[NetworkSingleton sharedManager] getDataPost:@{@"userId":[PPUserModel sharedUser].userId} url:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetCardList] successBlock:^(NSDictionary *responseObject, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        
        self.bankCards = responseObject[@"data"];
        [self.sections addObject:@"0"];
//        [self.sections addObject:@"1"];
        [self.tableView reloadData];
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg.length > 0 ? errorMsg : @"网络异常请稍后重试"];
    }];
    
//    [self.sections addObject:@"1"];
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
    }
    return _tableView;
}
-(NSMutableArray *)sections{
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}
-(NSArray *)bankCards{
    if (!_bankCards) {
        _bankCards = [[NSArray alloc] init];
    }
    return _bankCards;
}
#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sections[section].intValue == 0) {
        return self.bankCards.count;
    }else if (self.sections[section].intValue == 1){
        return 1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections[indexPath.section].intValue == 0) {
        return AdaptW(138);
    }else if (self.sections[indexPath.section].intValue == 1){
        return AdaptW(103);
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.sections[section].intValue == 0) {
        return 10;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections[indexPath.section].intValue == 0) {
        PPBankCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPBankCardInfoCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PPBankCardInfoCell" owner:nil options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.bankCards[indexPath.row];
        [cell fillInformation:dic];
        return cell;
    }else if (self.sections[indexPath.section].intValue == 1){
        PPAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPAddBankCardCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PPAddBankCardCell" owner:nil options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections[indexPath.section].intValue == 1) {
        PPCertificationVC *vc = [[PPCertificationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

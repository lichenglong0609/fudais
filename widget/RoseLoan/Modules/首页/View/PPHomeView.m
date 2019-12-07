//
//  PPHomeView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPHomeView.h"
#import "PPAmountHeaderView.h"
//#import "PPIntroductionHeaderView.h"
#import "PPSigningView.h"
#import "PPTitleHeaderView.h"
#import "PPBorderlessAdView.h"

#import "PPMarketTableViewCell.h"
@interface PPHomeView()<UITableViewDelegate,UITableViewDataSource,PPMarketTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray<PPADModel *> *dataArr;
@property (nonatomic,copy) PPAmountHeaderView *amountHV;
@property (nonatomic,copy) PPBorderlessAdView *signingView;
@property (nonatomic,copy) PPTitleHeaderView *titleHeaderView;
@property (nonatomic,copy) PPTitleHeaderView *recommendTitle;

@property (nonatomic,copy) NSDictionary *amountDic;
@property (nonatomic,copy) NSArray *signingArr;
@property (nonatomic,copy) NSArray *bannerInfo;

@property (nonatomic, strong) NSMutableArray *specialBanners;
@end
@implementation PPHomeView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.tableView];
}
-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    self.dataArr = [[NSMutableArray alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    self.amountDic = infoDic[@"amountInfo"];
    self.signingArr = infoDic[@"topBanners"];
    self.bannerInfo = infoDic[@"middleBanners"];
    self.specialBanners = infoDic[@"specialBanners"];
    if (self.amountDic != nil && self.amountDic.count > 0) {
        if (self.specialBanners.count > 0) {
            [self.amountHV setData:self.specialBanners[0]];
        }
        [self.sections addObject:@"0"];
    }
    [self.sections addObject:@"1"];
    if (self.signingArr != nil && self.signingArr.count > 0) {
        [self.signingView setImageDatas:self.signingArr];
        [self.sections addObject:@"2"];
    }
    
    NSArray *arr = infoDic[@"products"];
    if (arr != nil && arr.count > 0) {
        [self.sections addObject:@"3"];
    }
    
    if (arr != nil && arr.count > 0) {
        for (NSDictionary *dic in arr) {
            PPADModel *model = [PPADModel yy_modelWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        [self.sections addObject:@"5"];
    }
    [self.tableView reloadData];
}

#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.opaque = YES;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[PPMarketTableViewCell class] forCellReuseIdentifier:@"PPMarketTableViewCellId"];
    }
    return _tableView;
}
-(NSMutableArray<NSString *> *)sections{
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}
-(NSMutableArray<PPADModel *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
-(PPAmountHeaderView *)amountHV{
    if (!_amountHV) {
        _amountHV = [[PPAmountHeaderView alloc] loadFromNib];
        __weak typeof(self) weakSelf = self;
        _amountHV.toBorrowMoneyBlock = ^{
//            if (weakSelf.borrowMoneyBlock) {
//                weakSelf.borrowMoneyBlock();
//            }
            if ([weakSelf.navDelegate respondsToSelector:@selector(clickProject:)]) {
                [weakSelf.navDelegate clickProject:weakSelf.specialBanners[0]];
            }
        };
        _amountHV.clickProjectBlock = ^{
            if ([weakSelf.navDelegate respondsToSelector:@selector(clickProject:)]) {
                [weakSelf.navDelegate clickProject:weakSelf.specialBanners[0]];
            }
            
        };
    }
    return _amountHV;
}
-(NSMutableArray *)specialBanners{
    if (!_specialBanners) {
        _specialBanners = [[NSMutableArray alloc] init];
    }
    return _specialBanners;
}

-(PPBorderlessAdView *)signingView{
    if (!_signingView) {
        _signingView = [[PPBorderlessAdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AdaptW(71))];
        __weak typeof(self) weakSelf = self;
        _signingView.clickBanner = ^(NSInteger index) {
            weakSelf.clickTopBannerBlock(index);
        };
    }
    return _signingView;
}
-(PPTitleHeaderView *)titleHeaderView{
    if (!_titleHeaderView) {
        _titleHeaderView = [[PPTitleHeaderView alloc] loadFromNib];
    }
    return _titleHeaderView;
}
-(PPTitleHeaderView *)recommendTitle{
    if (!_recommendTitle) {
        _recommendTitle = [[PPTitleHeaderView alloc] loadFromNib];
        _recommendTitle.title = @"热门推荐";
        _recommendTitle.line.backgroundColor = [UIColor whiteColor];
    }
    return _recommendTitle;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sections[section].intValue == 0) {
        return 0;
    }else if (self.sections[section].intValue == 1) {
        return 0;
    }else if (self.sections[section].intValue == 2) {
        return 0;
    }else if (self.sections[section].intValue == 3) {
        return 0;
    }else if (self.sections[section].intValue == 4) {
        return 0;
    }else if (self.sections[section].intValue == 5) {
        return self.dataArr.count;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptW(124);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.sections[section].intValue == 0) {
        return AdaptW(360);
    }else if (self.sections[section].intValue == 1) {
        return 38;
    }else if (self.sections[section].intValue == 2) {
        return AdaptW(80);
    }else if (self.sections[section].intValue == 3) {
        return 38;
    }else if (self.sections[section].intValue == 4) {
        return 149+1;
    }else if (self.sections[section].intValue == 5) {
        return 0.01;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.sections[section].intValue == 0) {
        if (self.specialBanners.count > 0) {
            [self.amountHV setData:self.specialBanners[0]];
        }
        return self.amountHV;
    }else if (self.sections[section].intValue == 1) {
        return self.recommendTitle;
    }else if (self.sections[section].intValue == 2) {
        return self.signingView;
    }else if (self.sections[section].intValue == 3) {
        return self.titleHeaderView;
    }else if (self.sections[section].intValue == 5) {
        return nil;
    }else{
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections[indexPath.section].intValue == 5) {
        PPMarketTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"PPMarketTableViewCellId"];
        cell.delegate = self;
        if (self.dataArr.count>indexPath.row) {
            cell.model = [self.dataArr objectAtIndex:indexPath.row];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
}
- (void)didClickButtonTableViewCell:(PPMarketTableViewCell *)cell{
    NSLog(@"---%@---",cell.model.url);
    if (self.viewProductDetailsBlock) {
        self.viewProductDetailsBlock(cell.model);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.navDelegate respondsToSelector:@selector(changeNavBarWithScroll:)]) {
        [self.navDelegate changeNavBarWithScroll:scrollView];
    }
}
@end

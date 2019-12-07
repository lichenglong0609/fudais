//
//  PPMarketViewController.m
//  PostProduct
//
//  Created by 尚宇 on 2018/8/19.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "PPMarketViewController.h"
#import "PPMarketTableViewCell.h"
#import "PPADModel.h"
#import "PPDeviceInformation.h"
#import "SupermarkerADView.h"
#import <MJRefresh/MJRefresh.h>
#import "WebViewController.h"
#import "PPLoginViewController.h"
@interface PPMarketViewController ()<UITableViewDelegate,UITableViewDataSource,PPMarketTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic,strong) SupermarkerADView *adView;
@property (nonatomic,assign) int pageNo;
@property (nonatomic,assign) int totalPage;
@end

@implementation PPMarketViewController

- (id)init{
    self = [super init];
    if (self) {
        _productArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navcTitle = @"精选下款通道";
    self.pageNo = 1;
    [self initView];
    [self loadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavcHeight - KTabbarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableHeaderView = self.adView;
        [_tableView registerClass:[PPMarketTableViewCell class] forCellReuseIdentifier:@"PPMarketTableViewCellId"];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjHeaderAction)];
        
        //设置文字
        [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即更新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在帮你刷新" forState:MJRefreshStateRefreshing];
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        header.stateLabel.textColor = hexColor(666666);
        
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        header.lastUpdatedTimeLabel.textColor = hexColor(666666);
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjFooterAction)];
        //上拉加载文字
        [footer setTitle:@"刷新加载更多数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"已经加载完毕" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = hexColor(666666);
        
        _tableView.mj_header = header;
        _tableView.mj_footer = footer;
    }
    return _tableView;
}
-(SupermarkerADView *)adView{
    if (!_adView) {
        _adView = [[SupermarkerADView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PPIWIDTHORHEIGHT(300))];
        __weak typeof(self) weakSelf = self;
        _adView.clickBanner = ^(NSInteger index) {
            [weakSelf toShowBanner:index with:weakSelf.adView.imageDatas];
        };
    }
    return _adView;
}
- (void)mjHeaderAction{
    self.tableView.mj_footer.hidden = YES;
    self.pageNo = 1;
    [self loadData];
}
- (void)mjFooterAction{
    self.pageNo++;
    [self loadData];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _productArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPMarketTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"PPMarketTableViewCellId"];
    cell.delegate = self;
    if (_productArray.count>indexPath.row) {
        cell.model = [_productArray objectAtIndex:indexPath.section];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptW(124);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络访问
/**
 统计PV
 */
-(void)statisticsPV:(NSString *)name{
    NSDictionary *dic = @{@"userId":[PPUserModel sharedUser].userId,@"location":name,@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString],@"type":@"product"};
    [CYNetwork getRequestUrl:KNETstatisticPvUv paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
        
    }];
}

-(void)loadData{
    [MBProgressHUD showActivityMessageInWindow:@"数据加载中..."];
    if (self.pageNo > self.totalPage && self.totalPage > 0) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }
    NSDictionary *parmas = @{@"pageNum":[NSString stringWithFormat:@"%d",self.pageNo]};
    __weak typeof(self) weakSelf = self;
    [[NetworkSingleton sharedManager] getDataPost:parmas url:[NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetProductList] successBlock:^(NSDictionary *responseObject, NSInteger statusCode) {
        if (weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing)[weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.tableView.mj_footer.state == MJRefreshStateRefreshing)[weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_header.hidden = NO;
        weakSelf.tableView.mj_footer.hidden = NO;
        NSDictionary *dic = responseObject[@"data"];
        NSDictionary *productsDic = dic[@"products"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (weakSelf.productArray == nil || self.pageNo == 1) {
                weakSelf.productArray = [[NSMutableArray alloc] init];
            }
            NSArray *ary = [NSArray arrayWithArray:productsDic[@"list"]];
            for (NSDictionary *dic in ary) {
                PPADModel *model = [PPADModel yy_modelWithDictionary:dic];
                [weakSelf.productArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.pageNo == 1){
                    weakSelf.adView.imageDatas = dic[@"banners"];
                    self.totalPage = [NSString stringWithFormat:@"%@",productsDic[@"totalPage"]].intValue;
                }
                [weakSelf.tableView reloadData];
                [MBProgressHUD hideHUD];
            });
        });
        if (self.pageNo >= [NSString stringWithFormat:@"%@",productsDic[@"totalPage"]].intValue) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_footer setState:MJRefreshStateIdle];
            });
        }
        
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self showFailedLoad];
    }];
}
-(void)ReacquireData{
    [super ReacquireData];
    [self hiddenTipView];
    
    [self loadData];
}
#pragma mark - 点击
- (void)didClickButtonTableViewCell:(PPMarketTableViewCell *)cell{
    if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId.intValue > 0) {
        NSLog(@"---%@---",cell.model.url);
        WebViewController *vc = [[WebViewController alloc] init];
        vc.url = strOrEmpty(cell.model.url);
        vc.titleStr = cell.model.name;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:true];
        [self statisticsPV:[NSString stringWithFormat:@"%ld",(long)cell.model.id]];
    }else{
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
        [self.navigationController presentViewController:loginNav animated:true completion:nil];
    }
}

-(void)toShowBanner:(NSInteger)row with:(NSArray *)bannerArr{
    NSDictionary *dic = bannerArr[row];
    NSString *url = dic[@"url"];
    if(url != nil && url != NULL && url.length > 0 && ![url isEqualToString:@"<null>"]){
        if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId.intValue > 0) {
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = url;
            webVC.titleStr = dic[@"title"];
            [webVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webVC animated:YES];
            [self statisticsBanner:[NSString stringWithFormat:@"%@",dic[@"id"]]];
        }else{
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:[[PPLoginViewController alloc] init]];
            [self.navigationController presentViewController:loginNav animated:true completion:nil];
        }
    }
}
-(void)statisticsBanner:(NSString *)name{
    NSDictionary *dic = @{@"userId":[PPUserModel sharedUser].userId,@"location":name,@"client":@"ios",@"deviceId":[PPDeviceInformation getUUIDString],@"type":@"banner"};
    [CYNetwork getRequestUrl:KNETstatisticPvUv paramters:dic callBack:^(BOOL success, NSString *msg, id data) {
        
    }];
}
@end

//
//  SupermarkerADView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/14.
//  Copyright © 2019 cython. All rights reserved.
//

#import "SupermarkerADView.h"
#import <TYCyclePagerView/TYPageControl.h>
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "TYCyclePagerViewCell.h"
@interface SupermarkerADView()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource>
@property (nonatomic,strong) TYCyclePagerView *pagerView;
@property (nonatomic,strong) TYPageControl *pageControl;
@end
@implementation SupermarkerADView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.pagerView];
    [self addSubview:self.pageControl];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.height.equalTo(@26);
    }];
}
-(void)loadData:(NSArray *)banners{
    self.imageDatas = banners;
    if (self.imageDatas.count > 1) {
        self.pagerView.isInfiniteLoop = YES;
    }else{
        self.pagerView.isInfiniteLoop = NO;
    }
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self.pagerView reloadData];
}
-(void)setImageDatas:(NSArray *)imageDatas{
    _imageDatas = imageDatas;
    if (self.imageDatas.count > 1) {
        self.pagerView.isInfiniteLoop = YES;
        self.pageControl.hidden = NO;
    }else{
        self.pagerView.isInfiniteLoop = NO;
        self.pageControl.hidden = YES;
    }
    self.pageControl.numberOfPages = self.imageDatas.count;
    [self.pagerView reloadData];
}
#pragma mark - 懒加载
-(TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc] initWithFrame:self.bounds];
        _pagerView.isInfiniteLoop = YES;
        _pagerView.autoScrollInterval = 3.0;
        _pagerView.delegate = self;
        _pagerView.dataSource = self;
        [_pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}
-(TYPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[TYPageControl alloc] init];
        _pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    }
    return _pageControl;
}
#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.imageDatas.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 20;
    NSDictionary *banner = self.imageDatas[index];
    NSString *imgURL = [NSString stringWithFormat:@"%@",banner[@"img"]];
    NSURL *url = [[NSURL alloc] initWithString:imgURL];
    [cell.imageView sd_setImageWithURL:url placeholderImage:ImageName(@"BannerPlaceholder")];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(pageView.frame.size.width+15, pageView.frame.size.height);
    layout.itemSpacing = 0;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
    //    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}
-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    if (self.clickBanner) {
        self.clickBanner(index);
    }
}
@end

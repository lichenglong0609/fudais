//
//  NetworkAccessResultView.m
//  wejointoo
//
//  Created by ijointoo on 2017/8/8.
//  Copyright © 2017年 demo. All rights reserved.
//

#import "NetworkAccessResultView.h"
@interface NSString (null)
-(BOOL)isUseableString;
@end
@implementation NSString (null)
-(BOOL)isUseableString{
    if (self == nil || self == NULL) {
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    if([self isEqualToString:@"''"]){
        return NO;
    }
    return YES;
}
@end
@implementation NetworkAccessResultView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self confignUI];
    }
    return self;
}

- (void)confignUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.bottomBtn];
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(kScreenHeight);
    }];
    [self.bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 32));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(weakSelf.tipLabel.mas_bottom).with.offset(25);
    }];

}

- (void)btnAction:(UIButton *)btn{
    if (self.bottomBtnAction) {
        self.bottomBtnAction();
    }
}
- (void)loadWith:(NSArray <NSString *>*)loadImages and:(NSString *)tipStr and:(NSString *)btnTitle{
    self.backgroundColor = [UIColor whiteColor];

    NSMutableArray <UIImage *>*images = [NSMutableArray new];
    for (NSString *subStr in loadImages) {
        [images addObject:[UIImage imageNamed:subStr]];
    }
    self.imageView.animationImages = images;
    self.imageView.animationDuration = 0.8;
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(images.firstObject.size.width>kScreenWidth?CGSizeMake(images.firstObject.size.width/2, images.firstObject.size.height/2):images.firstObject.size);
    }];
    
    self.tipLabel.text = tipStr;
    self.tipLabel.preferredMaxLayoutWidth = kScreenWidth - 20;
    __weak typeof(self) weakSelf = self;
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(20);
    }];
    
    [self masonryContentView:images.firstObject and:tipStr and:btnTitle];
}
- (void)failedWith:(NSString *)failedImage and:(NSString *)tipStr{
    self.backgroundColor = [UIColor whiteColor];

    UIImage *image = [UIImage imageNamed:failedImage];
    self.imageView.image = image;
    self.imageView.animationImages = nil;
    [self.imageView stopAnimating];
    
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(kStatusBarAndNavcHeight);
        make.size.mas_equalTo(image.size.width>kScreenWidth?CGSizeMake(image.size.width/2, image.size.height/2):image.size);
    }];

    self.tipLabel.text = tipStr;
    self.tipLabel.preferredMaxLayoutWidth = kScreenWidth - 20;
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(20);
    }];
    [self.bottomBtn setTitle:@"重新加载" forState:UIControlStateNormal];

    [self masonryContentView:image and:tipStr and:@"重新加载"];
}
- (void)noDataWithNoDataImage:(NSString *)noDataImage tipStr:(NSString *)tipStr bottomBtnTitle:(NSString *)btnTitle viewCenterY:(CGFloat)centerY{
    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    if (![noDataImage isUseableString]) {
        noDataImage = @"jiazaiNoData";
    }
    UIImage *image = [UIImage imageNamed:noDataImage];
    self.imageView.image = image;
    self.imageView.animationImages = nil;
    [self.imageView stopAnimating];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(image.size.width>kScreenWidth?CGSizeMake(image.size.width/2, image.size.height/2):image.size);
    }];
    
    self.tipLabel.text = tipStr;
    self.tipLabel.preferredMaxLayoutWidth = kScreenWidth - 20;
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(20);
    }];
    
    [self.bottomBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    [self masonryContentView:image and:tipStr and:btnTitle];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, (image.size.width>kScreenWidth?image.size.height/2:image.size.height) + [tipStr boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 15]} context:nil].size.height + (![btnTitle isUseableString]?30:80));
    self.center = CGPointMake(self.center.x, centerY);
}
- (void)masonryContentView:(UIImage *)image and:(NSString *)str and:(NSString *)btnTitle{
    self.bottomBtn.hidden = ![btnTitle isUseableString];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

#pragma mark - 懒加载
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = hexColor(333333);
        _tipLabel.font = [UIFont systemFontOfSize:15];
    }
    return _tipLabel;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = kMainColor;
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.layer.cornerRadius = 3.f;
        _bottomBtn.layer.masksToBounds = YES;
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
@end

//
//  PPPCIconTitleCell.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/20.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPPCIconTitleCell.h"
#import "UIFont+Adaptive.h"
@interface PPPCIconTitleCell()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleView;
@property (nonatomic,strong) UIImageView *rightIcon;
@property (nonatomic,strong) UIView *line;
@end
@implementation PPPCIconTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    [self addSubview:self.iconView];
    [self addSubview:self.titleView];
    [self addSubview:self.rightIcon];
    [self addSubview:self.line];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(AdaptW(25));
        make.centerY.equalTo(self).offset(0);
        make.width.mas_equalTo(AdaptW(22));
        make.height.mas_equalTo(AdaptW(22));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(13);
        make.centerY.equalTo(self).offset(0);
        make.height.mas_equalTo(AdaptW(13));
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptW(7));
        make.height.mas_equalTo(AdaptW(12));
        make.right.equalTo(self.mas_right).offset(-AdaptW(22));
        make.centerY.equalTo(self).offset(0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AdaptW(1));
        make.right.left.mas_equalTo(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImage:(NSString *)imgName title:(NSString *)title{
    self.iconView.image = ImageName(imgName);
    self.titleView.text = title;
}
#pragma mark - 懒加载
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}
-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.font = [UIFont systemFontOfSize:14];
        _titleView.textColor = hexColor(2B2B2B);
        _titleView.textAlignment = NSTextAlignmentLeft;
    }
    return _titleView;
}
-(UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
        _rightIcon.image = ImageName(@"icon_rightArrow");
    }
    return _rightIcon;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line;
}
@end

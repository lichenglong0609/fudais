//
//  PPVersionInfoCell.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPVersionInfoCell.h"
@interface PPVersionInfoCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *versionNumLabel;
@end
@implementation PPVersionInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.versionNumLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.centerY.mas_equalTo(0);
    }];
    [self.versionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-26);
        make.centerY.mas_equalTo(0);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"版本信息";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = hexColor(2b2b2b);
    }
    return _titleLabel;
}
-(UILabel *)versionNumLabel{
    if (!_versionNumLabel) {
        _versionNumLabel = [[UILabel alloc] init];
        NSString *nowVer = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        _versionNumLabel.text = [NSString stringWithFormat:@"v%@",nowVer];
        _versionNumLabel.font = [UIFont systemFontOfSize:13];
        _versionNumLabel.textColor = hexColor(818181);
    }
    return _versionNumLabel;
}
@end

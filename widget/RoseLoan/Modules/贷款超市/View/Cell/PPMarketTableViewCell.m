//
//  PPMarketTableViewCell.m
//  PostProduct
//
//  Created by 尚宇 on 2018/8/20.
//  Copyright © 2018年 cython. All rights reserved.
//

#import "PPMarketTableViewCell.h"
#import <UIButton+AFNetworking.h>
#import "PPADModel.h"

@interface PPMarketTableViewCell()

@property (nonatomic,strong) UIImageView *typeButton;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *numLabel;

@property (nonatomic,strong) UILabel *rangeLabel;

@property (nonatomic,strong) UIButton *applyButton;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *rateLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation PPMarketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _typeButton = [[UIImageView alloc] init];
        _typeButton.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:_typeButton];
        [_typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(AdaptW(24));
            make.top.equalTo(self).offset(AdaptW(7));
            make.size.mas_equalTo(CGSizeMake(AdaptW(30),AdaptW(30)));
            
        }];
        
        _nameLabel = [UITool initLabelWithTitle:@"借呗1" forFont:15 withTextColor:hexColor(2B2B2B)];
        _nameLabel.font = FontPingFangSCMedium(15);
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeButton.mas_right).offset(9);
            make.centerY.equalTo(_typeButton).offset(0);
        }];
        
        _numLabel = [UITool initLabelWithTitle:@"已有1234人申请" forFont:12.f withTextColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentRight];
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-AdaptW(23));
            make.centerY.equalTo(self.nameLabel.mas_centerY).offset(AdaptW(0));
//            make.height.mas_equalTo(16);
//            make.centerY.equalTo(_typeButton);
        }];
        
        _rangeLabel = [UITool initLabelWithTitle:@"500~20000" forFont:18.f withTextColor:UIColorFromRGB(0xFB6F66)];
        [self addSubview:_rangeLabel];
        [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeButton);
            make.top.equalTo(_typeButton.mas_bottom).offset(AdaptW(12));
            make.height.mas_equalTo(18);
        }];
        _timeLabel = [UITool initLabelWithTitle:@"最快5秒审批" forFont:14.f withTextColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(120);
            make.centerY.equalTo(_rangeLabel.mas_centerY).offset(0);
            make.centerX.equalTo(self);
        }];

        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.layer.cornerRadius = AdaptW(28)/2;
        _applyButton.layer.backgroundColor = RGBACOLOR(251, 111, 102, 1).CGColor;
        [_applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
        [_applyButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
        [_applyButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [self addSubview:_applyButton];
        [_applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_numLabel.mas_right).offset(0);
            make.top.equalTo(_numLabel.mas_bottom).offset(PPIWIDTHORHEIGHT(54));
            make.size.mas_equalTo(CGSizeMake(AdaptW(82), AdaptW(28)));
        }];
        UILabel *limitLabel = [UITool initLabelWithTitle:@"额度范围（元）" forFont:12 withTextColor:UIColorFromRGB(0x999999)];
        [self addSubview:limitLabel];
        [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rangeLabel);
            make.top.equalTo(_rangeLabel.mas_bottom).offset(AdaptW(7));
        }];
        

        _rateLabel = [UITool initLabelWithTitle:@"月利率0.23%" forFont:12 withTextColor:UIColorFromRGB(0x999999)];
        [self addSubview:_rateLabel];
        [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_timeLabel);
            make.top.equalTo(_timeLabel.mas_bottom).offset(AdaptW(7));
        }];

        _contentLabel = [UITool initLabelWithTitle:@"2万额度，3秒到账" forFont:12 withTextColor:UIColorFromRGB(0x999999)];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rangeLabel);
            make.top.equalTo(_rateLabel.mas_bottom).offset(AdaptW(15));
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@1);
            make.left.equalTo(@0);
        }];
    }
    
    return self;
}

- (void)setModel:(PPADModel *)model{
    _model = model;
//    [_typeButton sd_setImageWithURL:[NSURL URLWithString:_model.logo]];
    
    [_typeButton sd_setImageWithURL:[NSURL URLWithString:URLImage(self.model.logo)] placeholderImage:ImageName(@"placeholderIcon")];
    _contentLabel.text = _model.applicationDesc;
    _numLabel.text = [NSString stringWithFormat:@"%.1f万人已申请成功",(float)_model.applicationNumber/10000];
    _rateLabel.text = [NSString stringWithFormat:@"月利率%@",_model.interestRate];
    _rangeLabel.text = _model.quota;
    _nameLabel.text = _model.name;
    _timeLabel.text = model.approvalDesc;
}

- (void)apply:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didClickButtonTableViewCell:)]) {
        [self.delegate didClickButtonTableViewCell:self];
    }else{
        NSLog(@"-------delegate----------");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

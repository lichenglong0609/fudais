//
//  PPUsInfoCell.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPUsInfoCell.h"
@interface PPUsInfoCell()
@property (nonatomic,strong) UIImageView *appIcon;
@property (nonatomic,strong) UILabel *descLabel;
@end
@implementation PPUsInfoCell

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
    [self addSubview:self.appIcon];
    [self addSubview:self.descLabel];
    
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AdaptW(88));
        make.top.mas_equalTo(AdaptW(39));
        make.centerX.mas_equalTo(0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIcon.mas_bottom).offset(AdaptW(28));
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(AdaptW(325));
    }];
}

#pragma mark - 懒加载
-(UIImageView *)appIcon{
    if (!_appIcon) {
        _appIcon = [[UIImageView alloc] initWithImage:ImageName(@"icon_app")];
    }
    return _appIcon;
}
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = hexColor(818181);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
        _descLabel.font = FontPingFangSCRegular(14);

        [self setLineSpace:2.0 withText:@"    驿站钱包是领先的网络借贷服务第三方门户平台，致力于为合作网络借贷服务机构提供网贷平台推广、借款用户推介等服务，以通过数学模型配比和网络技术帮助合作网贷平台寻求更优质精准的资产端目标人群。" inLabel:_descLabel];
    }
    return _descLabel;
}

/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}
@end

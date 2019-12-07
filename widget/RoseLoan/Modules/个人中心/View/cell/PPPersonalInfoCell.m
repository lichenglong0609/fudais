//
//  PPPersonalInfoCell.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPPersonalInfoCell.h"
#import "PPUserModel.h"
#import "UIFont+Adaptive.h"
@interface PPPersonalInfoCell()
@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIButton *signOutBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@end
@implementation PPPersonalInfoCell

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
        if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId.length > 0) {
            self.signOutBtn.hidden = NO;
        }else{
            self.signOutBtn.hidden = YES;
        }
    }
    return self;
}

-(void)setUpUI{
    [self addSubview:self.avatarView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.signOutBtn];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AdaptW(64));
        make.width.mas_equalTo(AdaptW(64));
        make.top.equalTo(self.mas_top).offset(AdaptW(69));
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(AdaptW(18));
        make.height.mas_equalTo(AdaptW(14));
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
    [self.signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(AdaptW(37));
        make.right.equalTo(self.mas_right).offset(AdaptW(-24));
        make.height.mas_equalTo(AdaptW(14));
    }];
    
    [self addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top).offset(0);
        make.left.equalTo(self.avatarView.mas_left).offset(0);
        make.right.equalTo(self.avatarView.mas_right).offset(0);
        make.bottom.equalTo(self.userNameLabel.mas_bottom).offset(0);
    }];
    if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId.length >= 0) {
        self.loginBtn.hidden = YES;
    }else{
        self.loginBtn.hidden = NO;
    }
}
#pragma mark - 懒加载
-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:ImageName(@"icon_avatar")];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarView;
}
-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.font = FontPingFangSCMedium(15);
        _userNameLabel.textColor = hexColor(2b2b2b);
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.text = [PPUserModel sharedUser].userId.length>0 ? [PPUserModel sharedUser].userId : @"点击登录";
    }
    return _userNameLabel;
}
-(UIButton *)signOutBtn{
    if (!_signOutBtn) {
        _signOutBtn = [[UIButton alloc] init];
        [_signOutBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_signOutBtn setImage:[UIImage imageNamed:@"icon_signOut"] forState:UIControlStateNormal];
        _signOutBtn.titleLabel.font = FontPingFangSCMedium(14);
        [_signOutBtn setTitleColor:hexColor(4B4B4B) forState:UIControlStateNormal];
        _signOutBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-5 , 0, 5);
        [_signOutBtn addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutBtn;
}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn addTarget:self action:@selector(toLoginVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
-(void)toLoginVC:(UIButton *)btn{
    if (self.loginBlock) {
        self.loginBlock();
    }
}
-(void)signOut:(UIButton *)btn{
    if (self.signOutBlock) {
        self.signOutBlock();
    }
}
-(void)resetUserName{
    self.userNameLabel.text = [PPUserModel sharedUser].userLogin.length>0 ? [PPUserModel sharedUser].userLogin : @"点击登录";
    if ([PPUserModel sharedUser].userId != nil && [PPUserModel sharedUser].userId.length >= 0) {
        self.loginBtn.hidden = YES;
        self.signOutBtn.hidden = NO;
    }else{
        self.signOutBtn.hidden = YES;
        self.loginBtn.hidden = NO;
    }
}
@end

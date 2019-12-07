//
//  PPAmountHeaderView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPAmountHeaderView.h"
#import "UIView+LXShadowPath.h"
@interface PPAmountHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descWidth;
@property (weak, nonatomic) IBOutlet UIImageView *projectImg;

@end
@implementation PPAmountHeaderView
-(instancetype)loadFromNib{
    PPAmountHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [self addSubview:view];
    return view;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = AdaptW(40)/2;
    
    self.applyBtn.titleLabel.font = FontPingFangSCMedium(16);

    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=0; i<11; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animatedPicture%d",i+1]];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    self.bgImgView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    self.bgImgView.animationDuration = 35*0.06;
    //动画重复次数 （0为重复播放）
    self.bgImgView.animationRepeatCount = 0;
    //开始播放动画
    [self.bgImgView startAnimating];
    
    self.descriptionLabel.font = FontPingFangSCMedium(13);
    self.titleLabel.font = FontPingFangSCMedium(17);
    self.descriptionLabel.layer.masksToBounds = YES;
    self.descriptionLabel.layer.cornerRadius = AdaptW(5);
    
    self.projectImg.layer.masksToBounds = YES;
    self.projectImg.layer.cornerRadius = AdaptW(10);
    self.projectImg.layer.borderWidth = 1;
    self.projectImg.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)setData:(NSDictionary *)info{
    NSString *bgImgUrl = info[@"bgImgUrl"];
    if (bgImgUrl.length > 0) {
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:URLImage(bgImgUrl)] placeholderImage:[UIImage imageNamed:@"Home_top_bgImg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }else{
        self.bgImgView.image = ImageName(@"Home_top_bgImg");
    }
    self.descriptionLabel.text = info[@"description"];
    self.titleLabel.text = info[@"title"];
    [self.descriptionLabel sizeToFit];
    self.descWidth.constant = self.descriptionLabel.frame.size.width + 10;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AdaptW(50), AdaptW(50))];
    [imgView sd_setImageWithURL:[NSURL URLWithString:info[@"img"]] placeholderImage:ImageName(@"AppIcon") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error == nil) {
            self.projectImg.image = image;
        }else{
            self.projectImg.image = ImageName(@"AppIcon");
        }
    }];
}
/**
 * 金额的格式转化
 * str : 金额的字符串
 * numberStyle : 金额转换的格式
 * return  NSString : 转化后的金额格式字符串
 */
-(NSString *)stringChangeMoneyWithStr:(NSString *)str{
    
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    return money;
}
- (IBAction)wantToBorrow:(UIButton *)sender {
    if (self.toBorrowMoneyBlock) {
        self.toBorrowMoneyBlock();
    }
}
- (IBAction)clickProject:(id)sender {
    if (self.clickProjectBlock) {
        self.clickProjectBlock();
    }
}
@end

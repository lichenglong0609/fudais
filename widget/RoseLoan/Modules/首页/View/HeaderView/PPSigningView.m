//
//  PPSigningView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPSigningView.h"
@interface PPSigningView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,copy) NSDictionary *infoDic;
@end
@implementation PPSigningView

-(instancetype)loadFromNib{
    PPSigningView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [self addSubview:view];
    return view;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)toViewSigning:(UIButton *)sender {
    if (self.signingBlok) {
        NSString *url = self.infoDic[@"url"];
        self.signingBlok(url);
    }
}

-(void)setInfo:(NSDictionary *)info{
    self.infoDic = info;
    NSString *imgURL = info[@"imgUrl"];
    if (imgURL != nil && imgURL.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"Home_signing"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
}
@end

//
//  PPIntroductionHeaderView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPIntroductionHeaderView.h"
#import "UIView+LXShadowPath.h"
@interface PPIntroductionHeaderView()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
@implementation PPIntroductionHeaderView

-(instancetype)loadFromNib{
    PPIntroductionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [self addSubview:view];
    return view;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setData:(NSArray *)infos{
    if (infos.count > 0) {
        for (int i = 0; i<infos.count; i++) {
            NSDictionary *dic = infos[i];
            UIImageView *icon = (UIImageView *)[self viewWithTag:i*10+1];
            UILabel *title = (UILabel *)[self viewWithTag:i*10+2];
            UILabel *subtitle = (UILabel *)[self viewWithTag:i*10+3];
            [icon sd_setImageWithURL:[NSURL URLWithString:URLImage(dic[@"icon"])] placeholderImage:ImageName(@"icon_placeholderChart") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
            }];
            title.text = dic[@"title"];
            subtitle.text = dic[@"subtitle"];
        }
    }
}
@end

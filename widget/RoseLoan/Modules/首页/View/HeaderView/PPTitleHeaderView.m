//
//  PPTitleHeaderView.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/15.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPTitleHeaderView.h"

@interface PPTitleHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PPTitleHeaderView
-(instancetype)loadFromNib{
    PPTitleHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [self addSubview:view];
    return view;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font = FontPingFangSCSemibold(15);
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
@end

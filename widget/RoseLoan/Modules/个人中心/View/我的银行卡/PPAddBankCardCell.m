//
//  PPAddBankCardCell.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/20.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPAddBankCardCell.h"
@interface PPAddBankCardCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
@implementation PPAddBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

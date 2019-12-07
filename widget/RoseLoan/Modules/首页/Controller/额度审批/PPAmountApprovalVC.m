//
//  PPAmountApprovalVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPAmountApprovalVC.h"

@interface PPAmountApprovalVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation PPAmountApprovalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"额度审批";
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 20;
    
    self.bgImg.image = [self gradientImageWithColors:@[hexColor(FFFFFF),hexColor(F8F8F8)] rect:CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18*[UIScreen mainScreen].bounds.size.width/375];
    self.descLabel.font = FontPingFangSCRegular(14.5);
    self.btnHeight.constant = AdaptW(44);
    self.confirmBtn.titleLabel.font = FontPingFangSCMedium(16);
}
- (IBAction)toSuperMarket:(id)sender {
    PPTabBarController *tab = (PPTabBarController *)kWindow.rootViewController;
    tab.selectedIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 生成一张渐变色的图片
 @param colors 颜色数组
 @param rect 图片大小
 @return 返回渐变图片
 */
- (UIImage *)gradientImageWithColors:(NSArray *)colors rect:(CGRect)rect
{
    if (!colors.count || CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = rect;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    NSMutableArray *mutColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [mutColors addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = [NSArray arrayWithArray:mutColors];
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.opaque, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
@end

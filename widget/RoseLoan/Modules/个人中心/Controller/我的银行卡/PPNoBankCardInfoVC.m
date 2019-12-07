    //
//  PPNoBankCardInfoVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/21.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPNoBankCardInfoVC.h"
#import "PPCertificationVC.h"
@interface PPNoBankCardInfoVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation PPNoBankCardInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnHeight.constant = AdaptW(44);
    self.confirmBtn.titleLabel.font = FontPingFangSCMedium(16);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goToCertification:(id)sender {
    PPCertificationVC *verCon = [[PPCertificationVC alloc] init];
    [self.navigationController pushViewController:verCon animated:true];
}

@end

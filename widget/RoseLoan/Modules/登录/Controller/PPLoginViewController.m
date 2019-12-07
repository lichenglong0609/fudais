//
//  PPLoginViewController.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/19.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPAllRequestSharedData.h"
#import "WebViewController.h"
@interface PPLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifiCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifiCodeBtn;
@property (nonatomic,strong) NSString *validatecode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnHeight.constant = AdaptW(44);
    self.loginBtn.titleLabel.font = FontPingFangSCMedium(16);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)dismissVC:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**获取验证码*/
- (IBAction)getValidateCode:(UIButton *)sender{
    if (![_phoneTF.text validateMobile]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号" ];
        return;
    }
    [self.verifiCodeTF becomeFirstResponder];
    [self timeOut];
}
- (IBAction)showUserAgreement:(id)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.titleStr = @"驿站钱包用户协议";
    webVC.url = [NSString stringWithFormat:@"http://101.132.108.30/wallet/ZhuCeAgreement.html"];
    
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark 倒计时
-(void)timeOut {
    WEAKSELF
    [[PPAllRequestSharedData sharedData] requestMsgWithPhoneData:@{@"phone":_phoneTF.text} callBack:^(BOOL success, NSString *msg) {
        if (!success) {
            [SVProgressHUD showErrorWithStatus:msg];
        }else{
            weakSelf.validatecode = msg;
        }
    }];
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getVerifiCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                [_getVerifiCodeBtn setTitleColor:hexColor(FC7572) forState:UIControlStateNormal];
                _getVerifiCodeBtn.enabled = YES;
            });
            
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                _getVerifiCodeBtn.enabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_getVerifiCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [_getVerifiCodeBtn setTitleColor:hexColor(B8B8B8) forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)logIn:(UIButton *)sender{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"登录中..."];
    if ([_verifiCodeTF.text isEqualToString:_validatecode]) {
        [[PPAllRequestSharedData sharedData]requestLoginWithUserData:@{@"userLogin":_phoneTF.text} callBack:^(BOOL success, NSString *msg) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                NSString *pw = [[NSUserDefaults standardUserDefaults] objectForKey:@"gestureFinalSaveKey"];
                if (pw == nil || pw.length == 0) {
                    [self dismissViewControllerAnimated:true completion:nil];
                    if ([kWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
                        kWindow.rootViewController = [PPTabBarController shareInstance];
                    }
                }else{
                    [self dismissViewControllerAnimated:true completion:nil];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"登录失败,请稍后再试"];
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF) {
        int currentStrLength = (int)textField.text.length;
        int inputStrLength = (int)string.length;
        int completeStrLength = currentStrLength + inputStrLength;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (completeStrLength >= 11 && inputStrLength != 0) {
            self.phoneTF.text = [completeStr substringToIndex:11];
            return NO;
        }else{
            return YES;
        }
    }else{
        int currentStrLength = (int)textField.text.length;
        int inputStrLength = (int)string.length;
        int completeStrLength = currentStrLength + inputStrLength;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (completeStrLength >= 6 && inputStrLength != 0) {
            self.verifiCodeTF.text = [completeStr substringToIndex:6];
            return NO;
        }else{
            return YES;
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField != self.phoneTF) {
        [self.verifiCodeTF becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
@end

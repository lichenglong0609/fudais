//
//  PPCertificationVC.m
//  PostProduct
//
//  Created by 傲道 on 2019/3/29.
//  Copyright © 2019 cython. All rights reserved.
//

#import "PPCertificationVC.h"

#import "PPUserModel.h"
#import "NetworkSingleton.h"
#import "PPPersonalInfomationVC.h"
#import "PPCheckSign.h"
@interface PPCertificationVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardholderName;
@property (weak, nonatomic) IBOutlet UITextField *identityNum;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) NSMutableDictionary *paramDictionary;
@property (strong, nonatomic)  UIButton *newBtn;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *descLabel;
@end

@implementation PPCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"实名认证";
    [self setUpUI];

}
-(void)setUpUI{
    [self.view addSubview:self.newBtn];
    [self.newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptW(285));
        make.height.mas_equalTo(AdaptW(44));
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(self.bgView.mas_bottom).offset(38);
    }];
    
    [self.view addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newBtn.mas_left).offset(AdaptW(22));
        make.height.mas_equalTo(AdaptW(15));
        make.top.equalTo(self.newBtn.mas_bottom).offset(AdaptW(14));
    }];
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(3);
        make.centerY.equalTo(self.iconView.mas_centerY).offset(0);
        make.height.mas_equalTo(12);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)newPush {
    if (self.cardholderName.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }else if(self.identityNum.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号码"];
        return;
    }else if(self.bankCardNumber.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }else if(self.phoneNumber.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入银行预留手机号"];
        return;
    }

    [SVProgressHUD showWithStatus:@"实名认证中..."];
    NSString *verifyBankCardStr = [NSString stringWithFormat:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardBinCheck=true&cardNo=%@",self.bankCardNumber.text];
    __weak typeof(self) weakSelf = self;
    [[NetworkSingleton sharedManager] getData:nil url:verifyBankCardStr successBlock:^(NSDictionary *responseObject, NSInteger statusCode) {
        if(responseObject != nil){
            NSString *bankCardType = responseObject[@"cardType"];
            if (bankCardType == nil) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"银行卡错误请确认后重试"];
            }else if ([bankCardType isEqualToString:@"DC"]) {

                [weakSelf.paramDictionary setObject:strOrEmpty(self.cardholderName.text) forKey:@"name"];
                [weakSelf.paramDictionary setObject:strOrEmpty(self.phoneNumber.text) forKey:@"phoneNo"];
                [weakSelf.paramDictionary setObject:strOrEmpty(self.bankCardNumber.text) forKey:@"cardNo"];
                [weakSelf.paramDictionary setObject:strOrEmpty(self.identityNum.text) forKey:@"idNo"];
                [weakSelf.paramDictionary setObject:strOrEmpty([PPUserModel sharedUser].userId) forKey:@"userId"];

                [weakSelf requestUploadData];
            }else{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"仅支持储蓄卡进行实名认证"];
            }
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试"];
    }];
}
#pragma mark - 数据
- (void)requestUploadData{
    
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kNetBaseURL,KNetSaveInfo];
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSError *error;
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 10.0f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [session.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:self.paramDictionary error:&error];
    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [session POST:urlStr parameters:self.paramDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSDictionary *dict = (NSDictionary *)responseObject;    
            if ([dict[@"code"] intValue] == 200) {
                [SVProgressHUD showSuccessWithStatus:@"认证成功"];
                PPPersonalInfomationVC *personInfo = [[PPPersonalInfomationVC alloc] init];
                [weakSelf.navigationController pushViewController:personInfo animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dict[@"msg"]];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMsg = error.userInfo[@"NSLocalizedDescription"];
        NSString *msgStr = @"";
        if ([errorMsg isEqualToString:@"The request timed out."]) {
            msgStr = @"访问超时！";
        }else{
            msgStr = @"网络异常请稍后重试";
        }
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:msgStr];
    }];
}
#pragma mark - 懒加载
-(UIButton *)newBtn{
    if (!_newBtn) {
        _newBtn = [[UIButton alloc] init];
        [_newBtn setBackgroundImage:ImageName(@"login_btn_bgImg") forState:UIControlStateNormal];
        [_newBtn setTitle:@"确定" forState:UIControlStateNormal];
        _newBtn.titleLabel.font = FontPingFangSCMedium(16);
        [_newBtn addTarget:self action:@selector(newPush) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newBtn;
}
-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:ImageName(@"icon_Safety")];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"驿站钱包智能加密，实时保障您的信息安全";
        _descLabel.textColor = hexColor(818181);
        _descLabel.font = FontPingFangSCRegular(10);
    }
    return _descLabel;
}
-(NSMutableDictionary *)paramDictionary{
    if (!_paramDictionary) {
        _paramDictionary = [[NSMutableDictionary alloc] init];
    }
    return _paramDictionary;
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneNumber) {
        int currentStrLength = (int)textField.text.length;
        int inputStrLength = (int)string.length;
        int completeStrLength = currentStrLength + inputStrLength;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (completeStrLength >= 11 && inputStrLength != 0) {
            self.phoneNumber.text = [completeStr substringToIndex:11];
            return NO;
        }else{
            return YES;
        }
    }else if(textField == self.bankCardNumber){
        int currentStrLength = (int)textField.text.length;
        int inputStrLength = (int)string.length;
        int completeStrLength = currentStrLength + inputStrLength;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (completeStrLength >= 20 && inputStrLength != 0) {
            self.bankCardNumber.text = [completeStr substringToIndex:20];
            return NO;
        }else{
            if ([string isEqualToString:@""] && range.length == 1) {
                self.bankCardNumber.text = [completeStr substringToIndex:(completeStrLength-1)];
                return NO;
            }else{
                self.bankCardNumber.text = completeStr;
                return NO;
            }
        }
    }else if(textField == self.identityNum){
        int currentStrLength = (int)textField.text.length;
        int inputStrLength = (int)string.length;
        int completeStrLength = currentStrLength + inputStrLength;
        NSString *completeStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (completeStrLength >= 18 && inputStrLength != 0) {
            self.identityNum.text = [completeStr substringToIndex:18];
            return NO;
        }else{
            if ([string isEqualToString:@""] && range.length == 1) {
                self.identityNum.text = [completeStr substringToIndex:(completeStrLength-1)];
                return NO;
            }else{
                self.identityNum.text = completeStr;
                return NO;
            }
        }
    }else{
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField != self.cardholderName) {
        int tag = (int)textField.tag;
        tag += 1;
        UITextField *tf = [self.view viewWithTag:tag];
        [tf becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
@end

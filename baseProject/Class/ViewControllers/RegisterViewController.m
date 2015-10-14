//
//  RegisterViewController.m
//  baseProject
//
//  Created by Li on 15/1/2.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
    int _totalTime0;
    NSTimer *_timer0;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    
    _totalTime0 = 180;
    _timer0 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time0Go) userInfo:nil repeats:YES];
    [_timer0 setFireDate:[NSDate distantFuture]];

}

- (void)viewDidDisappear:(BOOL)animated {
    if (_timer0) {
        [_timer0 invalidate];
        _timer0 = nil;
    }
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)time0Go {
    if (_totalTime0 <= 0) {
        _reCodeBtn.userInteractionEnabled = YES;
        [_reCodeBtn setTitle:[NSString stringWithFormat:@"重发验证码"] forState:UIControlStateNormal];
        [_timer0 setFireDate:[NSDate distantFuture]];
    }
    else {
        _reCodeBtn.userInteractionEnabled = NO;
        [_reCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后失效", _totalTime0] forState:UIControlStateNormal];
        _totalTime0 --;
    }
}

- (IBAction)code0BtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneTextField.text isVAlidPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }

    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_phoneTextField.text forKey:@"phone"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:[NSString stringWithFormat:@"%@/other/get-reg-phone-code", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            _totalTime0 = 179;
            [_timer0 setFireDate:[NSDate distantPast]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (IBAction)registerBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneTextField.text isVAlidPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
    else if (!_codeTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }
    else if (!_pwdTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
    }
    else {
        [self postData];
    }
}

- (void)postData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_phoneTextField.text forKey:@"phone"];
    [dic setObject:[shareFun md5:_pwdTextField.text] forKey:@"password"];
    [dic setObject:_codeTextField.text forKey:@"code"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/register", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [PublicInstance instance].userLoginName = _phoneTextField.text;

            [self backAction];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

@end

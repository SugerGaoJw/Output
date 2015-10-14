//
//  BingPhoneViewController.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "BingPhoneViewController.h"

@interface BingPhoneViewController () {
    int _totalTime0;
    NSTimer *_timer0;
}

@end

@implementation BingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绑定手机";
    
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
        _timerBtn.userInteractionEnabled = YES;
        [_timerBtn setTitle:[NSString stringWithFormat:@"重发验证码"] forState:UIControlStateNormal];
        [_timer0 setFireDate:[NSDate distantFuture]];
    }
    else {
        _timerBtn.userInteractionEnabled = NO;
        [_timerBtn setTitle:[NSString stringWithFormat:@"%d秒后失效", _totalTime0] forState:UIControlStateNormal];
        _totalTime0 --;
    }
}

- (IBAction)code0BtnClick:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:[NSString stringWithFormat:@"%@/other/get-reg-phone-code", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (IBAction)topBtnClick:(UIButton *)sender {
    if (sender.tag == 0) {
        if (sender.selected == YES) {
            return;
        }
        else {
            sender.selected = YES;
            _rightBtn.selected = NO;
            _leftView.hidden = NO;
            _rightView.hidden = YES;
        }
    }
    else if (sender.tag == 1) {
        if (sender.selected == YES) {
            return;
        }
        else {
            sender.selected = YES;
            _leftBtn.selected = NO;
            _leftView.hidden = YES;
            _rightView.hidden = NO;
        }
    }
}

- (IBAction)bingBtnClick:(id)sender {
    if (_leftBtn.selected) {
        if (!_newPhoneTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return;
        }
        if (!_newCodeTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        if (!_newPsdTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        [self postData];
    }
    else if (_rightBtn.selected) {
        if (!_oldPhoneTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return;
        }
        if (!_oldCodeTextField.text.length) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        [self getData];
    }
}

- (void)getData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[_dataDic uid] forKey:@"openId"];
    if ([_dataDic type] == ShareTypeWeixiSession) {
        [dic setObject:@"wx" forKey:@"type"];
    }
    else if ([_dataDic type] == ShareTypeQQSpace){
        [dic setObject:@"qq" forKey:@"type"];
    }
    if (_leftBtn.selected) {
        [dic setObject:_newPhoneTextField.text forKey:@"phone"];
        [dic setObject:[shareFun md5:_newPsdTextField.text] forKey:@"password"];
    }
    else {
        [dic setObject:_oldPhoneTextField.text forKey:@"phone"];
        [dic setObject:[shareFun md5:_oldCodeTextField.text] forKey:@"password"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/binding", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [PublicInstance instance].isLogin = YES;
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

//注册
- (void)postData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_newPhoneTextField.text forKey:@"phone"];
    [dic setObject:[shareFun md5:_newPsdTextField.text] forKey:@"password"];
    [dic setObject:_newCodeTextField.text forKey:@"code"];
    
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
            [self getData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

@end

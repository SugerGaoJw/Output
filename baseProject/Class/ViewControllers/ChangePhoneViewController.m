//
//  ChangePhoneViewController.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController () {
    int _totalTime0;
    NSTimer *_timer0;

    int _totalTime1;
    NSTimer *_timer1;

}

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改手机号";
    
    _totalTime0 = 180;
    _timer0 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time0Go) userInfo:nil repeats:YES];
    [_timer0 setFireDate:[NSDate distantFuture]];
    
    _totalTime1 = 180;
    _timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time1Go) userInfo:nil repeats:YES];
    [_timer1 setFireDate:[NSDate distantFuture]];

    [self code0BtnClick:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_timer0) {
        [_timer0 invalidate];
        _timer0 = nil;
    }
    if (_timer1) {
        [_timer1 invalidate];
        _timer1 = nil;
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
        _code0Btn.userInteractionEnabled = YES;
        [_code0Btn setTitle:[NSString stringWithFormat:@"重发验证码"] forState:UIControlStateNormal];
        [_timer0 setFireDate:[NSDate distantFuture]];
    }
    else {
        _code0Btn.userInteractionEnabled = NO;
        [_code0Btn setTitle:[NSString stringWithFormat:@"%d秒后失效", _totalTime0] forState:UIControlStateNormal];
        _totalTime0 --;
    }
}

- (void)time1Go {
    if (_totalTime1 <= 0) {
        _code1Btn.userInteractionEnabled = YES;
        [_code1Btn setTitle:[NSString stringWithFormat:@"重发验证码"] forState:UIControlStateNormal];
        [_timer1 setFireDate:[NSDate distantFuture]];
    }
    else {
        _code1Btn.userInteractionEnabled = NO;
        [_code1Btn setTitle:[NSString stringWithFormat:@"%d秒后失效", _totalTime1] forState:UIControlStateNormal];
        _totalTime1 --;
    }
}

- (IBAction)code0BtnClick:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:[NSString stringWithFormat:@"%@/other/get-modify-phone-code", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (IBAction)code1BtnClick:(id)sender {
    if (![_telTextField.text isVAlidPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号有误"];
        return;
    }
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_telTextField.text forKey:@"phone"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:[NSString stringWithFormat:@"%@/other/get-modify-new-phone-code", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            _totalTime1 = 179;
            [_timer1 setFireDate:[NSDate distantPast]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (IBAction)bingBtnClick:(id)sender {
    if (!_code0TextField.text.length || !_code1TextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (!_telTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    [self getData];
}

- (void)getData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_telTextField.text forKey:@"newPhone"];
    [dic setObject:_code0TextField.text forKey:@"code"];
    [dic setObject:_code1TextField.text forKey:@"newCode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/modify-phone", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self backAction];
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
//            double delayInSeconds = 1.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                
//            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

@end

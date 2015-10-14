//
//  ChangePwdViewController.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_paymentPwd) {
        self.title= @"修改支付密码";
    }
    else
        self.title = @"修改密码";
    
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
- (IBAction)saveBtnClick:(id)sender {
    if (!_newPwdTextField.text || !_oldPwdTextField.text) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
    }
    else if (![_newPwdTextField.text isEqualToString:_newPwd1TextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码不一致"];
    }
    else {
        NSMutableDictionary *dic = [self creatRequestDic];
        
        NSString *url;
        if (_paymentPwd) {
            url = @"/member/update-payment-pwd";
            
            [dic setObject:[shareFun md5:_newPwd1TextField.text] forKey:@"newPaymentPassword"];
            [dic setObject:[shareFun md5:_oldPwdTextField.text] forKey:@"oldPaymentPassword"];
        }
        else {
            url = @"/member/update-pwd";
            
            [dic setObject:[shareFun md5:_newPwd1TextField.text] forKey:@"newPassword"];
            [dic setObject:[shareFun md5:_oldPwdTextField.text] forKey:@"oldPassword"];
        }
        
        url = [NSString stringWithFormat:@"%@%@", kSERVE_URL, url];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                [PublicInstance instance].userPwd = _newPwd1TextField.text;
                
                [self backAction];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
}

@end

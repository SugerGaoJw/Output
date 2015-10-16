//
//  LoginViewController.m
//  baseProject
//
//  Created by Li on 14/12/30.
//  Copyright (c) 2014年 Li. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "BingPhoneViewController.h"
#import "shareFun.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"登录";
    [self setLBtn:@"返回" image:nil imageSel:nil target:self action:@selector(leftBtnClick)];
    [self setRBtn:@"注册" image:nil imageSel:nil target:self action:@selector(rightBtnClick)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _phoneTextField.text = [PublicInstance instance].userLoginName;
    
#if DEBUG_ENVIRONMENT
    _phoneTextField.text = @"15980538648";
    _pwdTextField.text = @"123456";
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtnClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightBtnClick {
    RegisterViewController *vc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)postData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_phoneTextField.text forKey:@"phone"];
    [dic setObject:[shareFun md5:_pwdTextField.text] forKey:@"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/session/login", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [PublicInstance instance].isLogin = YES;
            [PublicInstance instance].userLoginName = _phoneTextField.text;

            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (IBAction)loginBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneTextField.text isVAlidPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
    else if (!_pwdTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
    }
    else {
        [self postData];
    }
}

- (IBAction)getCodeBtnClick:(id)sender {
}

- (IBAction)qqLoginBtnClick:(id)sender {
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    }
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   [self getUserInfo:userInfo];
                               }
                               else {
                                   [shareFun showAlert:error.errorDescription];
                                   
                               }
                           }];
}

- (IBAction)weChatBtnClick:(id)sender {
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    }
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result) {
                                   [self getUserInfo:userInfo];
                               }
                               else {
                                   [shareFun showAlert:error.errorDescription];
                               }
                           }];
}

- (void)getUserInfo:(id<ISSPlatformUser>)userInfo {
    NSMutableDictionary *dic = [self creatRequestDic];
    if ([userInfo type] == ShareTypeWeixiSession) {
        [dic setObject:@"wx" forKey:@"type"];
    }
    else if ([userInfo type] == ShareTypeQQSpace){
        [dic setObject:@"qq" forKey:@"type"];
    }

    [dic setObject:[userInfo uid] forKey:@"openId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/session/login", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] == 98) {
            BingPhoneViewController *vc = [[BingPhoneViewController alloc] initWithNibName:@"BingPhoneViewController" bundle:nil];
            vc.dataDic = userInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [PublicInstance instance].isLogin = YES;
            [PublicInstance instance].userLoginName = _phoneTextField.text;

            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    if ([userInfo type] == ShareTypeSinaWeibo) {
//        [t_dic setObject:@"weibo" forKey:@"type"];
//    }
//    else if ([userInfo type] == ShareTypeQQSpace){
//        [t_dic setObject:@"qq" forKey:@"type"];
//    }
//    else {
//        [t_dic setObject:@"wechat" forKey:@"type"];
//    }
//    [t_dic setObject:[userInfo uid] forKey:@"openid"];
//    [t_dic setObject:[userInfo nickname] forKey:@"nick"];
//    [t_dic setObject:[userInfo profileImage] forKey:@"avatar"];
//    
//    [[NetworkMgr sharedInstance] Post:[NSString stringWithFormat:@"%@%@", SERVE_URL, @"/api.php?m=user&c=login3&p="] param:t_dic observer:self flag:@"200" cache:NO];
}

@end

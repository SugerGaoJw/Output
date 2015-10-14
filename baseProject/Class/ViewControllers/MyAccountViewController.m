//
//  MyAccountViewController.m
//  baseProject
//
//  Created by Li on 15/1/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyAccountViewController.h"
#import "ChangePwdViewController.h"
#import "ChangePhoneViewController.h"
#import "MyAddrViewController.h"

@interface MyAccountViewController () {
    NSArray *_titleArr;
}

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的账户";

    _titleArr = @[@[@"送餐地址", @"修改密码", @"修改手机号", @"修改支付密码"], @[@"退出当前帐号"]];
    
    _tableView.sectionFooterHeight = 1.0;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_titleArr count];
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (sec == 0) {
        if (row == 0) {
            MyAddrViewController *vc = [[MyAddrViewController alloc] initWithNibName:@"MyAddrViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 1) {
            ChangePwdViewController *vc = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 2) {
            ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] initWithNibName:@"ChangePhoneViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 3) {
            ChangePwdViewController *vc = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
            vc.paymentPwd = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else {
        [self exit];
    }
}

- (void)exit {
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/session/logout", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [SVProgressHUD dismiss];
            [PublicInstance instance].isLogin = NO;
            [self backAction];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

@end

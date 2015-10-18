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
#import "ChargeViewController.h"
#import "PointViewController.h"

//action
#define KSendAddress @"送餐地址"
#define KModifiedPwd @"修改密码"
#define KSignOut @"退出当前帐号"

//label
#define KAmountNo @"当前帐号"
#define KBanlance @"账户余额"
#define KIntegral @"积分明细"

@interface MyAccountViewController () {
    NSArray *_titleArr;
}

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的账户";
    
    //    _titleArr = @[@[@"送餐地址", @"修改密码", @"修改手机号", @"修改支付密码"], @[@"退出当前帐号"]];
    
    
    _titleArr = @[@[KAmountNo],
                  @[KBanlance,KIntegral,KSendAddress, KModifiedPwd],
                  @[KSignOut]];
    
    _tableView.sectionFooterHeight = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - static label
//处理 cell right label
- (void)handlerLabelAtIndexPath:(NSIndexPath *)indexPath
                  WithSuperView:(UIView *)superView {
    
    NSString* title = _titleArr[indexPath.section][indexPath.row];
    
    UILabel* label = nil;
    if ([title isEqualToString:KAmountNo]){ //当前账户
        label =  [self ptdLabelAddSuperView:superView];
        label.text = self.amountNo;
        label.textColor = [UIColor lightGrayColor];
        
    }else if ([title isEqualToString:KBanlance]){ //账户余额
        label =  [self ptdLabelAddSuperView:superView];
        label.text = [NSString stringWithFormat:@"%@ 元",self.balance];
        label.textColor = [UIColor redColor];
        [self modifiedframe:label WithHorizontal:-10];
        
    }else if ([title isEqualToString:KIntegral]) {  //积分明细
        label =  [self ptdLabelAddSuperView:superView];
        label.text = [NSString stringWithFormat:@"%@ 分",self.integral];
        label.textColor = [UIColor redColor];
        [self modifiedframe:label WithHorizontal:-10];
    }
}

- (UILabel *)ptdLabelAddSuperView:(UIView *)superView {
    CGFloat w = 120;
    CGRect rect = CGRectMake(__MainScreen_Width - w - 20 , 12.5f, w, 20);
    
    UILabel* lbl = [[UILabel alloc]initWithFrame:rect];
//    lbl.backgroundColor = [UIColor redColor];
    lbl.textAlignment = NSTextAlignmentRight;
    [superView addSubview:lbl];
    return lbl;
}

- (void)modifiedframe:(UILabel *)label WithHorizontal:(CGFloat)h {
    
    CGRect rct = label.frame;
    CGRect newRct = CGRectMake(rct.origin.x + h,
                               rct.origin.y, CGRectGetWidth(rct),
                               CGRectGetHeight(rct));
    label.frame = newRct;
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

    NSString* title = _titleArr[indexPath.section][indexPath.row];
    
    // cell UITableViewCellAccessoryDisclosureIndicator
    if ([title isEqualToString:KModifiedPwd]
        ||[title isEqualToString:KSendAddress]
        ||[title isEqualToString:KModifiedPwd]
        ||[title isEqualToString:KBanlance]
        ||[title isEqualToString:KIntegral]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //text color
    if ([title isEqualToString:KSignOut]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.text = title;
    
    [self handlerLabelAtIndexPath:indexPath WithSuperView:cell.contentView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* title = _titleArr[indexPath.section][indexPath.row];
    
    if ([title isEqualToString:KSendAddress]) { //送餐地址
        MyAddrViewController *vc = [[MyAddrViewController alloc] initWithNibName:@"MyAddrViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if ([title isEqualToString:KModifiedPwd]) { //修改密码
        ChangePwdViewController *vc = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([title isEqualToString:KBanlance]) { //充值界面
        
        ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if ([title isEqualToString:KIntegral] ) { //积分
        PointViewController *vc = [[PointViewController alloc] initWithNibName:@"PointViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([title isEqualToString:KSignOut]) { //退出当前账户
        [self exit];
    }
    
    /*
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
    }*/
    
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

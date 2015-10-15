//
//  FourthViewController.m
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "FourthViewController.h"
#import "MyAccountViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "MeshPointInquiryViewController.h"
#import "MessageViewController.h"
#import "MyCouponViewController.h"
#import "MyBillViewController.h"
#import "LoginViewController.h"
#import "ChargeViewController.h"
#import "PointViewController.h"
#import "PresentOrderViewController.h"
#import "MyAddrViewController.h"

@interface FourthViewController () {
    NSArray *_imgArr;
    NSArray *_titleArr;
    NSString *_balance;
    NSString *_integral;
}

@end

@implementation FourthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的";
        [self setLBtn:nil image:@"nav_chat.png" imageSel:nil target:self action:@selector(rightBtnClick)];
        [self setRBtn:nil image:@"设置.png" imageSel:nil target:self action:@selector(leftBtnClick)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _titleArr = @[@[@"我的优惠券", @"我的积分", @"账户充值"], @[@"关于食卜", @"食卜客服中心"]];
    _imgArr = @[@[@"08_1-个人中心_优惠券.png", @"08_1-个人中心_我的积分.png", @"08_1-个人中心_账户充值.png"], @[@"08_1-个人中心——关于京元.png", @"08_1-个人中心_京元客服中心.png"]];
    
    _tableView.tableHeaderView = _headerView;
    _tableView.sectionFooterHeight = 1.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PublicInstance instance].isLogin) {
        [self getUserInfo];
        _userDetailBtn.hidden = NO;
        _topLine.hidden = NO;
        _userAddBtn.hidden = NO;
        _userNameLbl.hidden = NO;
        _loginBtn.hidden = YES;
    }
    else {
        _userDetailBtn.hidden = YES;
        _userNameLbl.hidden = YES;
        _topLine.hidden = YES;
        _userAddBtn.hidden = YES;
        _loginBtn.hidden = NO;
    }
}

- (void)leftBtnClick {
    if (![PublicInstance instance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
        return;
    }
    MyAccountViewController *vc = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtnClick {
    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginBtnClick:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)addBtnClick:(id)sender {
    MyAddrViewController *vc = [[MyAddrViewController alloc] initWithNibName:@"MyAddrViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myAccountBtnClick:(id)sender {
    SettingViewController *vc = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goingOrderBtnClick:(id)sender {
    if (![PublicInstance instance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
        return;
    }
    self.tabBarController.selectedIndex = 1;
}
- (IBAction)prsentBtnClick:(id)sender {
    if (![PublicInstance instance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
        return;
    }
    PresentOrderViewController *vc = [[PresentOrderViewController alloc] initWithNibName:@"PresentOrderViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myBillBtnClick:(id)sender {
    if (![PublicInstance instance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
        return;
    }
    MyBillViewController *vc = [[MyBillViewController alloc] initWithNibName:@"MyBillViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *decLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 120, 44)];
        decLbl.font = [UIFont systemFontOfSize:14];
        decLbl.textAlignment = NSTextAlignmentRight;
        decLbl.textColor = [UIColor orangeColor];
        decLbl.tag = 1000;
        decLbl.hidden = YES;
        [cell.contentView addSubview:decLbl];
    }
    UILabel *decLbl = (UILabel *)[cell.contentView viewWithTag:1000];
    if (indexPath.row == 1 && indexPath.section == 0) {
        decLbl.hidden = NO;
        decLbl.text = _integral;
    }
    else if (indexPath.row == 2 && indexPath.section == 0) {
        decLbl.hidden = NO;
        decLbl.text = _balance;
    }
    else {
        decLbl.hidden = YES;
    }
    
    cell.imageView.image = [UIImage imageNamed:_imgArr[indexPath.section][indexPath.row]];
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (sec == 0) {
        if (![PublicInstance instance].isLogin) {
            [SVProgressHUD showErrorWithStatus:@"请先登陆"];
            return;
        }
        if (row == 0) {
            MyCouponViewController *vc = [[MyCouponViewController alloc] initWithNibName:@"MyCouponViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 1) {
            PointViewController *vc = [[PointViewController alloc] initWithNibName:@"PointViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 2) {
            ChargeViewController *vc = [[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (sec == 1) {
        if (row == 0) {
            AboutViewController *vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 2) {
            MeshPointInquiryViewController *vc = [[MeshPointInquiryViewController alloc] initWithNibName:@"MeshPointInquiryViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (row == 1) {
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", @"059187880881"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

- (void)getUserInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/info", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    NSString *balance = [[dic objectForKey:@"data"] objectForKey:@"balance"];
    NSString *integral = [[dic objectForKey:@"data"] objectForKey:@"integral"];
    NSString *phone = [[dic objectForKey:@"data"] objectForKey:@"address"];
    
    _balance = [NSString stringWithFormat:@"￥%@", balance];
    _integral = [NSString stringWithFormat:@"%@", integral];
    
    _userNameLbl.text = [NSString stringWithFormat:@"%@", phone];
    [_tableView reloadData];
}


@end

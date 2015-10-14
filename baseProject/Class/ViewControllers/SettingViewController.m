//
//  SettingViewController.m
//  baseProject
//
//  Created by Li on 15/1/8.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import "MobClick.h"

@interface SettingViewController () {
    NSArray *_titleArr;
    NSString *_url;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"设置";

    _titleArr = @[@[@"意见反馈", @"分享"], @[@"版本更新"]];
    
    _tableView.sectionFooterHeight = 1.0;
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
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 190, 44)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = [NSString stringWithFormat:@"当前版本:%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        lbl.tag = 1;
        lbl.hidden = YES;
        lbl.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbl];
    }
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
//
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:1];
    if (indexPath.section == 1) {
        lbl.hidden = NO;
    }
    else {
        lbl.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (sec == 1) {
        [self checkUpdate];
    }
    else if (sec == 0) {
        if (row == 1) {
            NSString *message = @"分享";
            NSArray *arrayOfActivityItems = [NSArray arrayWithObjects:message, nil];
            
            // 显示view controller
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems: arrayOfActivityItems applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:Nil];
        }
        else {
            FeedBackViewController *vc = [[FeedBackViewController alloc] initWithNibName:@"FeedBackViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)checkUpdate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/app-ios-version/version", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [SVProgressHUD showErrorWithStatus:@"获取版本信息失败"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    NSDictionary *versionDic = [dic objectForKey:@"version"];
    NSString *iosVersion = versionDic[@"iosVersion"];
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSComparisonResult result = [iosVersion compare:localVersion];
    if (result == NSOrderedDescending) {
        _url = versionDic[@"iosUrl"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新版本，是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [alertView show];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:@"已经是最新版本了"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

@end

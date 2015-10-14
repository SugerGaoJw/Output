//
//  NewAreaViewController.m
//  baseProject
//
//  Created by Li on 15/3/17.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "NewAreaViewController.h"

@interface NewAreaViewController ()

@end

@implementation NewAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.tableFooterView = [UIView new];
    [self getData];
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
- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if ([self.title isEqualToString:@"选择街道"]) {
        cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else {
        cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.title isEqualToString:@"选择地区"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.dataSource objectAtIndex:indexPath.row]];
        if (_fromFirstPage) {
            [dic setObject:[NSString stringWithFormat:@"%@-%@", _parentName, [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"]] forKey:@"parentName"];
        }
        else {
            [dic setObject:[NSString stringWithFormat:@"%@%@", _parentName, [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"]] forKey:@"parentName"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"areaSelcet" object:nil userInfo:dic];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 4] animated:YES];
    }
    else if ([self.title isEqualToString:@"选择街道"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roadSelcet" object:nil userInfo:[self.dataSource objectAtIndex:indexPath.row]];
        [self backAction];
    }
    else {
        NewAreaViewController *vc = [[NewAreaViewController alloc] initWithNibName:@"NewAreaViewController" bundle:nil];
        if (_fromFirstPage) {
            vc.fromFirstPage = YES;
        }
        vc.parentId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"];
        if ([self.title isEqualToString:@"选择省份"]) {
            vc.title = @"选择城市";
        }
        else if ([self.title isEqualToString:@"选择城市"]) {
            vc.title = @"选择地区";
        }
        if (_fromFirstPage) {
            if (_parentName.length) {
                vc.parentName = [NSString stringWithFormat:@"%@-%@", _parentName, [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"]];
            }
            else {
                vc.parentName = [NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"]];
            }
        }
        else {
            vc.parentName = [NSString stringWithFormat:@"%@%@", _parentName, [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"regionName"]];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getData {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:_parentId forKey:@"parentId"];
    
    NSString *url = @"/region/get-by-parent";
    if ([self.title isEqualToString:@"选择街道"]) {
        url = @"/steet/get-by-parent";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", kSERVE_URL, url] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    NSArray *arr = [dic objectForKey:@"rows"];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arr];
    [_tableView reloadData];
    
    if ([self.title isEqualToString:@"选择街道"]) {
        if (self.dataSource.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"暂未覆盖，我们会加油哦！"];
        }
    }
}

@end

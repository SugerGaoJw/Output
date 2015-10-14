//
//  YouHuiViewController.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "YouHuiViewController.h"
#import "MyCouponTableViewCell.h"
#import "YouHuiMealCell.h"
#import "ConfirmOrderViewController.h"

@interface YouHuiViewController () {
    NSInteger _selectInt;
}

@end

@implementation YouHuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"优惠多";
    
    _selectInt = 0;
    
    self.refreshTableView = [[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionAll];
    self.refreshTableView.delegate = self;
    [self.refreshTableView reload];

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

- (IBAction)leftBtnClick:(id)sender {
    if (_selectInt == 0) {
        return;
    }
    _leftBtn.selected = YES;
    _rightBtn.selected = NO;
    _selectInt = 0;
    [self.refreshTableView reload];
}

- (IBAction)rightBtnClick:(id)sender {
    if (_selectInt == 1) {
        return;
    }
    _leftBtn.selected = NO;
    _rightBtn.selected = YES;
    _selectInt = 1;
    [self.refreshTableView reload];
}

- (void)buyBtnClick:(UIButton *)sender {
    
    NSMutableArray *arr = [NSMutableArray arrayWithObject:[self.dataSource objectAtIndex:sender.tag]];

    NSMutableDictionary *numDic = [[NSMutableDictionary alloc] init];
    [numDic setObject:@"1" forKey:[NSString stringWithFormat:@"%@", [[arr objectAtIndex:0] objectForKey:@"pkId"]]];
    
    ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
    vc.dataSource = arr;
    vc.numDic = numDic;
    vc.taoCan = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectInt == 0) {
        return 103;
    }
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectInt == 0) {
        static NSString *identifier = @"YouHuiMealCell";
        YouHuiMealCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YouHuiMealCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            [cell.buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.buyBtn.tag = indexPath.row;
        cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        static NSString *identifier = @"MyCouponTableViewCell";
        MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.getCouponBtn.hidden = NO;
            cell.getCouponLbl.hidden = NO;
            cell.stateLbl.hidden = YES;
            [cell.getCouponBtn addTarget:self action:@selector(getCouponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.getCouponBtn.tag = indexPath.row;
        cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getCouponBtnClick:(UIButton *)sender {
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[self.dataSource objectAtIndex:sender.tag] objectForKey:@"mrcPkId"] forKey:@"id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/receive-coupon/receive", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        [self.refreshTableView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        [self.refreshTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - CWRefreshTableViewDelegate
- (void)CWRefreshTableViewReloadTableViewDataSource:(CWRefreshTableViewPullType) refreshType {
    switch (refreshType) {
        case CWRefreshTableViewPullTypeReload: {
            self.refreshTableView.currentPageIndex = 1;
            [self loadNetData:self.refreshTableView.currentPageIndex];
        }
            break;
        case CWRefreshTableViewPullTypeLoadMore: {
            [self loadNetData:self.refreshTableView.currentPageIndex];
        }
            break;
    }
}

- (void)loadNetData:(int)pages {
    if(self.dataSource.count < self.pageTotal || pages == 1) {
        self.page = pages;
        [self getData];
    }
}

- (void)getData {
    NSString *url;
    if (_selectInt == 0) {
        url = @"/foods/page-by-special-offer";
    }
    else {
        url = @"/receive-coupon/page";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", kSERVE_URL, url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useData:tDic];
        }
        [self.refreshTableView dataSourceDidFinishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        [self.refreshTableView dataSourceDidFinishedLoading];
    }];
}

- (void)useData:(NSDictionary *)dic {
    if (self.refreshTableView.currentPageIndex == 1) {
        [self.dataSource removeAllObjects];
    }
    NSArray *arr = [dic objectForKey:@"rows"];

    [self.dataSource addObjectsFromArray:arr];

    self.pageTotal = [[dic objectForKey:@"total"] intValue];
    self.refreshTableView.totalPage = self.pageTotal / self.pageSize;
    if (self.pageTotal % self.pageSize != 0) {
        self.refreshTableView.totalPage++;
    }

    [_tableView reloadData];

}

@end

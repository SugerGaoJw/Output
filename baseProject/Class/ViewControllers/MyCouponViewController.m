//
//  MyCouponViewController.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponTableViewCell.h"

@interface MyCouponViewController ()

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的优惠券";
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyCouponTableViewCell";
    MyCouponTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"pageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:@"pageSize"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member-coupon/page", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

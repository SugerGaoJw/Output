//
//  PointViewController.m
//  baseProject
//
//  Created by Li on 15/3/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "PointViewController.h"
#import "PointCell.h"

@interface PointViewController () {
    NSString *_type;
}

@end

@implementation PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的积分";
    
    _type = @"Income";
    
    _tableView.tableFooterView = [UIView new];
    
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

- (IBAction)topBtnClick:(UIButton *)sender {
    if (sender.tag == 0 && ![_type isEqualToString:@"Income"]) {
        _type = @"Income";
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        [self.refreshTableView reload];
    }
    else if (sender.tag == 1 && ![_type isEqualToString:@"Expense"]) {
        _type = @"Expense";
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        [self.refreshTableView reload];
    }
}

#pragma mark - tableView data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PointCell";
    PointCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PointCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    MyOrderDetailViewController *vc = [[MyOrderDetailViewController alloc] initWithNibName:@"MyOrderDetailViewController" bundle:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
    [dic setObject:_type forKey:@"type"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/integral-record/page", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

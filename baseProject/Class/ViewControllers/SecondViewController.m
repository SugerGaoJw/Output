//
//  SecondViewController.m
//  IOS
//
//  Created by lihj on 14-2-8.
//  Copyright (c) 2014年 Lihj. All rights reserved.
//

#import "SecondViewController.h"
#import "MessageViewController.h"
#import "SecondTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "ConfirmOrderViewController.h"
#import "PayViewController.h"

@interface SecondViewController () {
    NSMutableArray *_typeArr;
}

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setRBtn:nil image:@"nav_chat.png" imageSel:nil target:self action:@selector(rightBtnClick)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单";
    
    _typeArr = [[NSMutableArray alloc] init];

    self.refreshTableView = [[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionAll];
    self.refreshTableView.delegate = self;
//    [self.refreshTableView reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.refreshTableView reload];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightBtnClick {
    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)topBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 0) {
        if (sender.selected) {
            [_typeArr addObject:@"HasPay"];
        }
        else {
            [_typeArr removeObject:@"HasPay"];
        }
    }
    else if (sender.tag == 1) {
        if (sender.selected) {
            [_typeArr addObject:@"NoPay"];
        }
        else {
            [_typeArr removeObject:@"NoPay"];
        }
    }
    else {
        if (sender.selected) {
            [_typeArr addObject:@"Close"];
        }
        else {
            [_typeArr removeObject:@"Close"];
        }
    }
    [self getData];
}

#pragma mark - tableView data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 142;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SecondTableViewCell";
    SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SecondTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.cancelBtn.tag = indexPath.row;
    cell.payBtn.tag = indexPath.row;
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyOrderDetailViewController *vc = [[MyOrderDetailViewController alloc] initWithNibName:@"MyOrderDetailViewController" bundle:nil];
    vc.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setBlock:^() {
        [self.refreshTableView reload];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelBtnClick:(UIButton *)sender {
    
    NSString *status = [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"status"];
    
    if ([status isEqualToString:@"待派送"]) {
        //取消订单
        NSMutableDictionary *dic = [self creatRequestDic];
        [dic setObject:[[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"] forKey:@"orderNumber"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/order/cancel", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [self.refreshTableView reload];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
    else if ([status isEqualToString:@"待付款"]) {
        //取消订单
        NSMutableDictionary *dic = [self creatRequestDic];
        [dic setObject:[[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"] forKey:@"orderNumber"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/order/cancel", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [self.refreshTableView reload];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
    else if ([status isEqualToString:@"订单成功"] || [status isEqualToString:@"订单关闭"] || [status isEqualToString:@"已退款"]) {
        //重新下单
        NSMutableArray *arr = [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"orderItem"];

        NSMutableDictionary *numDic = [[NSMutableDictionary alloc] init];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [numDic setObject:[NSString stringWithFormat:@"%@", [obj objectForKey:@"number"]] forKey:[NSString stringWithFormat:@"%@", [obj objectForKey:@"fkFsId"]]];
        }];
        
        ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        vc.dataSource = arr;
        vc.numDic = numDic;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payBtnClick:(UIButton *)sender {
    NSDictionary *dic = [self.dataSource objectAtIndex:sender.tag];
    PayViewController *vc = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
    vc.orderNum = [dic objectForKey:@"pkId"];
    vc.price = [dic objectForKey:@"total"];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (![PublicInstance instance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"请先登陆"];
        [self.dataSource removeAllObjects];
        [self.refreshTableView dataSourceDidFinishedLoading];
        [_tableView reloadData];
        return;
    }

    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"pageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageSize] forKey:@"pageSize"];
    [dic setObject:[_typeArr componentsJoinedByString:@","] forKey:@"selectType"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/order/page", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

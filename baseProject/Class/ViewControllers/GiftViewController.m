//
//  GiftViewController.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "GiftViewController.h"
#import "GiftTableViewCell.h"
#import "GiftPopViewController.h"
#import "UIViewController+CustomPopupViewController.h"
#import "ConfirmOrderViewController.h"

@interface GiftViewController ()

@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"礼品中心";
    
    _tableView.tableFooterView = [UIView new];
    
    self.refreshTableView = [[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionAll];
    self.refreshTableView.delegate = self;
    [self.refreshTableView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissBtnClick {
    [self dismissPopupViewControllerWithanimationType:CustomPopupViewAnimationFade];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)exchangeBtnClick:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithObject:[self.dataSource objectAtIndex:sender.tag]];
    ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
    vc.dataSource = arr;
    vc.gift = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)integralBtnClick:(UIButton *)sender
{
    GiftPopViewController *vc = [[GiftPopViewController alloc] initWithNibName:@"GiftPopViewController" bundle:nil];
    vc.view.backgroundColor = [UIColor clearColor];
//    [vc.disMissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [vc.lookBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    vc.tipLbl0.text = [NSString stringWithFormat:@"恭喜您获得 %@ 请查看！", [dic objectForKey:@"couponName"]];
//    vc.tipLbl1.text = [NSString stringWithFormat:@"此券可抵%@%@，适用于%@", [dic objectForKey:@"couponPrice"], [dic objectForKey:@"couponType"], [dic objectForKey:@"couponUseRegionDescription"]];
//    vc.tipLbl2.text = [NSString stringWithFormat:@"使用时间：%@-%@", dateStr, dateStr1];
    [self presentPopupView:vc.view animationType:CustomPopupViewAnimationFade];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic =[self.dataSource objectAtIndex:indexPath.row];
    static NSString *identifier = @"GiftTableViewCell";
    GiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GiftTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        [cell.exchangeBtn addTarget:self action:[self chooseSelector:cell.exchangeBtn currentDic:dic] forControlEvents:UIControlEventTouchUpInside];
    }
    cell.exchangeBtn.tag = indexPath.row;
    cell.dataDic = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    GiftPopViewController *vc = [[GiftPopViewController alloc] initWithNibName:@"GiftPopViewController" bundle:nil];
//    vc.view.backgroundColor = [UIColor clearColor];
//    [vc.dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self presentPopupView:vc.view animationType:CustomPopupViewAnimationFade];
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
#pragma mark - choose SEL
- (SEL)chooseSelector:(id)sender currentDic:(NSDictionary *)dataDic
{
    NSString *paymentCurrency = [dataDic objectForKey:@"paymentCurrency"];
    if ([paymentCurrency isEqualToString:@"Integral"]) {
        //积分
        return @selector(integralBtnClick:);
    }
    else if ([paymentCurrency isEqualToString:@"RMB"]) {
        //人民币
        return @selector(exchangeBtnClick:);
    }else
    {
        return @selector(exchangeBtnClick:);
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
    [manager POST:[NSString stringWithFormat:@"%@/gift-goods/page", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

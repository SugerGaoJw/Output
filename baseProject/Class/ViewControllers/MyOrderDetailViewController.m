//
//  MyOrderDetailViewController.m
//  baseProject
//
//  Created by Li on 15/2/6.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "MyOrderDetailTableViewCell.h"
#import "EvaluateViewController.h"
#import "PayViewController.h"
#import "ConfirmOrderViewController.h"

@interface MyOrderDetailViewController () {
    BOOL _evelute;
}

@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    _tableView.tableHeaderView = _headerView;
    
    
    [self initData];
    [self.dataSource addObjectsFromArray:[_dataDic objectForKey:@"orderItem"]];
    [_tableView reloadData];
    
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

- (void)initData {
    _nameLbl.text = [[_dataDic objectForKey:@"deliveryInfo"] objectForKey:@"consignee"];
    _phoneLbl.text = [_dataDic objectForKey:@"memberPhone"];
    _createTime.text = [_dataDic objectForKey:@"createTime"];
    _arriveTime.text = [_dataDic objectForKey:@"arrivalTime"];
    _addrLbl.text = [[_dataDic objectForKey:@"deliveryInfo"] objectForKey:@"address"];
    float h = [shareFun heightOfLabel:_addrLbl];
    _addrLbl.height = h;
    
    for (UIView *view in _footerView.subviews) {
        if (view.top > _addrLbl.top) {
            view.top = view.top + h - 21;
        }
    }
    _messageLbl.text = [_dataDic objectForKey:@"remark"];

    h = [shareFun heightOfLabel:_messageLbl];
    _messageLbl.height = h;
    
    for (UIView *view in _footerView.subviews) {
        if (view.top > _messageLbl.top) {
            view.top = view.top + h - 21;
        }
    }

    NSMutableArray *arr = [NSMutableArray array];
    NSArray *orderItem = [_dataDic objectForKey:@"orderItem"];
    for (NSDictionary *dic in orderItem) {
        NSString *cnName = [dic objectForKey:@"cnName"];
        if (!strIsEmpty(cnName)) {
            [arr addObject:[dic objectForKey:@"cnName"]];
        }
    }
    if (arr.count) {
        _couponLbl.text = [arr componentsJoinedByString:@"\n"];
        float h = [shareFun heightOfLabel:_couponLbl];
        _couponLbl.height = h;
    }
    _footerView.height = _couponLbl.bottom+30;
    _tableView.tableFooterView = _footerView;
    
    NSString *status = [_dataDic objectForKey:@"status"];
    
    _cancelBtn.left = 125;
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    
    if ([status isEqualToString:@"待派送"]) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* startDate     = [dateFormatter dateFromString:[_dataDic objectForKey:@"createTime"]];
        NSDate* toDate    = [ [ NSDate alloc] init];
        NSTimeInterval time = [toDate timeIntervalSinceDate:startDate];
        if (time <= 1200.0f) {
            _cancelBtn.hidden = NO;
        }
    }
    else if ([status isEqualToString:@"待付款"]) {
        _cancelBtn.hidden = NO;
        _payBtn.hidden = NO;
        _cancelBtn.left = 80;
    }
    else if ([status isEqualToString:@"订单成功"]) {
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    else if ([status isEqualToString:@"订单关闭"]) {
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
    else if ([status isEqualToString:@"已退款"]) {
        _cancelBtn.hidden = NO;
        [_cancelBtn setTitle:@"重新下单" forState:UIControlStateNormal];
    }
}

- (void)evaluateBtnClick:(UIButton *)sender {
    EvaluateViewController *vc = [[EvaluateViewController alloc] initWithNibName:@"EvaluateViewController" bundle:nil];
    vc.dataDic = _dataDic;
    vc.row = (int)sender.tag;
    [vc setBlock:^() {
        _evelute = YES;
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
        //取消订单
        NSMutableDictionary *dic = [self creatRequestDic];
        [dic setObject:[_dataDic objectForKey:@"pkId"] forKey:@"orderNumber"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/order/cancel", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                if (self.block) {
                    self.block();
                }
                [self backAction];
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
    else {
        //重新下单
        NSMutableArray *arr = [_dataDic objectForKey:@"orderItem"];
        
        NSMutableDictionary *numDic = [[NSMutableDictionary alloc] init];
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [numDic setObject:[NSString stringWithFormat:@"%@", [obj objectForKey:@"number"]] forKey:[NSString stringWithFormat:@"%@", [obj objectForKey:@"fkFsId"]]];
        }];

        ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        vc.dataSource = arr;
        vc.numDic = numDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)payBtnClick:(id)sender {
    PayViewController *vc = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
    vc.orderNum = [_dataDic objectForKey:@"pkId"];
    vc.price = [_dataDic objectForKey:@"total"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyOrderDetailTableViewCell";
    MyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderDetailTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.evaluateBtn addTarget:self action:@selector(evaluateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *status = [_dataDic objectForKey:@"status"];
        if ([status isEqualToString:@"订单成功"]) {

            cell.evaluateBtn.hidden = NO;
        }
        else {
#if !DEBUG_ENVIRONMENT
            cell.evaluateBtn.hidden = YES;
#endif
        }
    }
    cell.evalute = _evelute;
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.evaluateBtn.tag = indexPath.row;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

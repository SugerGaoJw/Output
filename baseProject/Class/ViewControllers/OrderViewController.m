//
//  OrderViewController.m
//  baseProject
//
//  Created by Li on 15/2/5.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "UIViewController+CustomPopupViewController.h"
#import "OrderDetailViewController.h"
#import "ConfirmOrderViewController.h"
#import "NewAddrViewController.h"

@interface OrderViewController () {
    UIButton *_titleSelctBtn;
    NSString *_sortType;
    OrderDetailViewController *_orderDetailVC;
    
}
//默认地址
@property (nonatomic, copy) NSDictionary* defaultDic;
@property (nonatomic, copy) NSString* defaultAdrStr;

@property (nonatomic, copy) NSMutableDictionary *numDic;
@property (nonatomic, copy) NSMutableArray *selectArr;

@end

@implementation OrderViewController

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"菜品";
    _tableView.tableFooterView = [UIView new];
    
    _titleSelctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleSelctBtn.frame = CGRectMake(0, 0, 320, __MainScreen_Height+44);
    _titleSelctBtn.backgroundColor = [UIColor blackColor];
    _titleSelctBtn.alpha = 0.0;
    [_titleSelctBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_titleSelctBtn];
    
    _popView.frame = CGRectMake(0, 108, 320, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];

    if (_subDic) {
        [[PublicInstance instance].orderArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[[obj objectForKey:@"pkId"] stringValue] isEqualToString:[[_subDic objectForKey:@"fkFcId"] stringValue]]) {
                _selectType = idx;
                *stop = YES;
            }
        }];
    }
    [_typeBtn setTitle:[[[PublicInstance instance].orderArr objectAtIndex:_selectType] objectForKey:@"name"] forState:UIControlStateNormal];
    
    _sortType = @"default";
    _numDic = [[NSMutableDictionary alloc] init];
    _selectArr = [[NSMutableArray alloc] init];
    
    if ([PublicInstance instance].orderArr.count == 0) {
        return;
    }
    
    self.refreshTableView = [[[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionAll] autorelease];
    self.refreshTableView.delegate = self;
    [self.refreshTableView reload];
}

- (void)dealloc {
    if (_orderDetailVC) {
        [_orderDetailVC release];
    }
    [_numDic release];
    [_selectArr release];
    [super dealloc];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestNetAddress];
}
#pragma mark - 默认地址动作
- (IBAction)doShowDefaultAdressAction:(UITapGestureRecognizer *)sender {
    if (_defaultDic == nil) {
        DLog(@"_defaultDic is null :%@",_defaultDic);
        return;
    }
    NewAddrViewController *vc = [[NewAddrViewController alloc] initWithNibName:@"NewAddrViewController" bundle:nil];
    vc.dataDic = _defaultDic;
    vc.update = YES;
//    vc.block = ^() {
//        [self requestNetAddress];
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 显示当前的默认地址
//显示默认地址
- (void)showDefaultAdress {
    if ([PublicInstance instance].isLogin == NO) {
        //未登录
        [self.defaultAdress setText:@"您还未登录，请先登录"];
    }else{
        
        if (_defaultAdrStr != nil
            && NO == [_defaultAdrStr isKindOfClass:[NSNull class]]
            && NO == [_defaultAdrStr length] <= 0 ) {
            //获取到默认地址
            [self.defaultAdress setText:_defaultAdrStr];
        }else{
            
            //没获取到默认地址
            [self.defaultAdress setText:@"请设置默认地址"];
        }
    }
}
//设置默认地址
- (void)setDefaultAdressValue:(NSString* )value {
    //set font value
    if (value.length > 20) {
        self.defaultAdress.font = [UIFont systemFontOfSize:13];
    }else{
        self.defaultAdress.font = [UIFont systemFontOfSize:15];
    }
    _defaultAdrStr = [NSString stringWithFormat:@"%@",value];
    [self showDefaultAdress];
}
//处理地址网络地址
- (void)handlerNetDefaultAdress:(NSArray *)adrArray {
   
    [adrArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary* entity = obj;
       BOOL isDefault = [[entity objectForKey:@"isDefault"] boolValue];
        if (isDefault) {
            NSString* defaultAdr = [entity objectForKey:@"allAddress"];
            [self setDefaultAdressValue:defaultAdr]; //显示默认地址
            _defaultDic = entity.copy; //保存当前默认地址字典
            *stop = YES;
        }
        
    }];
}

- (void)requestNetAddress {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/delivery/list", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            DLog(@"%@",[tDic objectForKey:@"message"]);
        }
        else {
            
            NSArray *arr = [tDic objectForKey:@"rows"];
            [self handlerNetDefaultAdress:arr];
        }
        [self.refreshTableView dataSourceDidFinishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
    }];
}

- (IBAction)orderBtnClick:(id)sender {
    if ([PublicInstance instance].isLogin == NO) {
        [SVProgressHUD showErrorWithStatus:@"您还未登录，请先登录"];
        return;
    }
    NSArray *arr = _numDic.allKeys;
    if (arr.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择套餐"];
        return;
    }
    [self.selectArr removeAllObjects];
    ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
    for (NSString *row in _numDic.allKeys) {
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *pkid = [NSString stringWithFormat:@"%@", [obj objectForKey:@"pkId"]];
            if ([pkid isEqualToString:[NSString stringWithFormat:@"%@", row]]) {
                [self.selectArr insertObject:obj atIndex:0];
                *stop = YES;
            }
        }];
    }
    vc.dataSource = self.selectArr;
    vc.numDic = self.numDic;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)sortBtnClick:(UIButton *)sender {
    if (sender.tag == 0) {
        _sortType = @"default";
    }
    else {
        _sortType = @"price";
    }
    [self.refreshTableView reload];
}

- (IBAction)typeBtnClick:(id)sender {
    if (_popView.hidden == YES) {
        _popView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^(){
            _popView.height = 44*7;
            _titleSelctBtn.alpha = 0.1;
        }completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^(){
            _popView.height = 0;
            _titleSelctBtn.alpha = 0.0;
        }completion:^(BOOL finished) {
            _popView.hidden = YES;
        }];
    }
}

- (void)dismissBtnClick {
    [self dismissPopupViewControllerWithanimationType:CustomPopupViewAnimationFade];
}

- (void)tipUpdate {
    float p = 0.0;
    int n = 0;
    for (NSString *row in _numDic.allKeys) {
        __block NSString *price;
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *pkid = [NSString stringWithFormat:@"%@", [obj objectForKey:@"pkId"]];
            if ([pkid isEqualToString:[NSString stringWithFormat:@"%@", row]]) {
                price = [obj objectForKey:@"price"];
                *stop = YES;
            }
        }];
        NSString *num = [_numDic objectForKey:row];
        n = n + [num intValue];
        p = p + [price floatValue] * [num intValue];
        DLog(@"%d,%f", n, p);
    }
    _tipLbl.text = [NSString stringWithFormat:@"￥%.1f/%d份", p, n];
}

#pragma mark - tableView data source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _popTableView) {
        return 44;
    }
    return 82;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _popTableView) {
        return [PublicInstance instance].orderArr.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _popTableView) {
        static NSString *identifier = @"popTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            
            UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-30, (44-12)/2, 12, 12)] autorelease];
            imgView.image = [UIImage imageNamed:@"03_2 点餐_下拉选中按钮"];
            imgView.tag = 100;
            [cell.contentView addSubview:imgView];
        }
        cell.textLabel.text = [[[PublicInstance instance].orderArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
        if (indexPath.row == _selectType) {
            imgView.hidden = NO;
            cell.textLabel.textColor = kRGBCOLOR(210, 64, 64);
        }
        else {
            imgView.hidden = YES;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        return cell;
    }
    else {
        static NSString *identifier = @"OrderTableViewCell";
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.couponBtn.hidden = YES;
        }
        
        __block __weak OrderViewController *selfVC = self;
        cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
        cell.numBlock = ^(NSString *num) {
            if ([num intValue] == 0) {
                [selfVC.numDic removeObjectForKey:[NSString stringWithFormat:@"%@", [[selfVC.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]];
            }
            else {
                [selfVC.numDic setObject:num forKey:[NSString stringWithFormat:@"%@", [[selfVC.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]];
            }
            [selfVC tipUpdate];
        };
        if ([_numDic objectForKey:[NSString stringWithFormat:@"%@", [[selfVC.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]]) {
            cell.countLbl.text = [_numDic objectForKey:[NSString stringWithFormat:@"%@", [[selfVC.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]];
        }
        else {
            cell.countLbl.text = @"0";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _popTableView) {
        _selectType = indexPath.row;
        [_typeBtn setTitle:[[[PublicInstance instance].orderArr objectAtIndex:indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
        [_popTableView reloadData];
        [self typeBtnClick:nil];
        [self.refreshTableView reload];
    }
    else {
        if (_orderDetailVC) {
            [_orderDetailVC release];
        }
        _orderDetailVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        _orderDetailVC.view.backgroundColor = [UIColor clearColor];
        _orderDetailVC.nameLbl.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
        _orderDetailVC.decLbl.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"description"];
        _orderDetailVC.priceLbl.text = [NSString stringWithFormat:@"￥%@", [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"price"]];
        if ([_numDic objectForKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]]) {
            _orderDetailVC.countLbl.text = [_numDic objectForKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"pkId"]]];
        }
        [_orderDetailVC.imgView sd_setImageWithURL:[NSURL URLWithString:[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
        [_orderDetailVC.dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.confirmBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.SubtracteBtn addTarget:self action:@selector(SubtracteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _orderDetailVC.plusBtn.tag = indexPath.row;
        _orderDetailVC.SubtracteBtn.tag = indexPath.row;
        [self presentPopupView:_orderDetailVC.view animationType:CustomPopupViewAnimationFade];
    }
}

- (void)SubtracteBtnClick:(UIButton *)sender {
    if ([_orderDetailVC.countLbl.text intValue] > 0) {
        _orderDetailVC.countLbl.text = [NSString stringWithFormat:@"%d", [_orderDetailVC.countLbl.text intValue]-1];
    }
    if ([_orderDetailVC.countLbl.text intValue] == 0) {
        [self.numDic removeObjectForKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"]]];
    }
    else {
        [self.numDic setObject:_orderDetailVC.countLbl.text forKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"]]];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self tipUpdate];
}

- (void)plusBtnClick:(UIButton *)sender {
    _orderDetailVC.countLbl.text = [NSString stringWithFormat:@"%d", [_orderDetailVC.countLbl.text intValue]+1];
    if ([_orderDetailVC.countLbl.text intValue] == 0) {
        [self.numDic removeObjectForKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"]]];
    }
    else {
        [self.numDic setObject:_orderDetailVC.countLbl.text forKey:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"pkId"]]];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self tipUpdate];
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
    [dic setObject:_sortType forKey:@"sort"];
    [dic setObject:[[[PublicInstance instance].orderArr objectAtIndex:_selectType] objectForKey:@"pkId"] forKey:@"categoryId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/foods/page-by-category", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    if (_subDic) {
        _orderDetailVC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        _orderDetailVC.view.backgroundColor = [UIColor clearColor];
        _orderDetailVC.nameLbl.text = [_subDic objectForKey:@"name"];
        _orderDetailVC.decLbl.text = [_subDic objectForKey:@"description"];
        _orderDetailVC.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_subDic objectForKey:@"price"]];
        [_orderDetailVC.imgView sd_setImageWithURL:[NSURL URLWithString:[_subDic objectForKey:@"imgUrl"]] forState:UIControlStateNormal];
        [_orderDetailVC.dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.confirmBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.SubtracteBtn addTarget:self action:@selector(SubtracteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_orderDetailVC.plusBtn addTarget:self action:@selector(plusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[[obj objectForKey:@"pkId"] stringValue] isEqualToString:[[_subDic objectForKey:@"pkId"] stringValue]]) {
                _orderDetailVC.plusBtn.tag = idx;
                _orderDetailVC.SubtracteBtn.tag = idx;
                *stop = YES;
            }
        }];
        
        [self presentPopupView:_orderDetailVC.view animationType:CustomPopupViewAnimationFade];
        _subDic = nil;
    }
}

@end

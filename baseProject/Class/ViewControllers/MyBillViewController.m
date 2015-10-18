//
//  MyBillViewController.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyBillViewController.h"
#import "MyBillTableViewCell.h"

@interface MyBillViewController () {
    
    __weak IBOutlet UIButton *_billProcessButton;//进行中
    __weak IBOutlet UIButton *_billAllButton; //全部
    __weak NSMutableArray* _billArray;
}
@property (nonatomic,strong)NSMutableArray* billAllArray; //进行中
@property (nonatomic,strong)NSMutableArray* billProcessBillArray; //全部
@end

@implementation MyBillViewController

g_lazyload_func(billAllArray, NSMutableArray)
g_lazyload_func(billProcessBillArray, NSMutableArray)



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的账单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refreshTableView = [[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionUp];
    self.refreshTableView.delegate = self;
    _billArray = self.billAllArray;
    
    [self getData];

    _tableView.tableFooterView = [UIView new];
   
    
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
    return _billArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyBillTableViewCell";
    MyBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyBillTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.dataDic = [_billArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - Bill Button Action
//选择section button 点击事件
- (IBAction)chooseBillButtonAction:(id)sender {
    
    BOOL isBillAll = [sender isEqual:_billAllButton];
    [_billAllButton setSelected:isBillAll];
    [_billProcessButton setSelected:!isBillAll];
    
    if (isBillAll) {
        _billArray = self.billAllArray;
        
    }else{
        _billArray = self.billProcessBillArray;
    }
    
    [_tableView reloadData];
}


//通过点击 筛选订单状态通过枚举
- (void)siftOutBillStateFormDataSource:(NSArray *)dataSource CompletedBlock:(void(^)())block {
    
    [self.billProcessBillArray  removeAllObjects];
    [self.billAllArray removeAllObjects];
    
    __weak typeof(self) wself = self;
    __block  NSMutableArray* array = nil;
    __block NSString* flagStr = nil;
    __block  NSDictionary* dic = nil;
    
    //for - loop
    [dataSource enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        /*
        dic = (NSDictionary *)obj;
        flagStr = [dic objectForKey:@"couponType"];
        
        if ([flagStr isEqualToString:@"进行中"]) {
            array = wself.billProcessBillArray;
            
        }else if ([flagStr isEqualToString:@"全部"]) {
            array = wself.billAllArray;
            
        }else{
            *stop = YES;
            DLog(@"sorry,don't this is %@",[dic objectForKey:@"couponType"]);
            return ;
        }*/
        /** －－－－－－－－DEBUG －－－－－－－－ **/
        array = wself.billAllArray;
        /** －－－－－－－－DEBUG －－－－－－－－ **/

        [array addObject:obj];
    }];
    
    //completed
    if (block)  block();
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
    [manager POST:[NSString stringWithFormat:@"%@/trade-record/page", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    //筛选订单状态
    [self siftOutBillStateFormDataSource:self.dataSource CompletedBlock:^{
          [_tableView reloadData];
    }];
    
    
    NSDictionary *statistics = [dic objectForKey:@"statistics"];
    NSString *income = [NSString stringWithFormat:@"%@", [statistics objectForKey:@"income"]];
    NSString *expense = [NSString stringWithFormat:@"%@", [statistics objectForKey:@"expense"]];
    
    _shouruLbl.text = income;
    _zhichuLbl.text = expense;
}

@end

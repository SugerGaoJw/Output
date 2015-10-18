//
//  MyCouponViewController.m
//  baseProject
//
//  Created by Li on 15/1/14.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponTableViewCell.h"

@interface MyCouponViewController (){
    
    //    折扣劵
    __weak IBOutlet UIButton *_saleOffButton;
    //    抵用劵
    __weak IBOutlet UIButton *_discountButton;
    
    __weak NSMutableArray* _couponArray;
    
}
@property (nonatomic,strong)NSMutableArray* saleOffCouponArray;
@property (nonatomic,strong)NSMutableArray* discountCouponArray;

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的优惠券";
    _couponArray = self.saleOffCouponArray;
    
    
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
    return _couponArray.count;
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
    cell.dataDic = [_couponArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dic =  [_couponArray objectAtIndex:indexPath.row];
    [self handlerCalbakCouponWithDic:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Coupon Button Action
- (IBAction)chooseCouponButtonAction:(UIButton *)sender {
    
    BOOL isSel = [sender isEqual:_saleOffButton];
    [_saleOffButton setSelected:isSel];
    [_discountButton setSelected:!isSel];
    
    if (isSel) {
        _couponArray = self.saleOffCouponArray;
        
    }else{
        _couponArray = self.discountCouponArray;
    }
    
    [_tableView reloadData];
}
//通过点击 筛选优惠劵通过枚举
- (void)siftOutCouponTypeFormDataSource:(NSArray *)dataSource CompletedBlock:(void(^)())block {
    
    [self.discountCouponArray  removeAllObjects];
    [self.saleOffCouponArray removeAllObjects];
    
    __weak typeof(self) wself = self;
     __block  NSDictionary* dic = nil;
     __block  NSMutableArray* array = nil;
    __block NSString* flagStr = nil;
    
    //for - loop
    [dataSource enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
            dic = (NSDictionary *)obj;
            flagStr = [dic objectForKey:@"couponType"];
            
            if ([flagStr isEqualToString:@"折扣"]) {
                array = wself.saleOffCouponArray;
                
            }else if ([flagStr isEqualToString:@"抵用"]) {
                array = wself.discountCouponArray;
                
            }else{
                *stop = YES;
                DLog(@"sorry,don't this is %@",[dic objectForKey:@"couponType"]);
                return ;
            }
            
            [array addObject:obj];
    }];
    
    //completed
    if (block)  block();
}


#pragma mark - CallBack Coupon
//处理点击 优惠劵cell 事件
- (void)handlerCalbakCouponWithDic:(NSDictionary *)dic {
    
    ENCouponType type = -1;
    if ([[dic objectForKey:@"couponType"] isEqualToString:@"折扣"]) {
        type = EnSaleOffCouponType ;
    }
    else if ([[dic objectForKey:@"couponType"] isEqualToString:@"抵用"]) {
        type = EnDiscountCouponType;
    }
    
    SEL sel = @selector(calBakCouponType:CouponNum:);
    if (_couponDelegate && [_couponDelegate respondsToSelector:sel]) {
        [_couponDelegate calBakCouponType:type CouponNum:[dic objectForKey:@"couponPrice"]];
    }
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
    
    
    [self siftOutCouponTypeFormDataSource:self.dataSource CompletedBlock:^{
        [_tableView reloadData];
    }];
}
#pragma mark - lozd load
g_lazyload_func(discountCouponArray, NSMutableArray)
g_lazyload_func(saleOffCouponArray, NSMutableArray)

@end

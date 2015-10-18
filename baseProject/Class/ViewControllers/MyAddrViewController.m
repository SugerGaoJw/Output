//
//  MyAddrViewController.m
//  baseProject
//
//  Created by Li on 15/1/15.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "MyAddrViewController.h"
#import "MyAddrTableViewCell.h"
#import "NewAddrViewController.h"
#import "BMapKit.h"

@interface MyAddrViewController () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>{
    
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}

@end

@implementation MyAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"送餐地址";
    [self setRBtn:@"新增" image:nil imageSel:nil target:self action:@selector(rightBtnClick)];
    
    _tableView.tableFooterView = [UIView new];
    
    self.refreshTableView = [[CWRefreshTableView alloc] initWithTableView:_tableView pullDirection:CWRefreshTableViewDirectionAll];
    self.refreshTableView.delegate = self;
    [self.refreshTableView reload];
    
    //    初始化百度地图
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnClick {
    NewAddrViewController *vc = [[NewAddrViewController alloc] initWithNibName:@"NewAddrViewController" bundle:nil];
    vc.block = ^() {
        [self.refreshTableView reload];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)locatedCurAddressAction:(id)sender {
    [_locService startUserLocationService];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TableView DataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableDictionary *dic = [self creatRequestDic];
        [dic setObject:[[self.dataSource objectAtIndex:row] objectForKey:@"pkId"] forKey:@"id"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/member/delivery/delete", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];

        [self.dataSource removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyAddrTableViewCell";
    MyAddrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAddrTableViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    NewAddrViewController *vc = [[NewAddrViewController alloc] initWithNibName:@"NewAddrViewController" bundle:nil];
    vc.dataDic = [self.dataSource objectAtIndex:indexPath.row];
    vc.update = YES;
    vc.block = ^() {
        [self.refreshTableView reload];
    };
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/delivery/list", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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


#pragma mark - BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate
- (void)willStartLocatingUser {
    [SVProgressHUD showWithStatus:@"定位中" maskType:SVProgressHUDMaskTypeClear];
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_locService stopUserLocationService];
    
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DLog(@"反geo检索发送成功");
    }
    else
    {
        DLog(@"反geo检索发送失败");
        [SVProgressHUD showErrorWithStatus:@"定位失败"];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    DLog(@"location error");
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
}

- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        NSString *province = result.addressDetail.province;
        NSString *city = result.addressDetail.city;
        NSString *district = result.addressDetail.district;
        [self getAreaId:province city:city area:district];
    }
    else {
        [SVProgressHUD dismiss];
        DLog(@"%d", error);
    }
}


- (void)getAreaId:(NSString *)province city:(NSString *)city area:(NSString *)area {
    
    NSMutableDictionary *tmpDic = [self creatRequestDic];
    [tmpDic setObject:province forKey:@"province"];
    [tmpDic setObject:city forKey:@"city"];
    [tmpDic setObject:area forKey:@"area"];
    
    NSString *url = [NSString stringWithFormat:@"%@/region/get-by-name", kSERVE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:@"暂未覆盖，我们会加油哦！"];
        }
        else {
            [SVProgressHUD dismiss];
            NewAddrViewController *vc = [[NewAddrViewController alloc] initWithNibName:@"NewAddrViewController" bundle:nil];
            vc.locateName = [NSString stringWithFormat:@"%@%@%@", province, city, area];
            vc.locateAreaId = [NSString stringWithFormat:@"%@", [tDic objectForKey:@"id"]];
            vc.block = ^() {
                [self getData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}


@end

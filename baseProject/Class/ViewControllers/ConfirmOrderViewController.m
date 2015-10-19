//
//  ConfirmOrderViewController.m
//  baseProject
//
//  Created by Li on 15/3/19.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "NewAddrViewController.h"
#import "OrderTableViewCell.h"
#import "PayViewController.h"
#import "MyAddrViewController.h"

@interface ConfirmOrderViewController () {
    NSInteger _selectAddrInt;
    NSMutableArray *_addrArr;
    NSMutableArray *_couponArr;
    UIButton *_titleSelctBtn;
    NSMutableDictionary *_couponDic;
    int _selectCoupon;
    NSString *_price;
    NSString *_pwd;
    
    NSString *_pkId;
}

@end

@implementation ConfirmOrderViewController

- (void)viewDidLayoutSubviews {
    if ([_tableView0 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView0 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView0 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView0 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView1 setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView1 setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"确认订单";
    _textView.placeholder = @"若有特殊需求请留言";
    _selectAddrInt = 0;
    _addrArr = [[NSMutableArray alloc] init];
    _couponArr = [[NSMutableArray alloc] init];
    _couponDic = [[NSMutableDictionary alloc] init];
    
    _pkId = @"pkId";
    if (self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:0];
        if ([dic objectForKey:@"foodsName"]) {
            _pkId = @"fkFsId";
        }
    }
    
    _titleSelctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleSelctBtn.frame = CGRectMake(0, 0, 320, __MainScreen_Height+44);
    _titleSelctBtn.backgroundColor = [UIColor blackColor];
    _titleSelctBtn.alpha = 0.0;
    [_titleSelctBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_titleSelctBtn];

    _timePopView.left = __MainScreen_Width/2-_timePopView.width/2;
    _timePopView.top = __MainScreen_Height/2-_timePopView.height/2;
    _couponPopView.left = __MainScreen_Width/2-_couponPopView.width/2;
    [[UIApplication sharedApplication].keyWindow addSubview:_timePopView];
    [[UIApplication sharedApplication].keyWindow addSubview:_couponPopView];
    
    [self getAddrData];
    [self tipUpdate];
    
    if (!_numDic) {
        _price = [NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:0] objectForKey:@"price"]];
        _tipLbl.text = [NSString stringWithFormat:@"￥%.1f/1份", [[[self.dataSource objectAtIndex:0] objectForKey:@"price"] floatValue]];
    }
    if (_gift) {
        _tipLbl.hidden = YES;
    }
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    
    [self setRBtn:@"新增" image:nil imageSel:nil target:self action:@selector(addAddrBtnClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNumDic:(NSMutableDictionary *)numDic {
    _numDic = [[NSMutableDictionary alloc] initWithDictionary:numDic];
}
- (void)rightBtnClick {
    
}


- (IBAction)typeBtnClick:(UIButton *)sender {
    NSString *paymentCurrency = [[self.dataSource objectAtIndex:0] objectForKey:@"paymentCurrency"];
    if (_gift && [paymentCurrency isEqualToString:@"Integral"]) {
        _pwd = @"";
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [al show];
        return;
    }
    if (sender == _orderBtn) {
        if (_addrArr.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择送餐地址"];
            return;
        }
        
        NSString *sepStr = [[_tipLbl.text componentsSeparatedByString:@"/"] objectAtIndex:1];
        NSString *countNum = [sepStr substringToIndex:sepStr.length-1];

        if (_taoCan) {
            int number = [[[self.dataSource objectAtIndex:sender.tag] objectForKey:@"number"] intValue];
            
            if (countNum.intValue > number) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"我们只剩下%d份特价套餐了", number]];
                return;
            }
        }
        if (countNum.intValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"您的套餐份数为零哦"];
            return;
        }
        
        _datePicker.minimumDate = [NSDate date];
        [UIView animateWithDuration:0.3f animations:^(){
            _titleSelctBtn.alpha = 0.1;
            _timePopView.alpha = 1.0f;
        }completion:^(BOOL finished) {
        }];
    }
    else if (_couponPopView.alpha == 0.0f && _timePopView.alpha == 0.0f) {
        [UIView animateWithDuration:0.3f animations:^(){
            _titleSelctBtn.alpha = 0.1;
            _couponPopView.alpha = 1.0f;
        }completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^(){
            _titleSelctBtn.alpha = 0.0;
            _timePopView.alpha = 0.0f;
            _couponPopView.alpha = 0.0f;
        }completion:^(BOOL finished) {
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)timeConfirmBtnClick:(id)sender {
    [self typeBtnClick:nil];
    
    PayViewController *vc = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
    vc.price = _price;
    vc.addressId = [[_addrArr objectAtIndex:_selectAddrInt] objectForKey:@"pkId"];
    if (!_textView.text.length) {
        vc.remark = @"";
    }
    else {
        vc.remark = _textView.text;
    }
    vc.dataSource = self.dataSource;
    vc.numDic = _numDic;
    vc.arrivalTime = _datePicker.date;
    vc.gift = _gift;
    vc.couponDic = _couponDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)couponBtnClick:(UIButton *)sender {
    _selectCoupon = (int)sender.tag;
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[self.dataSource objectAtIndex:sender.tag] objectForKey:_pkId] forKey:@"foodsId"];
    
    [SVProgressHUD show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member-coupon/page-by-foods-id", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [_couponArr removeAllObjects];
            NSArray *arr = [tDic objectForKey:@"rows"];
            [_couponArr addObjectsFromArray:arr];
            [_popTableView reloadData];
            if (_popTableView.contentSize.height > __MainScreen_Height-120) {
                _couponPopView.height = __MainScreen_Height-120;
            }
            else {
                _couponPopView.height = _popTableView.contentSize.height + _popTableView.top;
            }
            _couponPopView.top = __MainScreen_Height/2-_couponPopView.height/2+15;
            [self typeBtnClick:nil];
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (IBAction)locateBtnClick:(id)sender {
    [_locService startUserLocationService];
}

- (IBAction)addAddrBtnClick:(id)sender {
    NewAddrViewController *vc = [[NewAddrViewController alloc] initWithNibName:@"NewAddrViewController" bundle:nil];
    vc.block = ^() {
        [self getAddrData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tipUpdate {
    float p = 0.0;
    int n = 0;
    for (NSString *row in _numDic.allKeys) {
        __block NSString *price;
        __block int t_idx = -1;
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *pkid = [NSString stringWithFormat:@"%@", [obj objectForKey:_pkId]];
            if ([pkid isEqualToString:[NSString stringWithFormat:@"%@", row]]) {
                price = [obj objectForKey:@"price"];
                t_idx = (int)idx;
                *stop = YES;
            }
        }];
        NSString *num = [_numDic objectForKey:row];
        n = n + [num intValue];
        if ([_couponDic objectForKey:[NSString stringWithFormat:@"%d", t_idx]] && t_idx >= 0) {
            NSString *type = [[_couponDic objectForKey:[NSString stringWithFormat:@"%d", t_idx]] objectForKey:@"couponType"];
            NSString *couponPrice = [[_couponDic objectForKey:[NSString stringWithFormat:@"%d", t_idx]] objectForKey:@"couponPrice"];
            if ([type isEqualToString:@"折扣"]) {
                p = p+[price floatValue]*[couponPrice floatValue]/10+[price floatValue]*([num intValue]-1);
            }
            else if ([type isEqualToString:@"抵用"]) {
                p = p + [price floatValue] * [num intValue] - [couponPrice floatValue] ;
            }
        }
        else {
            p = p + [price floatValue] * [num intValue];
        }
        DLog(@"%d,%f", n, p);
    }
    _price = [NSString stringWithFormat:@"%f", p];
    _tipLbl.text = [NSString stringWithFormat:@"￥%.1f/%d份", p, n];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = CGSizeMake(textView.frame.size.width, CGFLOAT_MAX);
    
    NSDictionary *attribute = @{NSFontAttributeName: textView.font};

    CGRect rect = [textView.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
     NSStringDrawingUsesLineFragmentOrigin |
     NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    _textView.height = MAX(34, rect.size.height+16);
    _tableView1.top = _textView.bottom;
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _tableView1.top+_tableView1.height);

    DLog(@"%@", NSStringFromCGRect(rect));
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
    if (tableView == _tableView0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 1)];
        lbl.numberOfLines = 0;
        lbl.font = [UIFont systemFontOfSize:14];
        NSString *allAddress = [self.defaultAddressDictionary objectForKey:@"allAddress"];
//        [_addrArr objectAtIndex:indexPath.row]
        lbl.text = [allAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
//        float h = [shareFun heightOfLabel:lbl];
        return 60.f;
    }
    else if (tableView == _tableView1){
        return 115;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView0) {
        return 1;// _addrArr.count;
    }
    else if (tableView == _tableView1){
        return self.dataSource.count;
    }
    return _couponArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    if (tableView == _tableView0) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textColor =  [UIColor whiteColor];
            cell.backgroundColor = [UIColor redColor];
            
            cell.imageView.image = [UIImage imageNamed:@"03_2-矢量智能对象.png"];

        }
        NSDictionary *dic = self.defaultAddressDictionary;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"name"], [dic objectForKey:@"phone"]];
        NSString *allAddress = [dic objectForKey:@"allAddress"];
        cell.detailTextLabel.text = [allAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (row == _selectAddrInt) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    else if (tableView == _tableView1){
        static NSString *identifier = @"OrderTableViewCell";
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            [cell.couponBtn addTarget:self action:@selector(couponBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (!_numDic) {
                cell.subtractBtn.hidden = YES;
                cell.plustBtn.hidden = YES;
                cell.countLbl.hidden = YES;
                cell.couponBtn.hidden = YES;
            }
            if (_taoCan) {
                cell.couponBtn.hidden = YES;
            }
        }
        cell.couponBtn.tag = row;
        
        NSString *pkId = [NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:indexPath.row] objectForKey:_pkId]];

        __weak ConfirmOrderViewController *selfVC = self;
        cell.dataDic = [self.dataSource objectAtIndex:row];
        cell.numBlock = ^(NSString *num) {
            if ([num intValue] == 0) {
                [selfVC.numDic removeObjectForKey:pkId];
            }
            else {
                [selfVC.numDic setObject:num forKey:pkId];
            }
            [selfVC tipUpdate];
        };
        if ([_numDic objectForKey:pkId]) {
            cell.countLbl.text = [_numDic objectForKey:pkId];
        }
        else {
            cell.countLbl.text = @"0";
        }
        if ([_couponDic objectForKey:[NSString stringWithFormat:@"%d", row]]) {
            [cell.couponBtn setTitle:[[_couponDic objectForKey:[NSString stringWithFormat:@"%d", row]] objectForKey:@"couponName"] forState:UIControlStateNormal];
        }
        else {
            [cell.couponBtn setTitle:@"使用优惠券" forState:UIControlStateNormal];
        }

        return cell;
    }
    else {
        static NSString *identifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        NSDictionary *dic = [_couponArr objectAtIndex:row];
        cell.textLabel.text = [dic objectForKey:@"couponName"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (tableView == _tableView0) {
        /*if (row == _selectAddrInt) {
            return;
        }
        else {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_selectAddrInt inSection:0];
            _selectAddrInt = row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, oldIndexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }*/
        
        MyAddrViewController *vc = [[MyAddrViewController alloc] initWithNibName:@"MyAddrViewController" bundle:nil];
        vc.blkDidSelCell = ^(NSDictionary* cellDataSource) {
            _defaultAddressDictionary = cellDataSource.copy;
            [_tableView0 reloadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
    
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    else if (tableView == _popTableView) {
        [_couponDic setObject:[_couponArr objectAtIndex:row] forKey:[NSString stringWithFormat:@"%d", _selectCoupon]];
        [_tableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectCoupon inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self typeBtnClick:nil];
        [self tipUpdate];
    }
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

#pragma mark - request

- (void)getAddrData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/member/delivery/list", kSERVE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            _scrollView.hidden = YES;
        }
        else {
            [self useData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        _scrollView.hidden = YES;
    }];
}

- (void)useData:(NSDictionary *)dic {
    [_addrArr removeAllObjects];
    NSArray *arr = [dic objectForKey:@"rows"];
    
    for (int i=0; i<arr.count; i++) {
        NSDictionary *t_dic = [arr objectAtIndex:i];
        if ([[t_dic objectForKey:@"isDefault"] intValue] == 1) {
            _selectAddrInt = i;
            break;
        }
    }
    
    [_addrArr addObjectsFromArray:arr];
    [_tableView0 reloadData];
    
    _tableView0.height = _tableView0.contentSize.height;
    _textView.top = _tableView0.bottom-1;
    _tableView1.top = _textView.bottom;
    _tableView1.height = _tableView1.contentSize.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _tableView1.top+_tableView1.height);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //得到输入框
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        _pwd = textField.text;

        [self giftPostData];
    }
}

- (void)giftPostData {
    [SVProgressHUD show];
    
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[self.dataSource objectAtIndex:0] objectForKey:@"pkId"] forKey:@"goodsId"];
    [dic setObject:[[_addrArr objectAtIndex:_selectAddrInt] objectForKey:@"pkId"] forKey:@"deliveryAddressId"];
    [dic setObject:@"OnLine" forKey:@"payChannel"];
    if (!_textView.text.length) {
        [dic setObject:@"" forKey:@"remark"];
    }
    else {
        [dic setObject:_textView.text forKey:@"remark"];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/gift-order/buy", kSERVE_URL] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self useGiftData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useGiftData:(NSDictionary *)dic {

    NSMutableDictionary *tmpDic = [self creatRequestDic];
    [tmpDic setObject:[dic objectForKey:@"orderNumber"] forKey:@"orderNumber"];
    [tmpDic setObject:[shareFun md5:_pwd] forKey:@"paymentPassword"];
    [tmpDic setObject:@"Integral" forKey:@"currency"];
    
    NSString *url = [NSString stringWithFormat:@"%@/gift-order/accout-pay", kSERVE_URL];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"JSON: %@", responseObject);
        NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"下单成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
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
                [self getAddrData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}


@end

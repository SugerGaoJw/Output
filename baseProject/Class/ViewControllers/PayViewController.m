//
//  PayViewController.m
//  baseProject
//
//  Created by Li on 15/3/21.
//  Copyright (c) 2015年 Li. All rights reserved.
//

#import "PayViewController.h"
#import "NSObject+HXAddtions.h"
#import "NSDate+Helper.h"

@interface PayViewController () {
    NSString *_pwd;
    CGRect _goodsLabelRect; //当前菜品标签视图大小
}
//统计滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *statisticScrollView;
//菜品的滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *goodsScrollView;
//菜品标签视图
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付";
    
    _priceLbl.text = [NSString stringWithFormat:@"%.1f" , [_price floatValue]];
    _payBtn.enabled = NO;
    
    [self setRBtn:@"返回首页" image:nil imageSel:nil target:self action:@selector(rightBtnClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ScrollView Size
    //设置统计视图实际宽高
- (void)setStatisticScrollView:(UIScrollView *)statisticScrollView {
    _statisticScrollView = statisticScrollView;
    _statisticScrollView.contentSize = CGSizeMake(__MainScreen_Width, 90);
}
- (void)setGoodsLabel:(UILabel *)goodsLabel {
    _goodsLabel = goodsLabel;
    [_goodsLabel setNumberOfLines:0];
    _goodsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    // 测试字串
    NSString *s = @"这是一个测试！！！adsfsaf时发生发勿忘我勿忘我勿忘我勿忘我勿忘我阿阿阿阿阿阿阿阿阿阿阿阿阿啊00000000阿什顿。。。";
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    //设置一个行高上限
    CGSize size = CGSizeMake(__MainScreen_Width,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize =  [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    _goodsLabelRect = CGRectMake(8, 0, labelsize.width - 8, labelsize.height + 3);
    [_goodsLabel setFrame:_goodsLabelRect];
    _goodsLabel.text = s;
}
- (void)setGoodsScrollView:(UIScrollView *)goodsScrollView {
    _goodsScrollView = goodsScrollView;
    CGSize size = CGSizeMake(_goodsLabelRect.size.width, _goodsLabelRect.size.height);
    [_goodsScrollView setContentSize:size];
}
- (IBAction)payChannelBtnClick:(UIButton *)sender {
    for (int i=10; i<15; i++) {
        UIImageView *img = (UIImageView *)[self.view viewWithTag:i];
        if (sender.tag + 10 == i) {
            img.highlighted = YES;
        }
        else {
            img.highlighted = NO;
        }
    }
    _payBtn.enabled = YES;
}

- (IBAction)buyBtnClick:(id)sender {
    BOOL selectPayChannel;
    for (int i=10; i<15; i++) {
        UIImageView *img = (UIImageView *)[self.view viewWithTag:i];
        if (img.highlighted == YES) {
            selectPayChannel = YES;
            break;
        }
    }
    UIImageView *img = (UIImageView *)[self.view viewWithTag:14];

    if (!selectPayChannel) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
        return;
    }
    else if (img.highlighted) {
        _pwd = @"";
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [al show];
    }
    else {
        if (_gift) {
            [self giftPostData];
        }
        if (_orderNum) {
            [self orderNumPay];
        }
        else
            [self postData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //得到输入框
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        _pwd = [shareFun md5:textField.text];
        if (_gift) {
            [self giftPostData];
        }
        if (_orderNum) {
            [self orderNumPay];
        }
        else
            [self postData];
    }
}

- (void)postData {
    
    [SVProgressHUD show];
    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[NSString stringWithFormat:@"%@", _addressId] forKey:@"addressId"];
    [dic setObject:_remark forKey:@"remark"];
    [dic setObject:[NSString stringWithFormat:@"%ld000", (long)[_arrivalTime timeIntervalSince1970]] forKey:@"arrivalTime"];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *time = [dateFormatter stringFromDate:_arrivalTime];
//    NSDate *date = [dateFormatter dateFromString:time];
//    [dic setObject:[NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]] forKey:@"arrivalTime"];

    
    UIImageView *img = (UIImageView *)[self.view viewWithTag:10];
    if (img.highlighted) {
        [dic setObject:@"CoD" forKey:@"payChannel"];
    }
    else {
        [dic setObject:@"OnLine" forKey:@"payChannel"];
    }

    NSMutableArray *arr = [NSMutableArray array];

    NSString *_pkId = @"pkId";
    if (self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:0];
        if ([dic objectForKey:@"foodsName"]) {
            _pkId = @"fkFsId";
        }
    }
    
    for (NSString *row in _numDic.allKeys) {
        [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *pkid = [NSString stringWithFormat:@"%@", [obj objectForKey:_pkId]];
            if ([pkid isEqualToString:[NSString stringWithFormat:@"%@", row]]) {
                
                NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
                [dic0 setObject:[_numDic objectForKey:row] forKey:@"number"];
                [dic0 setObject:pkid forKey:@"foodsId"];
                
                NSDictionary *coupon = [_couponDic objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)idx]];
                if (coupon) {
                    [dic0 setObject:[coupon objectForKey:@"mcPkId"] forKey:@"couponId"];
                }
                
                [arr addObject:dic0];

                *stop = YES;
            }
        }];
    }
    if (!_numDic) {
        NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
        [dic0 setObject:@"1" forKey:@"number"];
        [dic0 setObject:[NSString stringWithFormat:@"%@", [[self.dataSource objectAtIndex:0] objectForKey:@"pkId"]] forKey:@"foodsId"];
        
        if (_couponDic) {
            NSDictionary *coupon = [_couponDic objectForKey:[NSString stringWithFormat:@"%d", 0]];
            if (coupon) {
                [dic0 setObject:[coupon objectForKey:@"mcPkId"] forKey:@"couponId"];
            }
        }
        
        [arr addObject:dic0];
    }
    
    [dic setObject:arr forKey:@"foods"];
    
    NSString *json = [NSString jsonStringWithDictionary:dic];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/buy", kSERVE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:data];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                  // 成功后的处理
                                                                  DLog(@"JSON: %@", responseObject);
                                                                  NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
                                                                  if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                                                                      [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
                                                                  }
                                                                  else {
                                                                      [self useData:tDic];
                                                                  }
                                                              }
                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                  // 失败后的处理
                                                                  DLog(@"%@", error);
                                                                  [SVProgressHUD showErrorWithStatus:@"支付失败"];
                                                              }];
    [manager.operationQueue addOperation:operation];
}

- (void)giftPostData {
    [SVProgressHUD show];

    NSMutableDictionary *dic = [self creatRequestDic];
    [dic setObject:[[self.dataSource objectAtIndex:0] objectForKey:@"pkId"] forKey:@"goodsId"];
    [dic setObject:[NSString stringWithFormat:@"%@", _addressId] forKey:@"deliveryAddressId"];
    UIImageView *img = (UIImageView *)[self.view viewWithTag:10];
    if (img.highlighted) {
        [dic setObject:@"CoD" forKey:@"payChannel"];
    }
    else {
        [dic setObject:@"OnLine" forKey:@"payChannel"];
    }
    [dic setObject:_remark forKey:@"remark"];
    
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
            [self useData:tDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
    }];
}

- (void)useData:(NSDictionary *)dic {
    UIImageView *img = (UIImageView *)[self.view viewWithTag:10];
    if (img.highlighted) {
        self.tabBarController.selectedIndex = 1;

        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"下单成功"];
        return;
    }
    img = (UIImageView *)[self.view viewWithTag:14];
    if (img.highlighted) {
        NSMutableDictionary *tmpDic = [self creatRequestDic];
        [tmpDic setObject:[dic objectForKey:@"orderNumber"] forKey:@"orderNumber"];
        [tmpDic setObject:_pwd forKey:@"paymentPassword"];
        
        if (_gift) {
            NSString *paymentCurrency = [[self.dataSource objectAtIndex:0] objectForKey:@"paymentCurrency"];
            if ([paymentCurrency isEqualToString:@"Integral"]) {
                [tmpDic setObject:@"Integral" forKey:@"currency"];
            }
            else if ([paymentCurrency isEqualToString:@"RMB"]) {
                [tmpDic setObject:@"RMB" forKey:@"currency"];
            }
        }
        
        NSString *url = [NSString stringWithFormat:@"%@/order/accout-payment", kSERVE_URL];
        if (_gift) {
            url = [NSString stringWithFormat:@"%@/gift-order/accout-pay", kSERVE_URL];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                self.tabBarController.selectedIndex = 1;

                [self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
    else {
        NSMutableDictionary *tmpDic = [self creatRequestDic];
        [tmpDic setObject:[dic objectForKey:@"orderNumber"] forKey:@"orderNumber"];
        
        NSString *url = [NSString stringWithFormat:@"%@/order/pay", kSERVE_URL];
        if (_gift) {
            url = [NSString stringWithFormat:@"%@/gift-order/pay", kSERVE_URL];
        }

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                self.tabBarController.selectedIndex = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
}

- (void)orderNumPay {
    UIImageView *img = (UIImageView *)[self.view viewWithTag:10];
    if (img.highlighted) {
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"下单成功"];
        return;
    }
    img = (UIImageView *)[self.view viewWithTag:14];
    if (img.highlighted) {
        NSMutableDictionary *tmpDic = [self creatRequestDic];
        [tmpDic setObject:_orderNum forKey:@"orderNumber"];
        [tmpDic setObject:_pwd forKey:@"paymentPassword"];
        
        NSString *url = [NSString stringWithFormat:@"%@/order/accout-payment", kSERVE_URL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                self.tabBarController.selectedIndex = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
    else {
        NSMutableDictionary *tmpDic = [self creatRequestDic];
        [tmpDic setObject:_orderNum forKey:@"orderNumber"];
        
        NSString *url = [NSString stringWithFormat:@"%@/order/pay", kSERVE_URL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:tmpDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *tDic = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[tDic objectForKey:@"MZCode"] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[tDic objectForKey:@"message"]];
            }
            else {
                self.tabBarController.selectedIndex = 1;
                [self.navigationController popToRootViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
        }];
    }
}

@end
